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
@end


@implementation SidewalkModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.database = [FlyerDB sharedInstance];
        [self setupNotifications];
    }
    return self;
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
    return 2;
}

- (NSUInteger)numberOfSections
{
    return [self.database allFlyersSortedByUploadDate].count;
}

- (CD_V2_Flyer *)flyerAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.database allFlyersSortedByUploadDate][indexPath.section];
}

@end
