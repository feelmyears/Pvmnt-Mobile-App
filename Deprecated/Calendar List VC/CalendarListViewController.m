//
//  CalendarListViewController.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/1/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "CalendarListViewController.h"
#import "CalendarListCollectionCell.h"
#import "FlyerDetailCollectionViewController.h"
#import "CD_V2_Flyer.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "EventInforViewController.h"
#import "DIDatepicker.h"
#import "NSDate+Utilities.h"
#import "Calendar List Header.h"
#import "CSStickyHeaderFlowLayout.h"
#import "FlyerDB.h"
#import <FXBlurView/FXBlurView.h>
#import "DateFlowLayout.h"

@interface CalendarListViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet FXBlurView *blurView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) NSMutableArray *flyerArray;
@property (weak, nonatomic) IBOutlet DIDatepicker *datePicker;
@property (strong, nonatomic) NSMutableArray *dateArray;
@property (strong, nonatomic) FlyerDB *model;
@property (nonatomic) BOOL updateDatePickerDate;
@property (nonatomic) BOOL scrollDatePicker;

@end

//CGFloat const CALENDAR_COLLECTION_VIEW_PADDING = 8.f;
//CGFloat const CALENDAR_COLLECTION_VIEW_TOP_INSET = 0.f;
//CGFloat const CALENDAR_COLLECTION_VIEW_BOTTOM_INSET = 10.f;

@implementation CalendarListViewController
@synthesize dateArray = _dateArray;
- (FlyerDB *)model
{
    if (!_model) {
        _model = [FlyerDB sharedInstance];
    }
    return _model;
}

- (NSMutableArray *)dateArray
{
    if (!_dateArray) {
        _dateArray = [[NSMutableArray alloc] init];
    }
    return _dateArray;
}

- (void)setDateArray:(NSMutableArray *)dateArray
{
    _dateArray = dateArray;
    if (dateArray.count) {
        NSDate *firstDate = [dateArray firstObject];
        NSDate *lastDate = [dateArray lastObject];
        NSMutableArray *fullDateArray = [[NSMutableArray alloc] initWithObjects:firstDate, nil];
        while (![[fullDateArray lastObject] isEqualToDate:lastDate]) {
            NSDate *nextDate = [(NSDate *)[fullDateArray lastObject] dateByAddingDays:1];
            [fullDateArray addObject:nextDate];
        }
        
        [self.datePicker setDates:fullDateArray];
        [self.datePicker selectDateAtIndex:0];
    }
   
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        [_layout setMinimumInteritemSpacing:20];
        [_layout setMinimumLineSpacing:20];
//        [_layout setSectionInset:UIEdgeInsetsMake(self.scrollView.frame.size.height, 0, 0, 0)];
        [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    }
    return _layout;
}

- (NSMutableArray *)flyerArray
{
    if (!_flyerArray) {
        //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageDownloaded == YES"];
        //        NSLog(@"Number of elements: %u", [CD_V2_Flyer MR_countOfEntities]);
        //        _flyerArray = [[CD_V2_Flyer MR_findAllSortedBy:@"event_date" ascending:NO withPredicate:predicate] mutableCopy];
        _flyerArray = [[self.model allFlyersSortedByDateAndTime] mutableCopy];
    }
    return _flyerArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleModelUpdated) name:@"Model Updated" object:nil];
//    [self.datePicker fillCurrentYear];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CalendarListCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"Calendar List Cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"Calendar List Header" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header Cell"];
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    [self.collectionView addGestureRecognizer:self.scrollView.panGestureRecognizer];
    self.collectionView.panGestureRecognizer.enabled = NO;
    [self.collectionView setContentInset:UIEdgeInsetsMake(self.datePicker.frame.size.height, 0, 0, 0)];
    self.scrollView.delegate = self;
//    [self.collectionView setCollectionViewLayout:self.layout];
    [self.collectionView setCollectionViewLayout:[[DateFlowLayout alloc] init]];
    
    self.scrollView.hidden = YES;
    self.scrollView.pagingEnabled = YES;
    [self.datePicker addTarget:self action:@selector(handleNewSelectedDate) forControlEvents:UIControlEventValueChanged];
    [self.datePicker setSelectedDateBottomLineColor:[UIColor clearColor]];
    self.dateArray = [[self.model flyerDates] mutableCopy];
//    [self.datePicker insertSubview:self.blurView atIndex:0];
    self.blurView.blurEnabled = YES;
    self.blurView.blurRadius = 1;
    self.blurView.tintColor = [UIColor blackColor];
    
