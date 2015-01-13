//  SidewalkCalendarModel.h
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/12/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CD_V2_Flyer.h"

@class SidewalkCalendarModel;
@protocol SidewalkCalendarModelDelegate <NSObject>
@required
- (void)removeSectionsInIndexSet:(NSIndexSet *)sectionsToRemove addSectionsIndexSet:(NSIndexSet *)sectionsToAdd;
- (void)removeItemsAtIndexes:(NSArray *)indexesToRemove addItemsAtIndexes:(NSArray *)indexesToAdd dateSectionsToRemove:(NSIndexSet *)sectionsToRemove dateSectionsToAdd:(NSIndexSet *)sectionsToAdd;
@end

typedef enum : NSUInteger {
    SidewalkCalendarModelModeSidewalk,
    SidewalkCalendarModelModeCalendar,
} SidewalkCalendarModelMode;

@interface SidewalkCalendarModel : NSObject
@property (weak, nonatomic) id<SidewalkCalendarModelDelegate> delegate;
@property (strong, nonatomic) NSString *filterString;
@property (nonatomic) SidewalkCalendarModelMode mode;

- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfItemsInSection:(NSUInteger)section;
- (NSDate *)dateForSection:(NSUInteger)section;
- (CD_V2_Flyer *)flyerAtIndexPath:(NSIndexPath *)indexPath;

- (void)refreshDatabase;
- (void)filterWithCategoryName:(NSString *)categoryName;
@end

