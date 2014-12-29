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
- (void)removeItemsAtIndexPath:(NSArray *)indexPaths;
- (void)insertItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)beginBatchUpdate;
- (void)endBatchUpdate;
@end

@interface CalendarSideDateModel : NSObject
@property (weak, nonatomic) id<CalendarSideDateModelDelegate> delegate;

- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfItemsInSection:(NSUInteger)section;
- (CD_V2_Flyer *)flyerAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)flyersForSection:(NSUInteger)section;
- (NSDate *)dateForSection:(NSUInteger)section;

@end
