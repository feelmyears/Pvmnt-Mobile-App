//
//  SidewalkViewController.m
//  pmvnt
//
//  Created by Phil Meyers IV on 8/8/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import "SidewalkViewController.h"
#import <TLLayoutTransitioning/TLTransitionLayout.h>
#import <TLLayoutTransitioning/UICollectionView+TLTransitioning.h>
#import "FlyerDetailCollectionViewController.h"
#import "BFNavigationBarDrawer.h"
#import "SearchBar.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"

#import "EventTypeTableViewController.h"
#import "SWRevealViewController.h"

#import "FlyerDB.h"
#import "v1_Flyer.h"
#import "EventInforViewController.h"
#import "CD_V2_Flyer.h"
#import "CD_Image.h"
#import "SidewalkTitleHTKCollectionViewCell.h"
#import "SidewalkCombinedHTKCollectionViewCell.h"
#import "SidewalkFlyerImageHTKCollectionViewCell.h"
#import "Colours.h"

#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFBlurSegue/AFBlurSegue.h>
#import <BlurryModalSegue/BlurryModalSegue.h>

#import "AppDelegate.h"
//#import "PVMNT_CONSTANTS.h"

#import <TLYShyNavBar/TLYShyNavBarManager.h>
#import <FNShyTabBar/FNShyTabBar.h>
#import <AMScrollingNavbar/UIViewController+ScrollingNavbar.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UICollectionView+EmptyState.h"

#import "SchoolPickerViewController.h"
#import "KxMenu.h"
#import "LMDropdownView.h"
#import "FilterTableViewController.h"
#import <ionicons/IonIcons.h>
#import "PvmntStyleKit.h"

#import "CategorySliderView.h"
#import "PvmntCategorySliderLabel.h"
#import "FeedEventInfoHTKCollectionViewCell.h"
#import "SidewalkCollectionViewFlowLayout.h"
#import <UINavigationBar+Addition/UINavigationBar+Addition.h>
#import "EmptyStateView.h"
#import "CategoryFilterView.h"

static NSString *SidewalkTitleHTKCollectionViewCellIdentifier       = @"SidewalkTitleHTKCollectionViewCellIdentifier";
static NSString *SidewalkCombinedHTKCollectionViewCellIdentifier    = @"SidewalkCombinedHTKCollectionViewCellIdentifier";
static NSString *SidewalkFlyerImageHTKCollectionViewCellIdentifier  = @"SidewalkFlyerImageHTKCollectionViewCellIdentifier";
static NSString *FeedEventInfoHTKCollectionViewCellIdentifier       = @"FeedEventInfoHTKCollectionViewCellIdentifier";


@interface SidewalkViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (strong, nonatomic) SidewalkModel *model;
@property (nonatomic) BOOL refreshing;
@property (strong, nonatomic) NSMutableDictionary *filterDictionary;
@property (strong, nonatomic) LMDropdownView *dropdownMenu;
@property (strong, nonatomic) FilterTableViewController *filterTableVC;
@property (strong, nonatomic) CategorySliderView *categoryFilterSlider;
@end

CGFloat const SIDEWALK_COLLECTION_VIEW_PADDING = 0.;
CGFloat const SIDEWALK_COLLECTION_VIEW_TOP_INSET = 0.f;
CGFloat const SIDEWALK_COLLECTION_VIEW_BOTTOM_INSET = 00.f;
static CGFloat spacing = 12.5;


@implementation SidewalkViewController
- (FilterTableViewController *)filterTableVC
{
    if (!_filterTableVC) {
        _filterTableVC = [[FilterTableViewController alloc] init];
//        _filterTableVC.cellHeight = self.collectionView.bounds.size.height/((CGFloat)_filterTableVC.numCells);
        _filterTableVC.cellHeight = 60;
        _filterTableVC.tableView.contentMode = UIViewContentModeRedraw;
        [_filterTableVC.tableView setBounds:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, [self.filterTableVC heightForTable])];
        [_filterTableVC.view setBounds:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, [self.filterTableVC heightForTable])];
        _filterTableVC.tableView.clipsToBounds = YES;
    }
    return _filterTableVC;
}


