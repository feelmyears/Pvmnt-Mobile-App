//
//  CalendarFeedViewController.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/21/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "CalendarFeedViewController.h"
#import "CSStickyHeaderFlowLayout.h"
#import "CalendarSideDateFlyerHTKCollectionViewCell.h"
#import "EventInforViewController.h"
#import "CalendarFeedHeaderCollectionReusableView.h"
#import "CalendarFeedFlyerHTKCollectionViewCell.h"
#import "SWRevealViewController.h"
#import "SVPullToRefresh.h"
#import "FlyerDB.h"


#import <TLYShyNavBar/TLYShyNavBarManager.h>
#import <FNShyTabBar/FNShyTabBar.h>
#import <AMScrollingNavbar/UIViewController+ScrollingNavbar.h>

static NSString *CalendarFeedFlyerHTKCollectionViewCellIdentifier  = @"CalendarFeedFlyerHTKCollectionViewCellIdentifier";
static NSString *CalendarFeedHeaderCollectionResuableViewIdentifier     = @"CalendarFeedHeaderCollectionResuableViewIdentifier";

@interface CalendarFeedViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) CalendarSideDateModel *model;
@property (nonatomic) BOOL refreshing;

@end

@implementation CalendarFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *pvmntLogo = [UIButton new];
    [pvmntLogo setTitle:@"pvmnt" forState:UIControlStateNormal];
    pvmntLogo.titleLabel.font = [UIFont fontWithName:@"Lobster" size:30.];
    [pvmntLogo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.titleView = pvmntLogo;
    
    self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.tintColor = [UIColor blackColor];
    self.tabBarController.tabBar.translucent = NO;
    self.title = @"Calendar";
    
    [self.collectionView registerClass:[CalendarFeedFlyerHTKCollectionViewCell class] forCellWithReuseIdentifier:CalendarFeedFlyerHTKCollectionViewCellIdentifier];
    [self.collectionView registerClass:[CalendarFeedHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CalendarFeedHeaderCollectionResuableViewIdentifier];
    
    if ([self.collectionView.collectionViewLayout isMemberOfClass:[CSStickyHeaderFlowLayout class]]) {
        CSStickyHeaderFlowLayout *flowLayout = (CSStickyHeaderFlowLayout *)self.collectionView.collectionViewLayout;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //    flowLayout.estimatedItemSize = DEFAULT_CALENDAR_FEED_FLYER_CELL_SIZE;
        flowLayout.sectionInset = UIEdgeInsetsMake(10., 0, 10, 0);
    }
    
    
    self.collectionView.bounces = YES;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.model = [[CalendarSideDateModel alloc] init];
    self.model.delegate = self;
    
    
//    self.shyNavBarManager.scrollView = self.collectionView;
//    [self.tabBarController.shyTabBar setTrackingView:self.collectionView];
    
    [self.collectionView addPullToRefreshWithActionHandler:^{
        self.refreshing = YES;
        [[FlyerDB sharedInstance] fetchAllWithCompletionBlock:^{
            [self.collectionView.pullToRefreshView stopAnimating];
            [self.collectionView reloadData];
            self.refreshing = NO;
        }];
    } position:SVPullToRefreshPositionTop];
    
}
/*
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self followScrollView:self.collectionView usingTopConstraint:self.topLayoutConstraint];
    [self.tabBarController.shyTabBar setTrackingView:self.collectionView];
}
*/
- (void)handleMenuButtonTapped
{
    [self.revealViewController revealToggleAnimated:YES];
    if (self.revealViewController.frontViewPosition == FrontViewPositionLeft) {
        for (UIView *view in self.view.subviews) {
            if ([view isMemberOfClass:[UIButton class]]) {
                [view removeFromSuperview];
                break;
            }
        }
    } else {
        UIButton *button = [[UIButton alloc] initWithFrame:self.collectionView.frame];
        button.backgroundColor = [UIColor clearColor];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(handleMenuButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
}

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
    CalendarFeedFlyerHTKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CalendarFeedFlyerHTKCollectionViewCellIdentifier forIndexPath:indexPath];
    
    CD_V2_Flyer *flyerForCell = [self.model flyerAtIndexPath:indexPath];
    [cell setupWithFlyer:flyerForCell];
    
    return cell;

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        CalendarFeedHeaderCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CalendarFeedHeaderCollectionResuableViewIdentifier forIndexPath:indexPath];
        NSDate *dateForSection = [self.model dateForSection:indexPath.section];
        [reusableView setupCellWithDate:dateForSection];
        return reusableView;
    } else return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize defaultSize = DEFAULT_CALENDAR_FEED_FLYER_CELL_SIZE;
    CD_V2_Flyer *flyerForCell = [self.model flyerAtIndexPath:indexPath];
    CGSize itemSize = [CalendarFeedFlyerHTKCollectionViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
        [((CalendarFeedFlyerHTKCollectionViewCell *)cellToSetup) setupWithFlyer:flyerForCell];
        return cellToSetup;
    }];
    
    return itemSize;

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.collectionView.frame.size.width, 30.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CD_V2_Flyer *chosenFlyer = [self.model flyerAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"Flyer Detail Segue" sender:chosenFlyer];
}

#pragma mark - CalendarSideDateModelDelegate Implementation
- (void)insertItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.refreshing) {
        [self.collectionView reloadData];
    }
}

- (void)removeItemsAtIndexPath:(NSArray *)indexPaths
{
    [self.collectionView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Flyer Detail Segue"] && [((UINavigationController*)segue.destinationViewController).topViewController isMemberOfClass:[EventInforViewController class]]) {
        EventInforViewController *eventInfoVC = (EventInforViewController *)((UINavigationController*)segue.destinationViewController).topViewController;
        eventInfoVC.flyer = (CD_V2_Flyer *)sender;
    }}

@end
