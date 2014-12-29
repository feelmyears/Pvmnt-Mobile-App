//
//  Created by Dmitry Ivanenko on 15.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import "DIDatepickerDateView.h"
#import "FlyerDB.h"
#import "NSDate+Utilities.h"

const CGFloat kDIDatepickerItemWidth = 46.;
const CGFloat kDIDatepickerSelectionLineWidth = 51.;

@interface DIDatepickerDateView ()

@property (strong, nonatomic) UILabel *dateLabel;
@property (nonatomic, strong) UIView *selectionView;
@property (nonatomic) BOOL eventOnDate;

@end


@implementation DIDatepickerDateView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self setupViews];

    return self;
}

- (void)setupViews
{
    [self addTarget:self action:@selector(dateWasSelected) forControlEvents:UIControlEventTouchUpInside];
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    self.eventOnDate = [[[FlyerDB sharedInstance] flyerDates] containsObject:[_date dateAtStartOfDay]];
    self.userInteractionEnabled = self.eventOnDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"dd"];
    NSString *dayFormattedString = [dateFormatter stringFromDate:date];

    [dateFormatter setDateFormat:@"EEE"];
    NSString *dayInWeekFormattedString = [dateFormatter stringFromDate:date];

    [dateFormatter setDateFormat:@"MMMM"];
    NSString *monthFormattedString = [[dateFormatter stringFromDate:date] uppercaseString];

    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@\n%@", dayFormattedString, [dayInWeekFormattedString uppercaseString], monthFormattedString]];

    
    UIColor *textColor = (self.eventOnDate) ? [UIColor blackColor] : [[UIColor grayColor] colorWithAlphaComponent:.5f];
    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:20],
                                NSForegroundColorAttributeName: textColor
                                }
                        range:NSMakeRange(0, dayFormattedString.length)];

    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:8],
                                NSForegroundColorAttributeName: textColor
                                }
                        range:NSMakeRange(dayFormattedString.length + 1, dayInWeekFormattedString.length)];

    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:8],
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

    self.dateLabel.attributedText = dateString;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    self.selectionView.alpha = (int)_isSelected;
    UIColor *textColor;
    if (isSelected) {
        textColor = [UIColor colorWithRed:212./255 green:175./255 blue:55./255 alpha:1.];
    } else {
        textColor = (self.eventOnDate) ? [UIColor blackColor] : [[UIColor grayColor] colorWithAlphaComponent:.5f];
    }
    NSMutableAttributedString *changeColorString = [self.dateLabel.attributedText mutableCopy];
    [changeColorString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, [self.dateLabel.attributedText length])];
    
    self.dateLabel.attributedText = changeColorString;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dateLabel.numberOfLines = 2;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dateLabel];
    }

    return _dateLabel;
}

- (UIView *)selectionView
{
    if (!_selectionView) {
//        _selectionView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 51) / 2, self.frame.size.height - 3, 51, 3)];
        _selectionView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 51) / 2, 0, 51, 3)];
        _selectionView.alpha = 0;
//        _selectionView.backgroundColor = [UIColor colorWithRed:242./255. green:93./255. blue:28./255. alpha:1.];
        _selectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:_selectionView];
    }

    return _selectionView;
}

- (void)setItemSelectionColor:(UIColor *)itemSelectionColor
{
    self.selectionView.backgroundColor = itemSelectionColor;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.selectionView.alpha = self.isSelected ? 1 : .5;
    } else {
        self.selectionView.alpha = self.isSelected ? 1 : 0;
    }
}


#pragma mark Other methods

- (BOOL)isWeekday:(NSDate *)date
{
    NSInteger day = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date] weekday];

    const NSInteger kSunday = 1;
    const NSInteger kSaturday = 7;

    BOOL isWeekdayResult = day == kSunday || day == kSaturday;

    return isWeekdayResult;
}

- (void)dateWasSelected
{
    self.isSelected = YES;

    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
