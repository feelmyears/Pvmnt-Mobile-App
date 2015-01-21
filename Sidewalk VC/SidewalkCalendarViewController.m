//
//  SidewalkCalendarViewController.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/12/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import "SidewalkCalendarViewController.h"

#import "UIScrollView+SVPullToRefresh.h"
#import "CategoryFilterView.h"
#import "SWRevealViewController.h"
#import "UICollectionView+EmptyState.h"
#import "SchoolPickerViewController.h"
#import "PvmntStyleKit.h"
#import "EmptyStateView.h"
#import "FlyerCloseLookViewController.h"
#import "FlyerDB.h"
#import <SVProgressHUD/SVProgressHUD.h>

//Cells
#import "SidewalkFlyerImageHTKCollectionViewCell.h"
#import "SidewalkCalendarModel.h"
#import "CalendarSideDateFlyerHTKCollectionViewCell.h"
#import "CalendarSideDateCell.h"
#import "Flurry.h"

@interface SidewalkCalendarViewController ()<SidewalkCalendarModelDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *sideCollectionView;
@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (strong, nonatomic) SidewalkCalendarModel *model;
@property (weak, nonatomic) IBOutlet UIButton *titleViewButton;
@property (strong, nonatomic) CategorySliderView *categoryFilterSlider;
@property (strong, nonatomic) UIBarButtonItem *toggleButton;
@property (strong, nonatomic) UIBarButtonItem *sidewalkItem;
@property (strong, nonatomic) UIBarButtonItem *calendarItem;
@end

static NSString *SidewalkFlyerImageHTKCollectionViewCellIdentifier  = @"SidewalkFlyerImageHTKCollectionViewCellIdentifier";
static NSString *CalendarSideDateFlyerHTKCollectionViewCellIndentifier = @"CalendarSideDateFlyerHTKCollectionViewCellIndentifier";

@implementation SidewalkCalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    
//    [self.titleViewButton setImage:[PvmntStyleKit imageOfPvmntLogo] forState:UIControlStateNormal];
//    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[PvmntStyleKit imageOfPvmntLogo]];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_pvmnt_app"]];
    self.navigationItem.titleView = titleImageView;
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kNSUserDefaultsHasPickedSchoolKey]) {
        [self performSegueWithIdentifier:@"Pick School Segue" sender:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSchoolChosenNotification) name:kSchoolPickerSchoolChosenNotification object:nil];
    }
    
//    self.sidewalkItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SidewalkIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(handleViewTypeSwitch)];
//    self.calendarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CalendarIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(handleViewTypeSwitch)];
//    self.navigationItem.rightBarButtonItems = @[self.sidewalkItem, self.calendarItem];
//    self.calendarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, -30);
//    self.navigationItem.rightBarButtonItems = @[self.sidewalkItem, self.calendarItem];
    
    //CollectionView Setup
//    [self.mainCollectionView setCollectionViewLayout:[[UICollectionViewLayout alloc] init]];
    [self.mainCollectionView setDelegate:self];
    [self.mainCollectionView setDataSource:self];
    [self.sideCollectionView setDelegate:self];
    [self.sideCollectionView setDataSource:self];
    
    self.mainCollectionView.scrollsToTop = YES;
    self.sideCollectionView.scrollsToTop = NO;
