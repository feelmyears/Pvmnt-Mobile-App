//
//  CD_V2_Flyer.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/20/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "CD_V2_Flyer.h"
#import "CD_Image.h"
#import "CD_V2_Category.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "NSDate+Utilities.h"

NSString *const kCD_V2_FlyerImageDownloadedNotification                     = @"CD_V2_FlyerImageDownloadedNotification";
NSString *const kCD_V2_FlyerImageDownloadedNotificationUserInfoFlyerIdKey   = @"CD_V2_FlyerImageDownloadedNotificationUserInfoFlyerIdKey";

@implementation CD_V2_Flyer

@dynamic approved;
@dynamic created_at;
@dynamic desc;
@dynamic event_date;
@dynamic flyerId;
@dynamic location;
@dynamic title;
@dynamic updated_at;
@dynamic event_time;
@dynamic flyerCategories;
@dynamic image;

- (void)updateWithRK_Flyer:(RK_Flyer *)rkFlyer
{
    if (![self.updated_at isEqual:rkFlyer.updated_at]) {
        BOOL updated = NO;
        if (![self.title isEqualToString:[rkFlyer.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
            self.title = [rkFlyer.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            updated = YES;
        }
        
        if (![self.desc isEqualToString:[rkFlyer.flyerDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
            self.desc = [rkFlyer.flyerDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            updated = YES;
        }
        
        if (![self.image.imageURL isEqualToString:rkFlyer.imageURL]) {
            [self.image MR_deleteEntity];
            CD_Image *image = [CD_Image MR_createEntity];
            image.imageURL = rkFlyer.imageURL;
            image.imageDownloaded = @(NO);
            self.image = image;
            updated = YES;
        }
        
        if (![self.event_time isEqualToDate:rkFlyer.event_date]) {
            self.event_date = [rkFlyer.event_date dateAtStartOfDay];
            self.event_time = rkFlyer.event_date;
            updated = YES;
        }
        
        if (![self.location isEqualToString:[rkFlyer.location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
            self.location = [rkFlyer.location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            updated = YES;
        }
        
        if (![self.approved isEqual: @(rkFlyer.approved)]) {
            self.approved = [NSNumber numberWithBool:rkFlyer.approved];
            updated = YES;
        }
    }
}

@end
