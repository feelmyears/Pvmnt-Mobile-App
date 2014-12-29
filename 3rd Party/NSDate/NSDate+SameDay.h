//
//  NSDate+SameDay.h
//  Plannr
//
//  Created by Phil Meyers IV on 7/7/14.
//  Copyright (c) 2014 Plannr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SameDay)
+ (BOOL)isDate:(NSDate*)firstDate sameDayAs:(NSDate*)secondDate;
@end
