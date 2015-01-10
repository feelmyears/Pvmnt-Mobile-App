//
//  CalendarSideDateModel.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/1/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CD_V2_Flyer.h"


@class CalendarSideDateModel;
@protocol CalendarSideDateModelDelegate <NSObject>

@required
- (void)removeItemsAtIndexes:(NSArray *)indexesToRemove addItemsAtIndexes:(NSArray *)indexesToAdd dateSectionsToRemove:(NSIndexSet *)sectionsToRemove dateSectionsToAdd:(NSIndexSet *)sectionsToAdd;
@optional
- (void)removeItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths;
@end

@interface CalendarSideDateModel : NSObject
@property (weak, nonatomic) id<CalendarSideDateModelDelegate> delegate;
@property (strong, nonatomic) NSString *filterString;
- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfItemsInSection:(NSUInteger)section;
- (NSDate *)dateForSection:(NSUInteger)section;
- (void)refreshDatabase;
- (CD_V2_Flyer *)flyerAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)flyersInSection:(NSUInteger)section;
- (void)filterWithCategoryName:(NSString *)categoryName;

@end
