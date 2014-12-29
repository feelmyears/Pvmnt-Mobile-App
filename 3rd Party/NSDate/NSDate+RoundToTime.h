//
//  NSDate+RoundToTime.h
//  Rh7Kit
//
//  Created by 大木 聡 on 11/09/02.
//  Copyright 2011 rh7. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 @brief Adds RoundDate methods to NSDate
 
 This is a category on NSDate that adds methods for round(off|up|down) target date.
 */
@interface NSDate (NSDate_RoundToTime)
- (NSDate *)roundDateTo5Minutes;
- (NSDate *)roundDateTo10Minutes;
- (NSDate *)roundDateTo30Minutes;
- (NSDate *)roundDateToMinutes:(int)minuteInterval;
- (NSDate *)roundDateToCeiling5Minutes;
- (NSDate *)roundDateToCeiling10Minutes;
- (NSDate *)roundDateToCeiling30Minutes;
- (NSDate *)roundDateToCeilingMinutes:(int)minuteInterval;
- (NSDate *)roundDateToFlooring5Minutes;
- (NSDate *)roundDateToFlooring10Minutes;
- (NSDate *)roundDateToFlooring30Minutes;
- (NSDate *)roundDateToFlooringMinutes:(int)minuteInterval;
@end
