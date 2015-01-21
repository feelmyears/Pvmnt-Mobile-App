//
//  CalendarSideDateCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/23/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "CalendarSideDateCell.h"
#import "NSDate+Utilities.h"

@interface CalendarSideDateCell()
@property (weak, nonatomic) IBOutlet UILabel *dayNumberLabel;

@end

@implementation CalendarSideDateCell
- (void)setDateForHeader:(NSDate *)dateForHeader
{
    _dateForHeader = dateForHeader;
//    self.dayNumberLabel.text = [NSString stringWithFormat:@"%lu", (long)dateForHeader.day];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"eeee"];
//    self.dayNameLabel.text = [[dateFormatter stringFromDate:dateForHeader] lowercaseString];
//    
//    [dateFormatter setDateFormat:@"LLL"];
//    self.monthLabel.text = [[dateFormatter stringFromDate:dateForHeader] lowercaseString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *dayFormattedString = [dateFormatter stringFromDate:dateForHeader];
    
    [dateFormatter setDateFormat:@"EEE"];
    NSString *dayInWeekFormattedString = [dateFormatter stringFromDate:dateForHeader];
    
    [dateFormatter setDateFormat:@"MMMM"];
    NSString *monthFormattedString = [[dateFormatter stringFromDate:dateForHeader] lowercaseString];
    
    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@\n%@", dayFormattedString, [dayInWeekFormattedString lowercaseString], monthFormattedString]];
    
    
    UIColor *textColor = [UIColor whiteColor];
    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Light" size:16],
                                NSForegroundColorAttributeName: textColor
                                }
                        range:NSMakeRange(0, dayFormattedString.length)];
    
    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Light" size:14],
                                NSForegroundColorAttributeName: textColor
                                }
                        range:NSMakeRange(dayFormattedString.length + 1, dayInWeekFormattedString.length)];
    
    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Light" size:12],
                                NSForegroundColorAttributeName: textColor
                                }
                        range:NSMakeRange(dateString.string.length - monthFormattedString.length, monthFormattedString.length)];
    
    /*
     if ([self isWeekday:date]) {
     [dateString addAttribute:NSFontAttributeName
     value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:8]
     range:NSMakeRange(dayFormattedString.length + 1, dayInWeekFormattedString.length)];
     }
     */
    
    self.dayNumberLabel.attributedText = dateString;
    self.dayNumberLabel.textAlignment = NSTextAlignmentRight;

}

- (void)awakeFromNib {
    // Initialization code

}

@end
