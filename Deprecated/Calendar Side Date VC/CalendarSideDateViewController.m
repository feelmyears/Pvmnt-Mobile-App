//
//  CalendarSideDateViewController.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/23/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "CalendarSideDateViewController.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "CSStickyHeaderFlowLayout.h"
#import "CalendarSideDateCell.h"
#import "CalendarListCollectionCell.h"
#import "FlyerDB.h"
#import "CD_V2_Flyer.h"
#import "NSDate+Utilities.h"
#import "EventInforViewController.h"
#import "CalendarSideDateActionCell.h"
#import "CalendarSideDateFlyerHTKCollectionViewCell.h"
#import "CalendarSideDateModel.h"
#import "CalendarSideDateDateHTKCollectionViewCell.h"

static CGFloat VERTICAL_PADDING = 10.f;
static NSString *CalendarSideDateFlyerHTKCollectionViewCellIndentifier = @"CalendarSideDateFlyerHTKCollectionViewCellIndentifier";
static NSString *CalendarSideDateDateHTKCollectionViewCellIdentifier = @"CalendarSideDateDateHTKCollectionViewCellIdentifier";
static BOOL useAutoLayoutCell = NO;

@interface CalendarSideDateViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *sideDateCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *cellCollectionView;
@property (strong, nonatomic) CalendarSideDateModel *model;
@property (weak, nonatomic) IBOutlet CalendarSideDateActionCell *bottomActionCell;
@property (strong, nonatomic) NSMutableDictionary *cellHeightDict;
@end

@implementation CalendarSideDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.cellCollectionView registerNib:[UINib nibWithNibName:@"CalendarListCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"Calendar List Cell"];
    [self.sideDateCollectionView registerNib:[UINib nibWithNibName:@"CalendarSideDateCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Side Date Cell"];
    [self.cellCollectionView registerClass:[CalendarSideDateFlyerHTKCollectionViewCell class] forCellWithReuseIdentifier:CalendarSideDateFlyerHTKCollectionViewCellIndentifier];
    
    [self.sideDateCollectionView registerClass:[CalendarSideDateDateHTKCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CalendarSideDateDateHTKCollectionViewCellIdentifier];
    
    self.sideDateCollectionView.dataSource = self;
    self.sideDateCollectionView.delegate = self;
    self.sideDateCollectionView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10.f;
//    flowLayout.sectionInset = UIEdgesMake(0, 0, 10, 0);
    flowLayout.estimatedItemSize = CGSizeMake(self.cellCollectionView.frame.size.width, DEFAULT_FLYER_CELL_SIZE.height);
    [self.cellCollectionView setCollectionViewLayout:flowLayout];
    
    self.cellCollectionView.dataSource = self;
    self.cellCollectionView.delegate = self;
    self.cellCollectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    self.model = [[CalendarSideDateModel alloc] init];
    self.model.delegate = self;
    
    self.cellHeightDict = [[NSMutableDictionary alloc] init];
//    [self addActionCell];
}

- (void)addActionCell {
    CGSize sizeForCell = [CalendarSideDateActionCell sizeForActionCellView];
    CGRect rectForCell = CGRectMake(self.view.frame.size.width/2.0, self.view.frame.size.height - 20 - sizeForCell.height, sizeForCell.width, sizeForCell.height);
    CalendarSideDateActionCell *actionCell = [[CalendarSideDateActionCell alloc] initWithFrame:rectForCell];
    [self.view insertSubview:actionCell aboveSubview:self.cellCollectionView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:view aboveSubview:self.cellCollectionView];
    [self.view bringSubviewToFront:view];
    
    
//    
//    NSDictionary *viewDict = NSDictionaryOfVariableBindings(actionCell);
//    NSDictionary *metricDict = @{@"cellWidth" : [NSNumber numberWithFloat:sizeForCell.width],
//                                 @"cellHeight" : [NSNumber numberWithFloat:sizeForCell.height],
//                                 @"bottomSpace" : @20};
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[actionCell(cellWidth)]" options:0 metrics:metricDict views:viewDict]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[actionCell(cellHeight)]-bottomSpace-|" options:0 metrics:metricDict views:viewDict]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionCell attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return 0;
    if (collectionView == _cellCollectionView) {
        return [self.model numberOfItemsInSection:section];
    } else if (collectionView == _sideDateCollectionView) {
        return 1;
    } else return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.model numberOfSections];
//    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _cellCollectionView) {
//        static NSString *cellIdentifier = @"Calendar List Cell";
//        CalendarListCollectionCell *calendarListCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        CalendarSideDateFlyerHTKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CalendarSideDateFlyerHTKCollectionViewCellIndentifier forIndexPath:indexPath];
        
        CD_V2_Flyer *flyerForCell = [self.model flyerAtIndexPath:indexPath];
        //        calendarListCell.flyerForCell = flyerForCell;
        [cell setupWithFlyer:flyerForCell];
//        NSLog(@"%@ - %@", flyerForCell.title, flyerForCell.event_time.shortDateString);
        
        return cell;
    } else if (collectionView == _sideDateCollectionView) {
        static NSString *cellIdentifier = @"Blank Side Cell";
        UICollectionViewCell *blankSideCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        return blankSideCell;
    } else return nil;

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _sideDateCollectionView && kind == UICollectionElementKindSectionHeader) {
        if (useAutoLayoutCell) {
            CalendarSideDateDateHTKCollectionViewCell *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CalendarSideDateDateHTKCollectionViewCellIdentifier forIndexPath:indexPath];
            NSDate *dateForSection = [self.model dateForSection:indexPath.section];
            [header setupCellWithDate:dateForSection];
            return header;
        } else {
            static NSString *cellIdentifier = @"Side Date Cell";
            CalendarSideDateCell *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            
            NSDate *dateForSection = [self.model dateForSection:indexPath.section];
            header.dateForHeader = dateForSection;
            return header;
        }
    } else return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (collectionView == _sideDateCollectionView) {
        if (useAutoLayoutCell) {
            CGSize defaultSize = DEFAULT_CALENDAR_SIDE_DATE_CELL_SIZE;
            NSDate *dateForSection = [self.model dateForSection:section];
            return [CalendarSideDateDateHTKCollectionViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
                [((CalendarSideDateDateHTKCollectionViewCell *)cellToSetup) setupCellWithDate:dateForSection];
                return cellToSetup;
            }];
        } else {
            return CGSizeMake(collectionView.frame.size.width, 60);
        }
    } else {
        return CGSizeMake(0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _sideDateCollectionView) {
    
        NSArray *flyersInSection = [self.model flyersForSection:indexPath.section];
        CGFloat heightForCell = 0;
        
        CGSize defaultSize = DEFAULT_FLYER_CELL_SIZE;
        for (CD_V2_Flyer *flyer in flyersInSection) {
//            heightForCell += [CalendarSideDateFlyerHTKCollectionViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
//                [((CalendarSideDateFlyerHTKCollectionViewCell *)cellToSetup) setupWithFlyer:flyer];
//                return cellToSetup;
//            }].height;
            heightForCell += [self heightForFlyerCellWithFlyer:flyer];
        }
        
//        NSUInteger numEventsInSection = [self.cellCollectionView numberOfItemsInSection:indexPath.section];
        NSUInteger numEventsInSection = flyersInSection.count;
        heightForCell += 10 * (numEventsInSection) - [self collectionView:self.sideDateCollectionView layout:self.sideDateCollectionView.collectionViewLayout referenceSizeForHeaderInSection:indexPath.section].height;
        
        return CGSizeMake(collectionView.frame.size.width, heightForCell);
    } else if (collectionView == _cellCollectionView) {
        CGSize defaultSize = DEFAULT_FLYER_CELL_SIZE;
        CD_V2_Flyer *flyerForCell = [self.model flyerAtIndexPath:indexPath];
        return [CalendarSideDateFlyerHTKCollectionViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
            [((CalendarSideDateFlyerHTKCollectionViewCell *)cellToSetup) setupWithFlyer:flyerForCell];
            return cellToSetup;
        }];

    } else return CGSizeMake(0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _cellCollectionView) {
        CD_V2_Flyer *chosenFlyer = [self.model flyerAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"Flyer Detail Segue" sender:chosenFlyer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _sideDateCollectionView) {
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.x = contentOffset.x - _cellCollectionView.contentInset.left;
        _cellCollectionView.contentOffset = contentOffset;
    } else if (scrollView == _cellCollectionView) {
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.x = contentOffset.x - _sideDateCollectionView.contentInset.left;
        _sideDateCollectionView.contentOffset = contentOffset;
    }
}

