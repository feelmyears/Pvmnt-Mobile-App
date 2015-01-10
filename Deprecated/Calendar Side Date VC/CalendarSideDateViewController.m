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
#import "PvmntStyleKit.h"
#import "CategoryFilterView.h"
#import "PvmntCategorySliderLabel.h"
#import <UINavigationBar+Addition/UINavigationBar+Addition.h>
#import "FlyerCloseLookViewController.h"

static CGFloat VERTICAL_PADDING = 10.f;
static NSString *CalendarSideDateFlyerHTKCollectionViewCellIndentifier = @"CalendarSideDateFlyerHTKCollectionViewCellIndentifier";
static NSString *CalendarSideDateDateHTKCollectionViewCellIdentifier = @"CalendarSideDateDateHTKCollectionViewCellIdentifier";
static BOOL useAutoLayoutCell = NO;

@interface CalendarSideDateViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *sideDateCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *cellCollectionView;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (strong, nonatomic) CalendarSideDateModel *model;
@property (strong, nonatomic) NSMutableDictionary *cellHeightDict;
@property (strong, nonatomic) CategoryFilterView *categoryFilterView;
@end

@implementation CalendarSideDateViewController

- (CategoryFilterView *)categoryFilterView
{
    if (!_categoryFilterView) {
        _categoryFilterView = [[CategoryFilterView alloc] initWithFrame:self.filterView.frame andCategorySelectionBlock:^(UIView *categoryView, NSInteger categoryIndex) {
            [self.model filterWithCategoryName:((PvmntCategorySliderLabel *)categoryView).text];
        }];
        [self.filterView addSubview:_categoryFilterView];
    }
    return _categoryFilterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar hideBottomHairline];
    
//    UIButton *pvmntLogo = [UIButton new];
//    [pvmntLogo setTitle:@"Pvmnt" forState:UIControlStateNormal];
//    pvmntLogo.titleLabel.font = [UIFont fontWithName:@"Lobster" size:30.];
//    [pvmntLogo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.navigationItem.titleView = pvmntLogo;
    
    
    [self.cellCollectionView registerNib:[UINib nibWithNibName:@"CalendarListCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"Calendar List Cell"];
    [self.sideDateCollectionView registerNib:[UINib nibWithNibName:@"CalendarSideDateCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Side Date Cell"];
    [self.cellCollectionView registerClass:[CalendarSideDateFlyerHTKCollectionViewCell class] forCellWithReuseIdentifier:CalendarSideDateFlyerHTKCollectionViewCellIndentifier];
    
    [self.sideDateCollectionView registerClass:[CalendarSideDateDateHTKCollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CalendarSideDateDateHTKCollectionViewCellIdentifier];
    
    self.sideDateCollectionView.dataSource = self;
    self.sideDateCollectionView.delegate = self;
    self.sideDateCollectionView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    self.sideDateCollectionView.backgroundColor = [PvmntStyleKit calendarSidebar];
    
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.minimumLineSpacing = 10.f;
//    flowLayout.minimumInteritemSpacing = 10.f;
//    flowLayout.estimatedItemSize = CGSizeMake(self.cellCollectionView.frame.size.width, DEFAULT_FLYER_CELL_SIZE.height);
//    [self.cellCollectionView setCollectionViewLayout:flowLayout];
    
    self.cellCollectionView.dataSource = self;
    self.cellCollectionView.delegate = self;
    self.cellCollectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.cellCollectionView.backgroundColor = [PvmntStyleKit pureWhite];
    
    self.model = [[CalendarSideDateModel alloc] init];
    self.model.delegate = self;
    
    self.cellHeightDict = [[NSMutableDictionary alloc] init];
    [self.model refreshDatabase];
//    [self addActionCell];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self categoryFilterView];
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
            header.backgroundColor = [PvmntStyleKit calendarSidebar];
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
        NSUInteger section = indexPath.section;
        NSUInteger numItemsInSection = [self.cellCollectionView numberOfItemsInSection:section];
        CGFloat heightForCell = -[self collectionView:self.sideDateCollectionView layout:self.sideDateCollectionView.collectionViewLayout referenceSizeForHeaderInSection:section].height;
        for (NSUInteger row = 0; row < numItemsInSection; row++) {
            CGSize sizeForCellAtIndexPath = [self collectionView:self.cellCollectionView layout:self.cellCollectionView.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            heightForCell += sizeForCellAtIndexPath.height;
        }
        
        NSUInteger numEventsInSection = numItemsInSection;
        heightForCell += 10 * (numEventsInSection);
        
        return CGSizeMake(collectionView.frame.size.width, heightForCell);
    } else if (collectionView == _cellCollectionView) {
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _cellCollectionView) {
        CD_V2_Flyer *chosenFlyer = [self.model flyerAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"Flyer Close Up Segue" sender:chosenFlyer];
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == _cellCollectionView) {
        return UIEdgeInsetsMake(0, 0, 10, 0);
    } else return UIEdgeInsetsZero;
}

#pragma mark - CalendarSideDateModelDelegate Implementation
- (void)insertItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.sideDateCollectionView reloadData];
//    [self.cellCollectionView reloadData];
    
}

- (void)removeItemsAtIndexPath:(NSArray *)indexPaths
{
//    [self.sideDateCollectionView reloadData];
//    [self.cellCollectionView reloadData];
}

- (void)removeItemsAtIndexes:(NSArray *)indexesToRemove addItemsAtIndexes:(NSArray *)indexesToAdd dateSectionsToRemove:(NSIndexSet *)sectionsToRemove dateSectionsToAdd:(NSIndexSet *)sectionsToAdd
{
//    NSLog(@"Calling updating items at indexes");
    @try
    {
//        [self.cellCollectionView performBatchUpdates:^{
//            [self.cellCollectionView deleteItemsAtIndexPaths:indexesToRemove];
//            [self.cellCollectionView deleteSections:sectionsToRemove];
//            [self.cellCollectionView insertSections:sectionsToAdd];
//            [self.cellCollectionView insertItemsAtIndexPaths:indexesToAdd];
//        } completion:^(BOOL finished) {
//            
//        }];
//        
//        [self.sideDateCollectionView reloadData];
        
   
        [self.cellCollectionView reloadData];
        [self.sideDateCollectionView reloadData];
        [self.sideDateCollectionView setContentOffset:CGPointMake(0, -10) animated:YES];
    }
    @catch (NSException *except)
    {
        NSLog(@"DEBUG: failure to batch update.  %@", except.description);
    }
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Flyer Detail Segue"] && [segue.destinationViewController isMemberOfClass:[EventInforViewController class]]) {
        EventInforViewController *eventInfoVC = (EventInforViewController *)segue.destinationViewController;
        eventInfoVC.flyer = (CD_V2_Flyer *)sender;
        
    } else if ([segue.identifier isEqualToString:@"Flyer Close Up Segue"] && [segue.destinationViewController isMemberOfClass:[FlyerCloseLookViewController class]]) {
        FlyerCloseLookViewController *flyerCloseLookVC = segue.destinationViewController;
        flyerCloseLookVC.flyer = sender;
    }
}

@end
