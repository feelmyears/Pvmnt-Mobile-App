//
//  FlyerCloseLookViewController.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/10/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import "FlyerCloseLookViewController.h"
#import "FeedEventInfoHTKCollectionViewCell.h"
#import "EventInfoFlyerImageHTKCollectionViewCell.h"
#import "PvmntStyleKit.h"

static NSString *EventInfoFlyerImageHTKCollectionViewCellIdentifier = @"EventInfoFlyerImageHTKCollectionViewCellIdentifier";
static NSString *FeedEventInfoHTKCollectionViewCellIdentifier       = @"FeedEventInfoHTKCollectionViewCellIdentifier";

@interface FlyerCloseLookViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FlyerCloseLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [PvmntStyleKit calendarSidebar];
    
    [self.collectionView registerClass:[EventInfoFlyerImageHTKCollectionViewCell class] forCellWithReuseIdentifier:EventInfoFlyerImageHTKCollectionViewCellIdentifier];
    [self.collectionView registerClass:[FeedEventInfoHTKCollectionViewCell class] forCellWithReuseIdentifier:FeedEventInfoHTKCollectionViewCellIdentifier];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem.backBarButtonItem setTitle:@" "];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if (indexPath.row == 0) {
        EventInfoFlyerImageHTKCollectionViewCell *imageCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:EventInfoFlyerImageHTKCollectionViewCellIdentifier forIndexPath:indexPath];
        [imageCell setupCellWithImage:self.flyer.image];
        cell = imageCell;
    } else if (indexPath.row == 1) {
        FeedEventInfoHTKCollectionViewCell *feedCell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedEventInfoHTKCollectionViewCellIdentifier forIndexPath:indexPath];
        CD_V2_Flyer *flyerForCell = self.flyer;
        [feedCell setupCellWithFlyer:flyerForCell];
        cell = feedCell;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [EventInfoFlyerImageHTKCollectionViewCell sizeForCellWithImage:self.flyer.image];
    } else if (indexPath.row == 1) {
        CGSize defaultSize = DEFAULT_FEED_EVENT_INFO_CELL_SIZE;
        CD_V2_Flyer *flyerForCell = self.flyer;
        return [FeedEventInfoHTKCollectionViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
            [((FeedEventInfoHTKCollectionViewCell *)cellToSetup) setupCellWithFlyer:flyerForCell];
            return cellToSetup;
        }];
    } else return CGSizeZero;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