- (LMDropdownView *)dropdownMenu
{
    if (!_dropdownMenu) {
        _dropdownMenu = [[LMDropdownView alloc] init];
        _dropdownMenu.menuBackgroundColor = [UIColor whiteColor];
        _dropdownMenu.menuContentView = self.filterTableVC.tableView;
    }
    return _dropdownMenu;
}
/*
- (CategorySliderView *)categoryFilterSlider
{
    if (!_categoryFilterSlider) {
        NSMutableArray *categoryNames = [[[[FlyerDB sharedInstance] allCategoriesSortedByName] valueForKey:@"name"] mutableCopy];
        [categoryNames insertObject:@"all" atIndex:0];
        NSMutableArray *categoryViews = [[NSMutableArray alloc] initWithCapacity:categoryNames.count];
        UIColor *highlightedColor = [PvmntStyleKit pureWhite];
        UIColor *standardColor = [PvmntStyleKit pureWhite];
        CGFloat sliderHeight = 35.f;
        UIFont *font = [UIFont fontWithName:@"OpenSans" size:19];
        for (NSString *categoryName in categoryNames) {
            CGFloat width = [categoryName sizeWithAttributes:@{NSFontAttributeName:font}].width;
            
            PvmntCategorySliderLabel *label = [[PvmntCategorySliderLabel alloc] initWithFrame:CGRectMake(0, 0, width, sliderHeight)];
            [label setFont:font];
            [label setText:categoryName];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setHighlightColor:highlightedColor];
            [label setStandardColor:standardColor];
            [label setTextColor:standardColor];
            [categoryViews addObject:label];
        }
        _categoryFilterSlider = [[CategorySliderView alloc] initWithFrame:CGRectMake(0, -sliderHeight, self.view.frame.size.width, sliderHeight)
                                                         andCategoryViews:categoryViews
                                                          sliderDirection:SliderDirectionHorizontal
                                                   categorySelectionBlock:^(UIView *categoryView, NSInteger categoryIndex) {
                                                       if (self.model.expandedSection >= 0 && self.model.filterString && ![self.model.filterString isEqualToString:((PvmntCategorySliderLabel *)categoryView).text]) {
                                                           [self toggleDescriptionCellViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.model.expandedSection]];
                                                       }
                                                       [self.model filterWithCategoryName:((PvmntCategorySliderLabel *)categoryView).text];
                                                   }];
        [_categoryFilterSlider setBackgroundColor:[PvmntStyleKit calendarSidebar]];
//        [self.view addSubview:_categoryFilterSlider];
    }
    return _categoryFilterSlider;
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar hideBottomHairline];

    UIButton *pvmntLogo = [UIButton new];
    [pvmntLogo setTitle:@"Pvmnt" forState:UIControlStateNormal];
    pvmntLogo.titleLabel.font = [UIFont fontWithName:@"Lobster" size:30.];
    [pvmntLogo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.titleView = pvmntLogo;
    
    self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.tintColor = [UIColor blackColor];
    self.tabBarController.tabBar.translucent = NO;
    self.title = @"Sidewalk";
    
//    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(handleFilterButtonTap)];
//    self.navigationItem.rightBarButtonItem = filterButton;
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kNSUserDefaultsHasPickedSchoolKey]) {
        [self performSegueWithIdentifier:@"Pick School Segue" sender:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSchoolChosenNotification) name:kSchoolPickerSchoolChosenNotification object:nil];
    }

    
    //CollectionView Setup
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SidewalkFlyerCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"Flyer Cell"];
    [self.collectionView registerClass:[SidewalkTitleHTKCollectionViewCell class] forCellWithReuseIdentifier:SidewalkTitleHTKCollectionViewCellIdentifier];
    [self.collectionView registerClass:[FeedEventInfoHTKCollectionViewCell class] forCellWithReuseIdentifier:FeedEventInfoHTKCollectionViewCellIdentifier];
    [self.collectionView registerClass:[SidewalkFlyerImageHTKCollectionViewCell class] forCellWithReuseIdentifier:SidewalkFlyerImageHTKCollectionViewCellIdentifier];
//    [self.collectionView registerClass:[SidewalkTitleHTKCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SidewalkTitleHTKCollectionViewCellIdentifier];
    
    self.collectionView.backgroundColor = [PvmntStyleKit mainBlack];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.collectionView setCollectionViewLayout:[[SidewalkCollectionViewFlowLayout alloc] init]];
    
    self.model = [[SidewalkModel alloc] init];
    self.model.delegate = self;
    
//    self.shyNavBarManager.scrollView = self.collectionView;
//    [self followScrollView:self.collectionView usingTopConstraint:self.topLayoutConstraint];
//    [self.tabBarController.shyTabBar setTrackingView:self.collectionView];
    

    
    [self.collectionView addPullToRefreshWithActionHandler:^{
        self.refreshing = YES;
        [[FlyerDB sharedInstance] fetchAllWithCompletionBlock:^{
            [self.collectionView.pullToRefreshView stopAnimating];

//            [self.collectionView reloadData];
            self.refreshing = NO;
        }];
    } position:SVPullToRefreshPositionTop];
  
    [self initialFetch];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGSize emptyStateSize = CGSizeMake(285, 183);
    self.collectionView.emptyState_view = [[EmptyStateView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - (emptyStateSize.width)/2.0,
                                                                                           CGRectGetMidY(self.view.frame) - (emptyStateSize.height)/2.0,
                                                                                           emptyStateSize.width,
                                                                                           emptyStateSize.height)];
    self.collectionView.emptyState_view.backgroundColor = [UIColor clearColor];
    self.collectionView.emptyState_showAnimationDuration = 0.2;
    self.collectionView.emptyState_hideAnimationDuration = 0;
    self.collectionView.emptyState_showDelay = 0.1;
}
- (void)handleSchoolChosenNotification
{
    [self initialFetch];
}

- (void)handleFilterButtonTap
{
    NSTimeInterval animationDuration = 0.2;
    if ([self.view.subviews containsObject:self.categoryFilterSlider]) {
        CGRect newFrame = self.categoryFilterSlider.frame;
        newFrame.origin.y = -CGRectGetHeight(newFrame);
        
        UIEdgeInsets newInsets = self.collectionView.contentInset;
        newInsets.top -= CGRectGetHeight(newFrame);
        CGPoint contentOffset = self.collectionView.contentOffset;
        contentOffset.y += CGRectGetHeight(newFrame);
        
        [UIView animateWithDuration:animationDuration animations:^{
            [self.categoryFilterSlider setFrame:newFrame];
            
            self.collectionView.contentInset = newInsets;
            self.collectionView.contentOffset = contentOffset;
        } completion:^(BOOL finished) {
            [self.categoryFilterSlider removeFromSuperview];
            [self.model filterWithCategoryName:nil];
            [self.collectionView reloadData];
        }];
        
    } else {
        [self.view addSubview:self.categoryFilterSlider];
        CGRect newFrame = self.categoryFilterSlider.frame;
        newFrame.origin.y = 0;
        
        UIEdgeInsets newInsets = self.collectionView.contentInset;
        newInsets.top += CGRectGetHeight(newFrame);
        CGPoint contentOffset = self.collectionView.contentOffset;
        contentOffset.y -= CGRectGetHeight(newFrame);
        
        [UIView animateWithDuration:animationDuration animations:^{
            [self.categoryFilterSlider setFrame:newFrame];
            
            self.collectionView.contentInset = newInsets;
            self.collectionView.contentOffset = contentOffset;
        }];

    }
    
    [self.collectionView updatePullToRefreshInsets];

}

- (void)initialFetch
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kNSUserDefaultsHasPickedSchoolKey]) {
        [SVProgressHUD show];
        self.refreshing = YES;
        [[FlyerDB sharedInstance] fetchAllWithCompletionBlock:^{
            [SVProgressHUD dismiss];
            [self.model refreshDatabase];
            self.refreshing = NO;
            NSLog(@"No longer refreshing");
            
            self.filterDictionary = [NSMutableDictionary new];
            for (CD_V2_Category *category in [[FlyerDB sharedInstance] allCategoriesSortedByName]) {
                [self.filterDictionary setObject:@(YES) forKey:category.name];
            }
//            [self handleFilterButtonTap];
            
            [self.sliderView addSubview:[[CategoryFilterView alloc] initWithFrame:self.sliderView.frame andCategorySelectionBlock:^(UIView *categoryView, NSInteger categoryIndex) {
                if (self.model.expandedSection >= 0 && self.model.filterString && ![self.model.filterString isEqualToString:((PvmntCategorySliderLabel *)categoryView).text]) {
                    [self toggleDescriptionCellViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.model.expandedSection]];
                }
                [self.model filterWithCategoryName:((PvmntCategorySliderLabel *)categoryView).text];
                [self.collectionView setContentOffset:CGPointZero animated:YES];
                
            }]];
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)removeSectionsInIndexSet:(NSIndexSet *)sectionsToRemove addSectionsIndexSet:(NSIndexSet *)sectionsToAdd
{
        [self.collectionView performBatchUpdates:^{
            [self.collectionView deleteSections:sectionsToRemove];
            [self.collectionView insertSections:sectionsToAdd];
            
            /*
            if (self.model.expandedSection >= 0) {
                [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:self.model.expandedSection]]];
            }
             */
        } completion:^(BOOL finished) {
            if (self.model.expandedSection >= 0) {
                [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:self.model.expandedSection]]];
            }
        }];
}

