//
//  CalendarSideDateModel.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/1/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "CalendarSideDateModel.h"
#import "FlyerDB.h"

@interface CalendarSideDateModel()
@property (strong, nonatomic) FlyerDB *database;
@end

@implementation CalendarSideDateModel
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAddedFlyer:) name:kCD_V2_FlyerImageDownloadedNotification object:nil];
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
    
    [self.delegate removeItemsAtIndexPath:indexPathsToRemove];
}

- (void)handleAddedFlyer:(NSNotification *)notification
{
    [self.delegate insertItemAtIndexPath:nil];
}


- (NSUInteger)numberOfItemsInSection:(NSUInteger)section
{
    return [self.database flyersAtDate:[[self.database flyerDates] objectAtIndex:section]].count;
}

- (NSUInteger)numberOfSections
{
    return [self.database flyerDates].count;
}

- (CD_V2_Flyer *)flyerAtIndexPath:(NSIndexPath *)indexPath
{
   return [[self.database flyersAtDate:[[self.database flyerDates] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
}

- (NSDate *)dateForSection:(NSUInteger)section;
{
    return [[self.database flyerDates] objectAtIndex:section];
}

- (NSArray *)flyersForSection:(NSUInteger)section
{
    return [self.database flyersAtDate:[[self.database flyerDates] objectAtIndex:section]];
}

@end
