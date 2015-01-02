//
//  SidewalkModel.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/1/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "SidewalkModel.h"
#import "FlyerDB.h"

@interface SidewalkModel()
@property (strong, nonatomic) FlyerDB *database;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *nextDataSource;
@property (nonatomic) NSInteger expandedSection;
@end


@implementation SidewalkModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.database = [FlyerDB sharedInstance];
        self.dataSource = [[NSMutableArray alloc] init];
        self.expandedSection = -1;
        [self setupNotifications];
    }
    return self;
}

- (void)refreshDatabase
{
//    self.dataSource = [[self.database allFlyersSortedByUploadDate] mutableCopy];
//    [self transitionToNextDataSource:[[self.database allFlyersSortedByUploadDate] mutableCopy]];
    [self filterWithCategoryName:@"all"];
}

- (void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemovedFlyers:) name:kFlyerDBRemovedFlyersNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAddedFlyer:) name:kFlyerDBAddedFlyerNotification object:nil];
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
    CD_V2_Flyer *flyerToAdd = notification.object;
    NSUInteger section = [[self.database allFlyersSortedByUploadDate] indexOfObject:flyerToAdd inSortedRange:NSMakeRange(0, [self.database allFlyersSortedByUploadDate].count) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [((CD_V2_Flyer*)obj1).updated_at compare:((CD_V2_Flyer *)obj2).updated_at];
    }];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:1 inSection:section];
    
    [self.delegate insertItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, indexPath2, nil]];
//    [self.delegate insertItemAtIndexPath:nil];
}


- (NSUInteger)numberOfItemsInSection:(NSUInteger)section
{
    return (section == self.expandedSection) ? 2 : 1;
}

- (NSUInteger)numberOfSections
{
    return self.dataSource.count;
}

- (CD_V2_Flyer *)flyerAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataSource[indexPath.section];
}

- (void)filterWithCategoryName:(NSString *)categoryName
{
    self.filterString = categoryName;
    if (!categoryName || [categoryName isEqualToString:@"all"]) {
        [self transitionToNextDataSource:[[self.database allFlyersSortedByUploadDate] mutableCopy]];
    } else {
        
        [self transitionToNextDataSource:[[self.database flyersInCategoryName:categoryName sortedByProperty:@"created_at"] mutableCopy]];
    }
    self.expandedSection = -1;
    
}

- (void)transitionToNextDataSource:(NSMutableArray *)nextDataSource
{
    NSArray *oldDataSource = self.dataSource;
    
    //Items in intersection set are the ones that persist
    NSMutableSet *intersection = [NSMutableSet setWithArray:oldDataSource];
    [intersection intersectSet:[NSSet setWithArray:nextDataSource]];
    
    //Items in difference set are thes ones that must be added
    NSMutableSet *difference = [NSMutableSet setWithArray:nextDataSource];
    [difference minusSet:intersection];

    NSMutableIndexSet *sectionsToRemove = [[NSMutableIndexSet alloc] init];
    for (NSUInteger i = 0; i < oldDataSource.count; i++) {
        CD_V2_Flyer *flyer = oldDataSource[i];
        if (![intersection containsObject:flyer]) {
            [sectionsToRemove addIndex:i];
        }
    }
    
    NSMutableArray *persistingDataSource = [oldDataSource mutableCopy];
    [persistingDataSource removeObjectsAtIndexes:sectionsToRemove];
    [persistingDataSource addObjectsFromArray:[difference allObjects]];
    [persistingDataSource sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CD_V2_Flyer *lhs = obj1;
        CD_V2_Flyer *rhs = obj2;
        return [rhs.created_at compare:lhs.created_at];
    }];
    NSIndexSet *sectionsToAdd = [persistingDataSource indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [difference containsObject:obj];
    }];
    
    self.dataSource = persistingDataSource;
    [self.delegate removeSectionsInIndexSet:sectionsToRemove addSectionsIndexSet:sectionsToAdd];
    
}

- (NSIndexPath *)showDescriptionCellForSection:(NSIndexPath *)indexPath
{
    NSIndexPath *indexToHide = nil;
    if (self.expandedSection >= 0) {
         indexToHide = [NSIndexPath indexPathForRow:1 inSection:self.expandedSection];
    }
    
    self.expandedSection = (indexPath) ? indexPath.section : -1;
    
    return indexToHide;
}
@end
