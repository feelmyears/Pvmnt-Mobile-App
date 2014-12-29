//
//  CD_V2_Flyer.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/20/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RK_Flyer.h"
#import "CD_Image.h"
#import "CD_V2_Category.h"

extern NSString *const kCD_V2_FlyerImageDownloadedNotification;
extern NSString *const kCD_V2_FlyerImageDownloadedNotificationUserInfoFlyerIdKey;

@class CD_Image, CD_V2_Category;

@interface CD_V2_Flyer : NSManagedObject

@property (nonatomic, retain) NSNumber * approved;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDate * event_date;
@property (nonatomic, retain) NSNumber * flyerId;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSDate * event_time;
@property (nonatomic, retain) NSSet *flyerCategories;
@property (nonatomic, retain) CD_Image *image;
@end

@interface CD_V2_Flyer (CoreDataGeneratedAccessors)

- (void)addFlyerCategoriesObject:(CD_V2_Category *)value;
- (void)removeFlyerCategoriesObject:(CD_V2_Category *)value;
- (void)addFlyerCategories:(NSSet *)values;
- (void)removeFlyerCategories:(NSSet *)values;
- (void)updateWithRK_Flyer:(RK_Flyer *)rkFlyer;

@end
