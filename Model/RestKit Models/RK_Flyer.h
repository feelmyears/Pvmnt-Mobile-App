//
//  RK_Flyer.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/13/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RK_Category.h"

@interface RK_Flyer : NSObject

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
@property (strong, nonatomic) RK_Category *categeory;

@end
