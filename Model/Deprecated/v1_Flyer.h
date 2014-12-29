//
//  v1_Flyer.h
//  PVMNT
//
//  Created by Phil Meyers IV on 10/11/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "v2_Category.h"
@interface v1_Flyer : NSObject

@property (nonatomic) NSUInteger flyerId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *flyerDescription;
@property (strong, nonatomic) NSDate *created_at;
@property (strong, nonatomic) NSDate *updated_at;

@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSDate *event_date;
@property (strong, nonatomic) NSString *location;
@property (nonatomic) BOOL approved;
@property (nonatomic) NSUInteger counter_cache;
@property (strong, nonatomic) UIImage *flyerImage;
@property (strong, nonatomic) v2_Category *categeory;

@end
