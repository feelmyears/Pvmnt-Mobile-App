//
//  NSDate+RoundToTime.m
//  Rh7Kit
//
//  Created by 大木 聡 on 11/09/02.
//  Copyright 2011 rh7. All rights reserved.
//

#import "NSDate+RoundToTime.h"


#define SECONDS_OF_MINUTE 60

@implementation NSDate (NSDate_RoundToTime)

/* Private methods */
+ (NSDateComponents *)getTimeComponents:(NSDate *)date
{
    NSDateComponents *timeComps = [[NSCalendar currentCalendar]
         components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
         fromDate:date];
    return timeComps;
}

- (NSInteger)getSeconds
{
    return [[[self class] getTimeComponents:self] second];
}

- (NSInteger)getMinutes
{
    return [[[self class] getTimeComponents:self] minute];
}

- (NSInteger)getHours
{
    return [[[self class] getTimeComponents:self] hour];
}
/* END OF Private methods */

- (NSDate *)roundDateTo5Minutes
{
    return [self roundDateToMinutes:5];
}

- (NSDate *)roundDateTo10Minutes
{
    return [self roundDateToMinutes:10];
}

- (NSDate *)roundDateTo30Minutes
{
    return [self roundDateToMinutes:30];
}

- (NSDate *)roundDateToMinutes:(int)minuteInterval
{
    NSInteger minutes = [self getMinutes];
    int onesDigit = minutes % 10;
    NSDate *date;
    if (onesDigit < 5) {
        date = [self roundDateToFlooringMinutes:minuteInterval];
    } else {
        date = [self roundDateToCeilingMinutes:minuteInterval];
    }    
    return date;
}

- (NSDate *)roundDateToCeiling5Minutes
{
    return [self roundDateToCeilingMinutes:5];
}

- (NSDate *)roundDateToCeiling10Minutes
{
    return [self roundDateToCeilingMinutes:10];
}

- (NSDate *)roundDateToCeiling30Minutes
{
    return [self roundDateToCeilingMinutes:30];
}

- (NSDate *)roundDateToCeilingMinutes:(int)minuteInterval
{
    NSInteger minutes = [self getMinutes];
    int remain = minutes % minuteInterval;
    NSDate *date = [self dateByAddingTimeInterval:
            (SECONDS_OF_MINUTE * (minuteInterval - remain)) - [self getSeconds]];

    return date;
}

- (NSDate *)roundDateToFlooring5Minutes
{
    return [self roundDateToFlooringMinutes:5];
}

- (NSDate *)roundDateToFlooring10Minutes
{
    return [self roundDateToFlooringMinutes:10];
}

- (NSDate *)roundDateToFlooring30Minutes
{
    return [self roundDateToFlooringMinutes:30];
}

- (NSDate *)roundDateToFlooringMinutes:(int)minuteInterval
{
    NSInteger minutes = [self getMinutes];
    int remain = minutes % minuteInterval;
    NSDate *date = [self dateByAddingTimeInterval:-(SECONDS_OF_MINUTE * remain) - [self getSeconds]];

    return date;
}

@end
