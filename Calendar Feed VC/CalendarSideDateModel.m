//
//  CalendarSideDateModel.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/1/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "CalendarSideDateModel.h"
#import "NSDate+Utilities.h"
#import "FlyerDB.h"

@interface CalendarSideDateModel()
@property (strong, nonatomic) FlyerDB *database;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *rangesForDataSource;
@end

@implementation CalendarSideDateModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.database = [FlyerDB sharedInstance];
        self.dataSource = [NSArray new];
        self.rangesForDataSource = [NSArray new];
        [self setupNotifications];
    }
    return self;
}

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemovedFlyers:) name:kFlyerDBRemovedFlyersNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAddedFlyer:) name:kCD_V2_FlyerImageDownloadedNotification object:nil];
}

- (void)refreshDatabase
{
    [self filterWithCategoryName:@"all"];
}

- (void)handleRemovedFlyers:(NSNotification *)notification
{
    NSArray *flyerIdsToRemove = [notification.userInfo allKeys];
    NSMutableArray *indexPathsToRemove = [[NSMutableArray alloc] initWithCapacity:flyerIdsToRemove.count];
    
    for (int section = 0; section < [self numberOfSections]; section ++) {
        for (int row = 0; row < [self numberOfItemsInSection:section]; row ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            CD_V2_Flyer *flyer = [self flyerAtIndexPath:indexPath];
            if ([flyerIdsToRemove containsObject:flyer.flyerId]) {
                [indexPathsToRemove addObject:indexPath];
            }
            if (indexPathsToRemove.count == flyerIdsToRemove.count) {
                break;
            }
        }
    }
    
    [self.delegate removeItemsAtIndexPaths:indexPathsToRemove];
}

- (void)handleAddedFlyer:(NSNotification *)notification
{
    [self.delegate insertItemsAtIndexPaths:nil];
}


- (NSUInteger)numberOfItemsInSection:(NSUInteger)section
{
    return [(NSValue *)self.rangesForDataSource[section] rangeValue].length;
}

- (NSUInteger)numberOfSections
{
    return self.rangesForDataSource.count;
}

- (CD_V2_Flyer *)flyerAtIndexPath:(NSIndexPath *)indexPath
{
    NSRange rangeForIndex = [(NSValue *)self.rangesForDataSource[indexPath.section] rangeValue];
    NSUInteger indexForFlyer = rangeForIndex.location + indexPath.row;
    return self.dataSource[indexForFlyer];
}

- (NSArray *)flyersInSection:(NSUInteger)section
{
    NSRange rangeForIndex = [(NSValue *)self.rangesForDataSource[section] rangeValue];
    return [self.dataSource subarrayWithRange:rangeForIndex];
}

- (NSDate *)dateForSection:(NSUInteger)section;
{
    return [(CD_V2_Flyer *)[self flyerAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]] event_date];
}

- (void)filterWithCategoryName:(NSString *)categoryName
{
    self.filterString = categoryName;
    if (!categoryName || [categoryName isEqualToString:@"all"]) {
        [self transitionToNextDataSource:[[self.database allFlyersSortedByDateAndTime] mutableCopy]];
    } else {
        
        [self transitionToNextDataSource:[[self.database flyersInCategoryName:categoryName sortedByProperty:@"event_time"] mutableCopy]];
    }
    
}

- (void)transitionToNextDataSource:(NSMutableArray *)nextDataSource
{
    
    NSArray *oldDataSource = self.dataSource;
    NSArray *oldRangesForDataSource = self.rangesForDataSource;
    
    //Items in intersection set are the ones that persist
    NSMutableSet *intersection = [NSMutableSet setWithArray:oldDataSource];
    [intersection intersectSet:[NSSet setWithArray:nextDataSource]];
    
    
    //Items in difference set are thes ones that must be added
    NSMutableSet *difference = [NSMutableSet setWithArray:nextDataSource];
    [difference minusSet:intersection];
    
    NSMutableArray *indexPathsToRemove = [[NSMutableArray alloc] init];
    NSMutableIndexSet *sectionsToRemove = [NSMutableIndexSet new];
    NSMutableIndexSet *indexesToRemove = [NSMutableIndexSet new];
    for (NSUInteger section = 0; section < oldRangesForDataSource.count; section++) {
        NSRange range = [oldRangesForDataSource[section] rangeValue];
        NSUInteger removeCount = 0;
        for (NSUInteger row = 0; row < range.length; row++) {
            CD_V2_Flyer *flyer = self.dataSource[row + range.location];
            if (![intersection containsObject:flyer]) {
                [indexPathsToRemove addObject:[NSIndexPath indexPathForRow:row inSection:section]];
                [indexesToRemove addIndex:(row + range.location)];
                removeCount++;
            }
        }
        if (removeCount == range.length) {
            [sectionsToRemove addIndex:section];
        }
    }
    
   
    NSMutableArray *persistingDataSource = [oldDataSource mutableCopy];
    [persistingDataSource removeObjectsAtIndexes:indexesToRemove];
    [persistingDataSource addObjectsFromArray:[difference allObjects]];
    [persistingDataSource sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CD_V2_Flyer *lhs = obj1;
        CD_V2_Flyer *rhs = obj2;
        return [lhs.event_time compare:rhs.event_time];
    }];
    
    NSMutableIndexSet *previousSections = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.rangesForDataSource.count)];
    for (NSUInteger index = [sectionsToRemove firstIndex]; index != NSNotFound; index = [sectionsToRemove indexGreaterThanIndex:index]) {
        if ([previousSections containsIndex:index]) {
            [previousSections removeIndex:index];
        }
    }
    
    self.rangesForDataSource = [self dateRangesForSortedFlyerArray:persistingDataSource];
    NSMutableArray *indexPathsToAdd = [[NSMutableArray alloc] init];
    NSMutableIndexSet *sectionsToAdd = [NSMutableIndexSet new];
    for (NSUInteger section = 0; section < self.rangesForDataSource.count; section++) {
        NSRange range = [self.rangesForDataSource[section] rangeValue];
        for (NSUInteger row = 0; row < range.length && row + range.location < self.dataSource.count; row++) {
            CD_V2_Flyer *flyer = self.dataSource[row + range.location];
            if ([difference containsObject:flyer]) {
                [indexPathsToAdd addObject:[NSIndexPath indexPathForRow:row inSection:section]];
                if (![previousSections containsIndex:section]) {
                    [sectionsToAdd addIndex:section];
                }
            }
        }
    }

    self.dataSource = persistingDataSource;
    [self.delegate removeItemsAtIndexes:indexPathsToRemove addItemsAtIndexes:indexPathsToAdd dateSectionsToRemove:sectionsToRemove dateSectionsToAdd:sectionsToAdd];

}

- (NSArray *)dateRangesForSortedFlyerArray:(NSArray *)flyerArray
{
    NSMutableArray *dateRanges = [NSMutableArray new];
    
    NSUInteger index = 0;
    while (index < flyerArray.count) {
        CD_V2_Flyer *flyerAtIndex = flyerArray[index];
        NSDate *dateForFlyer = flyerAtIndex.event_date;
        NSUInteger sectionLocation = index;
        NSUInteger sectionLength = 1;
        while (index + 1 < flyerArray.count && [[(CD_V2_Flyer *)flyerArray[index + 1] event_date] isEqualToDate:dateForFlyer]) {
            index++;
            sectionLength++;
        }
        NSRange sectionRange = NSMakeRange(sectionLocation, sectionLength);
        [dateRanges addObject:[NSValue valueWithRange:sectionRange]];
        index++;
    }
    
    return dateRanges;
}
@end