//    
    self.toggleButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CalendarIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(handleViewTypeSwitch)];
    self.navigationItem.rightBarButtonItem = self.toggleButton;
    
    self.mainCollectionView.pagingEnabled = NO;
    [self.mainCollectionView registerClass:[SidewalkFlyerImageHTKCollectionViewCell class] forCellWithReuseIdentifier:SidewalkFlyerImageHTKCollectionViewCellIdentifier];
    [self.sideCollectionView registerNib:[UINib nibWithNibName:@"CalendarSideDateCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Side Date Cell"];
    [self.mainCollectionView registerClass:[CalendarSideDateFlyerHTKCollectionViewCell class] forCellWithReuseIdentifier:CalendarSideDateFlyerHTKCollectionViewCellIndentifier];
    
    self.mainCollectionView.backgroundColor = [UIColor clearColor];
    self.sliderView.backgroundColor = [PvmntStyleKit mainBlack];
    self.sideCollectionView.backgroundColor = [PvmntStyleKit sidewalkCalendarSideCollectionViewBackgroundColor];
    self.sideCollectionView.alpha = 0;
    
    self.model = [SidewalkCalendarModel new];
    self.model.delegate = self;
    [self handleViewTypeSwitch];
    
    
    [self.mainCollectionView addPullToRefreshWithActionHandler:^{
        [[FlyerDB sharedInstance] fetchAllWithCompletionBlock:^{
            [self.mainCollectionView.pullToRefreshView stopAnimating];
        }];
    } position:SVPullToRefreshPositionTop];
    
    [self initialFetch];
}

- (void)handleSchoolChosenNotification
{
    [self initialFetch];
}