#pragma mark - UICollectionView Implementation
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.model numberOfItemsInSection:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.model numberOfSections];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:{
            SidewalkFlyerImageHTKCollectionViewCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:SidewalkFlyerImageHTKCollectionViewCellIdentifier forIndexPath:indexPath];
            CD_V2_Flyer *flyerForCell = [self.model flyerAtIndexPath:indexPath];
            [imageCell setupCellWithFlyer:flyerForCell];
            imageCell.layer.zPosition = 0;
//            imageCell.clipsToBounds = YES;
            return imageCell;
        }
        case 1:{
            FeedEventInfoHTKCollectionViewCell *feedCell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedEventInfoHTKCollectionViewCellIdentifier forIndexPath:indexPath];
            CD_V2_Flyer *flyerForCell = [self.model flyerAtIndexPath:indexPath];
            [feedCell setupCellWithFlyer:flyerForCell];
            feedCell.layer.zPosition = -1;
            feedCell.clipsToBounds = YES;
            return feedCell;
        }
        default:
            return nil;
            break;
    }
    /*
    if (indexPath.row == 0) {
        SidewalkFlyerImageHTKCollectionViewCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:SidewalkFlyerImageHTKCollectionViewCellIdentifier forIndexPath:indexPath];
        CD_V2_Flyer *flyerForCell = [self.model flyerAtIndexPath:indexPath];
        [imageCell setupCellWithImage:flyerForCell.image];
        return imageCell;
        
    } elseif (indexPath.row ) {
        SidewalkTitleHTKCollectionViewCell *titleCell = [collectionView dequeueReusableCellWithReuseIdentifier:SidewalkTitleHTKCollectionViewCellIdentifier forIndexPath:indexPath];
        CD_V2_Flyer *flyerForCell = [self.model flyerAtIndexPath:indexPath];
        [titleCell setupCellWithFlyer:flyerForCell];
        
        return titleCell;
    }
     */
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        CD_V2_Flyer *flyerForCell = [self.model flyerAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        return [SidewalkFlyerImageHTKCollectionViewCell sizeForCellWithImage:flyerForCell.image];
        
    } else {
        /*
        CGSize defaultSize = DEFAULT_SIDEWALK_FLYER_TITLE_CELL_SIZE;
        CD_V2_Flyer *flyerForCell = [self.model flyerAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        return [SidewalkTitleHTKCollectionViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
            [((SidewalkTitleHTKCollectionViewCell *)cellToSetup) setupCellWithFlyer:flyerForCell];
            return cellToSetup;
        }];
         */
        
        CGSize defaultSize = DEFAULT_FEED_EVENT_INFO_CELL_SIZE;
        CD_V2_Flyer *flyerForCell = [self.model flyerAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        return [FeedEventInfoHTKCollectionViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
            [((FeedEventInfoHTKCollectionViewCell *)cellToSetup) setupCellWithFlyer:flyerForCell];
            return cellToSetup;
        }];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if ([self.collectionView.collectionViewLayout isMemberOfClass:[SidewalkCollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *newLayout = [[UICollectionViewFlowLayout alloc] init];
        newLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView.pagingEnabled = YES;
        
        TLTransitionLayout *layout = (TLTransitionLayout *)[collectionView transitionToCollectionViewLayout:newLayout duration:0.3 easing:QuarticEaseInOut completion:nil];
        CGPoint toOffset = [collectionView toContentOffsetForLayout:layout indexPaths:@[indexPath] placement:TLTransitionLayoutIndexPathPlacementTop];
        layout.toContentOffset = toOffset;
    } else {
        SidewalkCollectionViewFlowLayout *newLayout = [[SidewalkCollectionViewFlowLayout alloc] init];
        newLayout.sectionInset = UIEdgeInsetsZero;
        self.collectionView.pagingEnabled = NO;

        TLTransitionLayout *layout = (TLTransitionLayout *)[collectionView transitionToCollectionViewLayout:newLayout duration:0.3 easing:QuarticEaseInOut completion:nil];
        CGPoint toOffset = [collectionView toContentOffsetForLayout:layout indexPaths:@[indexPath] placement:TLTransitionLayoutIndexPathPlacementTop];
        layout.toContentOffset = toOffset;
    }
    */
    [self toggleDescriptionCellViewAtIndexPath:indexPath];
}

- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    return [[TLTransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
}

- (void)toggleDescriptionCellViewAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.model.expandedSection) {
        NSIndexPath *indexPathToRemove = [self.model showDescriptionCellForSection:nil];
        [self.collectionView performBatchUpdates:^{
            [self.collectionView deleteItemsAtIndexPaths:@[indexPathToRemove]];
            [(SidewalkFlyerImageHTKCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]] toggleTitleComponentsHidden];
        } completion:^(BOOL finished) {
        }];
    } else {
        NSIndexPath *descriptionIndexPath = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
        NSIndexPath *indexPathToRemove = [self.model showDescriptionCellForSection:descriptionIndexPath];
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:@[descriptionIndexPath]];
            [(SidewalkFlyerImageHTKCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]] toggleTitleComponentsHidden];
            if (indexPathToRemove) {
                [self.collectionView deleteItemsAtIndexPaths:@[indexPathToRemove]];
                [(SidewalkFlyerImageHTKCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]] toggleTitleComponentsHidden];
            }
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        } completion:^(BOOL finished) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }];
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
    /*
    if (section == 0) {
       return UIEdgeInsetsMake(0, 0, spacing, 0);
    } else return UIEdgeInsetsMake(spacing, 0, 0, 0);
      */
}

#pragma mark - SidewalkModelDelegate Implementation
- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths
{
//    if (!self.refreshing) {
//        [self.collectionView reloadData];
//    }
}

- (void)removeItemsAtIndexPaths:(NSArray *)indexPaths
{
//    [self.collectionView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Flyer Detail Segue"] && [((UINavigationController*)segue.destinationViewController).topViewController isMemberOfClass:[EventInforViewController class]]) {
        EventInforViewController *eventInfoVC = (EventInforViewController *)((UINavigationController*)segue.destinationViewController).topViewController;
        eventInfoVC.flyer = (CD_V2_Flyer *)sender;
    }
}
@end

