//
//  FlyerDB.h
//  PVMNT
//
//  Created by Phil Meyers IV on 10/16/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SVPullToRefresh.h"

extern NSString *const kFlyerDBRemovedFlyersNotification;
extern NSString *const kFlyerDBAddedFlyerNotification;

@interface FlyerDB : NSObject


+ (id)sharedInstance;
//- (void)configureRestKit;
//- (void)fetchAllFlyers;
//- (void)fetchAllCategories;
//- (void)deleteOldFlyers;
//- (void)refresh:(SVPullToRefreshView *)pullToRefreshView withCompletionBlock:(void (^)())completionBlock;
- (void)fetchAllWithCompletionBlock:(void (^)())completionBlock;

- (NSArray *)flyerDates;
- (NSArray *)flyersAtDate:(NSDate *)date;
- (NSArray *)allFlyersSortedByDateAndTime;
- (NSArray *)allFlyersSortedByUploadDate;
@end