- (CGFloat)heightForFlyerCellWithFlyer:(CD_V2_Flyer *)flyer
{
    NSNumber *dictKey = flyer.flyerId;
    if ([self.cellHeightDict objectForKey:dictKey]) {
        return [(NSNumber *)[self.cellHeightDict objectForKey:dictKey] floatValue];
    } else {
        CGSize defaultSize = DEFAULT_FLYER_CELL_SIZE;
        CGFloat heightForCellWithFlyer = [CalendarSideDateFlyerHTKCollectionViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
            [((CalendarSideDateFlyerHTKCollectionViewCell *)cellToSetup) setupWithFlyer:flyer];
            return cellToSetup;
        }].height;
        [self.cellHeightDict setObject:[NSNumber numberWithFloat:heightForCellWithFlyer] forKey:dictKey];
        return heightForCellWithFlyer;
    }
}


#pragma mark - CalendarSideDateModelDelegate Implementation
- (void)insertItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.sideDateCollectionView reloadData];
    [self.cellCollectionView reloadData];
    
}

- (void)removeItemsAtIndexPath:(NSArray *)indexPaths
{
    [self.sideDateCollectionView reloadData];
    [self.cellCollectionView reloadData];
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Flyer Detail Segue"] && [segue.destinationViewController isMemberOfClass:[EventInforViewController class]]) {
        EventInforViewController *eventInfoVC = (EventInforViewController *)segue.destinationViewController;
        eventInfoVC.flyer = (CD_V2_Flyer *)sender;
        
    }
}

@end
