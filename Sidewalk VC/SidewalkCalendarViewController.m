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

@interface SidewalkCalendarViewController ()<SidewalkCalendarModelDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *sideCollectionView;
@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (strong, nonatomic) SidewalkCalendarModel *model;
@property (weak, nonatomic) IBOutlet UIButton *titleViewButton;
@property (strong, nonatomic) CategorySliderView *categoryFilterSlider;
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
    
    [self.titleViewButton setImage:[PvmntStyleKit imageOfPvmntLogo] forState:UIControlStateNormal];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kNSUserDefaultsHasPickedSchoolKey]) {
        [self performSegueWithIdentifier:@"Pick School Segue" sender:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSchoolChosenNotification) name:kSchoolPickerSchoolChosenNotification object:nil];
    }
    
    
    //CollectionView Setup
//    [self.mainCollectionView setCollectionViewLayout:[[UICollectionViewLayout alloc] init]];
    [self.mainCollectionView setDelegate:self];
    [self.mainCollectionView setDataSource:self];
    [self.sideCollectionView setDelegate:self];
    [self.sideCollectionView setDataSource:self];
    
    self.mainCollectionView.scrollsToTop = YES;
    self.sideCollectionView.scrollsToTop = NO;
    
    
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
    self.model.mode = SidewalkCalendarModelModeSidewalk;
    
    UIBarButtonItem *toggleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(handleViewTypeSwitch)];
    toggleButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = toggleButton;
    
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
    if (self.model.mode == SidewalkCalendarModelModeCalendar) {
        self.model.mode = SidewalkCalendarModelModeSidewalk;
        self.mainCollectionView.contentInset = UIEdgeInsetsZero;
        self.sideCollectionView.contentInset = UIEdgeInsetsZero;
        [UIView animateWithDuration:0.3f animations:^{
            self.sideCollectionView.alpha = 0;
//            self.sideCollectionView.backgroundColor = [UIColor whiteColor];
        }];
        
        
    } else {
        self.model.mode = SidewalkCalendarModelModeCalendar;
//        [UIView animateWithDuration:0.1 animations:^{
//            self.mainCollectionView.contentInset = UIEdgeInsetsMake(10, self.sideCollectionView.frame.size.width, 10, 0);
//
//        }];
               self.sideCollectionView.alpha = 1;
//        self.sideCollectionView.backgroundColor = [PvmntStyleKit sidewalkCalendarSideCollectionViewBackgroundColor];
//        self.sideCollectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
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