- (void)handleViewTypeSwitch
{
    if (self.model.mode == SIdewalkCalendarModelModeNone) {
        self.model.mode = SidewalkCalendarModelModeSidewalk;
        [Flurry logEvent:kFlurryUsingSidewalkViewKey timed:YES];
        self.toggleButton.image = [UIImage imageNamed:@"CalendarIcon"];
        self.sidewalkItem.enabled = NO;
    } else if (self.model.mode == SidewalkCalendarModelModeCalendar) {
        self.model.mode = SidewalkCalendarModelModeSidewalk;
        self.toggleButton.image = [UIImage imageNamed:@"CalendarIcon"];
        self.sidewalkItem.enabled = NO;
        self.calendarItem.enabled = YES;
        [Flurry endTimedEvent:kFlurryUsingCalendarViewKey withParameters:nil];
        [Flurry logEvent:kFlurryUsingSidewalkViewKey timed:YES];
        [UIView animateWithDuration:0.3f animations:^{
            self.sideCollectionView.alpha = 0;
        }];
    } else {
        [Flurry endTimedEvent:kFlurryUsingSidewalkViewKey withParameters:nil];
        [Flurry logEvent:kFlurryUsingCalendarViewKey timed:YES];
        self.model.mode = SidewalkCalendarModelModeCalendar;
        self.toggleButton.image = [UIImage imageNamed:@"SidewalkIcon"];
        self.sidewalkItem.enabled = YES;
        self.calendarItem.enabled = NO;
        self.sideCollectionView.alpha = 1;
    }
    
    [self.mainCollectionView performBatchUpdates:^{
        [self.mainCollectionView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.mainCollectionView numberOfSections])]];
        [self.mainCollectionView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self numberOfSectionsInCollectionView:self.mainCollectionView])]];
    } completion:^(BOOL finished) {
        [self.mainCollectionView reloadData];
    }];
    
    [self.sideCollectionView performBatchUpdates:^{
        [self.sideCollectionView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.sideCollectionView numberOfSections])]];
        [self.sideCollectionView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self numberOfSectionsInCollectionView:self.sideCollectionView])]];
    } completion:^(BOOL finished) {
        [self.sideCollectionView reloadData];
    }];
    
    [self.mainCollectionView updatePullToRefreshInsets];
    
}
- (void)initialFetch
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kNSUserDefaultsHasPickedSchoolKey]) {
        [SVProgressHUD show];
        [[FlyerDB sharedInstance] fetchAllWithCompletionBlock:^{
            [SVProgressHUD dismiss];
            [self.model refreshDatabase];
            
            [self.sliderView addSubview:[[CategoryFilterView alloc] initWithFrame:self.sliderView.frame andCategorySelectionBlock:^(UIView *categoryView, NSInteger categoryIndex) {
                
                [self.model filterWithCategoryName:((PvmntCategorySliderLabel *)categoryView).text];
                [self.mainCollectionView setContentOffset:CGPointZero animated:YES];
                
            }]];
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



#pragma mark - UICollectionView Implementation
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.mainCollectionView.collectionViewLayout invalidateLayout];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (self.model.mode) {
        case SidewalkCalendarModelModeCalendar: {
            if (collectionView == self.mainCollectionView) {
                return [self.model numberOfItemsInSection:section];
            } else if (collectionView == self.sideCollectionView) {
                return 1;
            } else return 0;
        }
        case SidewalkCalendarModelModeSidewalk: {
            if (collectionView == self.mainCollectionView) {
                return [self.model numberOfItemsInSection:section];
            } else return 0;
        }
        default:
            return 0;
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    switch (self.model.mode) {
        case SidewalkCalendarModelModeCalendar: {
            return [self.model numberOfSections];
        }
        case SidewalkCalendarModelModeSidewalk: {
            if (collectionView == self.mainCollectionView) {
                return [self.model numberOfSections];
            } else return 0;
        }
        default:
            return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.model.mode) {
        case SidewalkCalendarModelModeCalendar: {
            if (collectionView == self.mainCollectionView) {
                CalendarSideDateFlyerHTKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CalendarSideDateFlyerHTKCollectionViewCellIndentifier forIndexPath:indexPath];
                
                CD_V2_Flyer *flyerForCell = [self.model flyerAtIndexPath:indexPath];
                //        calendarListCell.flyerForCell = flyerForCell;
                [cell setupWithFlyer:flyerForCell];
                //        NSLog(@"%@ - %@", flyerForCell.title, flyerForCell.event_time.shortDateString);
                
                return cell;
            } else if (collectionView == self.sideCollectionView) {
                static NSString *cellIdentifier = @"Blank Side Cell";
                UICollectionViewCell *blankSideCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
                return blankSideCell;
            } else return nil;
        }
        case SidewalkCalendarModelModeSidewalk: {
            SidewalkFlyerImageHTKCollectionViewCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:SidewalkFlyerImageHTKCollectionViewCellIdentifier forIndexPath:indexPath];
            CD_V2_Flyer *flyerForCell = [self.model flyerAtIndexPath:indexPath];
            [imageCell setupCellWithFlyer:flyerForCell];
            imageCell.layer.zPosition = 0;
            //            imageCell.clipsToBounds = YES;
            return imageCell;
        }
        default:
            return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (self.model.mode) {
        case SidewalkCalendarModelModeCalendar: {
            if (collectionView == self.sideCollectionView) {
                NSUInteger section = indexPath.section;
                NSUInteger numItemsInSection = [self.mainCollectionView numberOfItemsInSection:section];
                CGFloat heightForCell = -[self collectionView:self.sideCollectionView layout:self.sideCollectionView.collectionViewLayout referenceSizeForHeaderInSection:section].height;
                for (NSUInteger row = 0; row < numItemsInSection; row++) {
                    CGSize sizeForCellAtIndexPath = [self collectionView:self.mainCollectionView layout:self.mainCollectionView.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                    heightForCell += sizeForCellAtIndexPath.height;
                }
                
                NSUInteger numEventsInSection = numItemsInSection;
                heightForCell += 10 * (numEventsInSection);
                
                return CGSizeMake(collectionView.frame.size.width, heightForCell);
            } else if (collectionView == self.mainCollectionView) {
                CGSize defaultSize = DEFAULT_FLYER_CELL_SIZE;
                CD_V2_Flyer *flyerForCell = [self.model flyerAtIndexPath:indexPath];
                CGSize cellSize = [CalendarSideDateFlyerHTKCollectionViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
                    [((CalendarSideDateFlyerHTKCollectionViewCell *)cellToSetup) setupWithFlyer:flyerForCell];
                    return cellToSetup;
                }];
                //        NSLog(@"Cell size for %@: \n[%f, %f]", flyerForCell.title, cellSize.height, cellSize.width);
                return cellSize;
                
            } else return CGSizeMake(0, 0);
        }
        case SidewalkCalendarModelModeSidewalk: {
            CD_V2_Flyer *flyerForCell = [self.model flyerAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
            CGSize fullSize = [SidewalkFlyerImageHTKCollectionViewCell sizeForCellWithImage:flyerForCell.image];
            return fullSize;
        }
        default:
            return CGSizeZero;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    switch (self.model.mode) {
        case SidewalkCalendarModelModeCalendar: {
            if (collectionView == self.sideCollectionView && kind == UICollectionElementKindSectionHeader) {
                static NSString *cellIdentifier = @"Side Date Cell";
                CalendarSideDateCell *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier forIndexPath:indexPath];
                
                NSDate *dateForSection = [self.model dateForSection:indexPath.section];
                header.dateForHeader = dateForSection;
                header.backgroundColor = [PvmntStyleKit calendarSidebar];
                return header;
            } else return nil;

        }
        case SidewalkCalendarModelModeSidewalk: {
            return nil;
        }
        default:
            return nil;
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    switch (self.model.mode) {
        case SidewalkCalendarModelModeCalendar: {
            if (collectionView == self.mainCollectionView) {
                CGFloat topInset;
                if (section == 0) {
                    topInset = 10;
                } else {
                    topInset = 0;
                }
//                return UIEdgeInsetsMake(topInset, self.sideCollectionView.frame.size.width, 10, 0);
                return UIEdgeInsetsMake(topInset, 0, 10, 0);
            } else if (collectionView == self.sideCollectionView) {
                CGFloat topInset;
                if (section == 0) {
                    topInset = 10;
                } else {
                    topInset = 0;
                }
                return UIEdgeInsetsMake(topInset, 0,0,0);
            }
            
        }
        case SidewalkCalendarModelModeSidewalk: {
            return UIEdgeInsetsZero;
        }
        default:
            return UIEdgeInsetsZero;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    switch (self.model.mode) {
        case SidewalkCalendarModelModeCalendar: {
            if (collectionView == self.sideCollectionView) {
                return CGSizeMake(collectionView.frame.size.width, 60);
            } else {
                return CGSizeMake(0, 0);
            }
        }
        case SidewalkCalendarModelModeSidewalk: {
            return CGSizeZero;
        }
        default:
            return CGSizeZero;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.model.mode == SidewalkCalendarModelModeCalendar && scrollView == self.mainCollectionView) {
            CGPoint contentOffset = scrollView.contentOffset;
            contentOffset.y = contentOffset.y - _sideCollectionView.contentInset.top;
            contentOffset.x = 0;
            _sideCollectionView.contentOffset = contentOffset;
        }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"Flyer Close Up Segue" sender:[self.model flyerAtIndexPath:indexPath]];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Flyer Close Up Segue"] && [segue.destinationViewController isMemberOfClass:[FlyerCloseLookViewController class]]) {
        FlyerCloseLookViewController *flyerCloseLookVC = segue.destinationViewController;
        flyerCloseLookVC.flyer = sender;
    }
}

#pragma mark - CalendarSideModelDelegate Implementation
- (void)removeItemsAtIndexes:(NSArray *)indexesToRemove addItemsAtIndexes:(NSArray *)indexesToAdd dateSectionsToRemove:(NSIndexSet *)sectionsToRemove dateSectionsToAdd:(NSIndexSet *)sectionsToAdd
{
    [self.mainCollectionView reloadData];
    [self.sideCollectionView reloadData];
}

- (void)removeSectionsInIndexSet:(NSIndexSet *)sectionsToRemove addSectionsIndexSet:(NSIndexSet *)sectionsToAdd
{
    [self.mainCollectionView performBatchUpdates:^{
        [self.mainCollectionView deleteSections:sectionsToRemove];
        [self.mainCollectionView insertSections:sectionsToAdd];
    } completion:^(BOOL finished) {
    }];
}


@end
