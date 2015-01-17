//
//  SidewalkCalendarModel.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/12/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import "SidewalkCalendarModel.h"
#import "FlyerDB.h"
#import "SidewalkModel.h"
#import "CalendarSideDateModel.h"
#import "Flurry.h"

@interface SidewalkCalendarModel()<SidewalkModelDelegate, CalendarSideDateModelDelegate>
@property (strong, nonatomic) SidewalkModel *sidewalkModel;
@property (strong, nonatomic) CalendarSideDateModel *calendarModel;
@end


@implementation SidewalkCalendarModel
- (instancetype)init
{
    if (self = [super init]) {
        [self setupModel];
    }
    
    return self;
}

- (void)setupModel
{
    self.mode = SIdewalkCalendarModelModeNone;
    self.sidewalkModel = [[SidewalkModel alloc] init];
    self.sidewalkModel.delegate = self;
    
    self.calendarModel = [[CalendarSideDateModel alloc] init];
    self.calendarModel.delegate = self;
}


- (NSUInteger)numberOfSections
{
    switch (self.mode) {
        case SidewalkCalendarModelModeCalendar: {
            return [self.calendarModel numberOfSections];
        }
        case SidewalkCalendarModelModeSidewalk: {
            return [self.sidewalkModel numberOfSections];
        }
        default:
            return 0;
    }
}
- (NSUInteger)numberOfItemsInSection:(NSUInteger)section {
    switch (self.mode) {
        case SidewalkCalendarModelModeCalendar: {
           return [self.calendarModel numberOfItemsInSection:section];
        }
        case SidewalkCalendarModelModeSidewalk: {
            return [self.sidewalkModel numberOfItemsInSection:section];
        }
        default:
            return 0;
    }
}
- (NSDate *)dateForSection:(NSUInteger)section {
    switch (self.mode) {
        case SidewalkCalendarModelModeCalendar: {
            return [self.calendarModel dateForSection:section];
        }
        case SidewalkCalendarModelModeSidewalk: {
            return nil;
        }
        default:
            return nil;
    }
}
- (CD_V2_Flyer *)flyerAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.mode) {
        case SidewalkCalendarModelModeCalendar: {
            return [self.calendarModel flyerAtIndexPath:indexPath];
        }
        case SidewalkCalendarModelModeSidewalk: {
            return [self.sidewalkModel flyerAtIndexPath:indexPath];
        }
        default:
            return 0;
    }
}

- (void)refreshDatabase {
    [self.calendarModel refreshDatabase];
    [self.sidewalkModel refreshDatabase];

}
- (void)filterWithCategoryName:(NSString *)categoryName {
    [Flurry logEvent:kFlurryFilteredByCategoryKey withParameters:@{kFlurryFilteredByCategoryCategoryNameKey : categoryName}];
    [self.calendarModel filterWithCategoryName:categoryName];
    [self.sidewalkModel filterWithCategoryName:categoryName];

}

#pragma mark - SidewalkModelDelegate Implementation
- (void)removeSectionsInIndexSet:(NSIndexSet *)sectionsToRemove addSectionsIndexSet:(NSIndexSet *)sectionsToAdd
{
    switch (self.mode) {
        case SidewalkCalendarModelModeCalendar: {
            break;
        }
        case SidewalkCalendarModelModeSidewalk: {
            [self.delegate removeSectionsInIndexSet:sectionsToRemove addSectionsIndexSet:sectionsToAdd];
        }
        default:
            break;
    }
}

- (void)removeItemsAtIndexes:(NSArray *)indexesToRemove addItemsAtIndexes:(NSArray *)indexesToAdd dateSectionsToRemove:(NSIndexSet *)sectionsToRemove dateSectionsToAdd:(NSIndexSet *)sectionsToAdd
{
    switch (self.mode) {
        case SidewalkCalendarModelModeCalendar: {
            [self.delegate removeItemsAtIndexes:indexesToRemove addItemsAtIndexes:indexesToAdd dateSectionsToRemove:sectionsToRemove dateSectionsToAdd:sectionsToAdd];
        }
        case SidewalkCalendarModelModeSidewalk: {
            break;
        }
        default:
            break;
    }
}
@end
