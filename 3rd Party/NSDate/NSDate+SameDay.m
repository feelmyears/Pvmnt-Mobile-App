//
//  NSDate+SameDay.m
//  Plannr
//
//  Created by Phil Meyers IV on 7/7/14.
//  Copyright (c) 2014 Plannr. All rights reserved.
//

#import "NSDate+SameDay.h"

@implementation NSDate (SameDay)

+ (BOOL)isDate:(NSDate *)firstDate sameDayAs:(NSDate *)secondDate
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:firstDate];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:secondDate];
    
    return [comp1 day] == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year]  == [comp2 year];
}

@end