//    [self.model flyerDates];
//    [self.datePicker fillCurrentYear];
//    [self.datePicker selectDateAtIndex:0];
    // Do any additional setup after loading the view.
}


- (void)handleModelUpdated
{
    [self.collectionView reloadData];
}

- (void)handleNewSelectedDate
{
    NSDate *newSelectedDate = self.datePicker.selectedDate;
    if (newSelectedDate) {
        self.updateDatePickerDate = NO;
        NSInteger indexOfNewSelectedDate = [[self.model flyerDates] indexOfObject:newSelectedDate];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexOfNewSelectedDate] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
//        [self scrollToTopOfSection:indexOfNewSelectedDate animated:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
//    _flyerArray = [[CD_V2_Flyer MR_findByAttribute:@"image.imageDownloaded" withValue:@(YES) andOrderBy:@"event_date" ascending:NO] mutableCopy];
//    self.dateArray = [[self.model flyerDates] mutableCopy];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView Implementation
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.model flyersAtDate:[[self.model flyerDates] objectAtIndex:section]] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.model flyerDates] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Calendar List Cell";
    CalendarListCollectionCell *calendarListCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
//    v1_Flyer *flyerForCell = [[[FlyerDB sharedInstance] sortedFlyers] objectAtIndex:indexPath.row];
    CD_V2_Flyer *flyerForCell = [[self.model flyersAtDate:[[self.model flyerDates] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    calendarListCell.flyerForCell = flyerForCell;
    
    return calendarListCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        static NSString *cellIdentifier = @"Header Cell";
        Calendar_List_Header *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        NSDate *dateForSection = [[self.model flyerDates] objectAtIndex:indexPath.section];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"eeee"];
        header.headerLabel.text = [[dateFormatter stringFromDate:dateForSection] lowercaseString];
        return header;
    } else {
        return nil;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat contentWidth = self.view.frame.size.width;
    return CGSizeMake(contentWidth - 40, 60);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat contentWidth = self.view.frame.size.width;
//    return CGSizeMake(contentWidth, 20);
    return CGSizeMake(10, 40);
//    return CGSizeMake(0,0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CD_V2_Flyer *chosenFlyer = self.flyerArray[indexPath.row];
    [self performSegueWithIdentifier:@"Flyer Detail Segue" sender:chosenFlyer];
       
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.x = contentOffset.x - _collectionView.contentInset.left;
        _collectionView.contentOffset = contentOffset;
    }
    
    if (!self.updateDatePickerDate) {
        self.updateDatePickerDate = scrollView.tracking;
    }
    
    if (self.updateDatePickerDate) {
        NSIndexPath *indexPathForFirstCell = [[[self.collectionView indexPathsForVisibleItems] sortedArrayUsingSelector:@selector(compare:)] firstObject];
        NSDate *dateForTopVisibleSection = [[self.model flyerDates] objectAtIndex:indexPathForFirstCell.section];
        if (![self.datePicker.selectedDate isEqualToDate:dateForTopVisibleSection]) {
            [self.datePicker selectDate:dateForTopVisibleSection];
        }
    }
}



- (CGRect)frameForHeaderForSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frameForFirstCell = attributes.frame;
    CGFloat headerHeight = [self collectionView:_collectionView layout:_layout referenceSizeForHeaderInSection:section].height;
    return CGRectOffset(frameForFirstCell, 0, -headerHeight);
}

- (void)scrollToTopOfSection:(NSInteger)section animated:(BOOL)animated {
    CGRect headerRect = [self frameForHeaderForSection:section];
    CGPoint topOfHeader = CGPointMake(0, headerRect.origin.y - _collectionView.contentInset.top);
    [_collectionView setContentOffset:topOfHeader animated:animated];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Flyer Detail Segue"] && [segue.destinationViewController isMemberOfClass:[FlyerDetailCollectionViewController class]]) {
        FlyerDetailCollectionViewController *detailVC = (FlyerDetailCollectionViewController *)segue.destinationViewController;
        detailVC.flyer = (v1_Flyer *)sender;
    } else if ([segue.identifier isEqualToString:@"Flyer Detail Segue"] && [segue.destinationViewController isMemberOfClass:[EventInforViewController class]]) {
        EventInforViewController *eventInfoVC = (EventInforViewController *)segue.destinationViewController;
        eventInfoVC.flyer = (CD_V2_Flyer *)sender;
        
    }
}


@end
