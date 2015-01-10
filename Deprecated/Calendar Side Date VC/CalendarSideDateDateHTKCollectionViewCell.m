//
//  CalendarSideDateDateHTKCollectionViewCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/2/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "CalendarSideDateDateHTKCollectionViewCell.h"
#import "NSDate+Utilities.h"

@interface CalendarSideDateDateHTKCollectionViewCell()
@property (strong, nonatomic) UILabel *monthLabel;
@property (strong, nonatomic) UILabel *dateNameLabel;
@property (strong, nonatomic) UILabel *dayLabel;
@end

static CGFloat cellPadding = 10.f;

@implementation CalendarSideDateDateHTKCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];

    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.monthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.monthLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:10];
    self.monthLabel.textColor = [UIColor whiteColor];
    self.monthLabel.numberOfLines = 1;
    self.monthLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.monthLabel.textAlignment = NSTextAlignmentLeft;
    self.monthLabel.minimumScaleFactor = 10./30.;
    self.monthLabel.adjustsFontSizeToFitWidth = YES;
    
    self.dateNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.dateNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.dateNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:10];
    self.dateNameLabel.textColor = [UIColor whiteColor];
    self.dateNameLabel.numberOfLines = 1;
    self.dateNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.dateNameLabel.textAlignment = NSTextAlignmentLeft;
    
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.dayLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:80];
    self.dayLabel.textColor = [UIColor whiteColor];
    self.dayLabel.numberOfLines = 1;
    self.dayLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.dayLabel.textAlignment = NSTextAlignmentLeft;
    self.dayLabel.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
    self.dayLabel.minimumScaleFactor = 10./30.;
    self.dayLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.contentView addSubview:self.monthLabel];
    [self.contentView addSubview:self.dateNameLabel];
    [self.contentView addSubview:self.dayLabel];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_monthLabel, _dateNameLabel, _dayLabel);
    NSDictionary *metricDict = @{@"padding": [NSNumber numberWithFloat:cellPadding],
                                 @"zeroPadding": @0};
    
    [self.dateNameLabel setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_dayLabel(40)]-padding-[_dateNameLabel]-(>=zeroPadding)-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_monthLabel]-|" options:0 metrics:metricDict views:viewDict]];
    
    //Constrain elements vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[_dayLabel]-(zeroPadding)-[_monthLabel]-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[_dateNameLabel]-(zeroPadding)-[_monthLabel]-|" options:0 metrics:metricDict views:viewDict]];
    
    [self.dayLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.dayLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [self.dateNameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    [self.dateNameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.monthLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.monthLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
//    CGSize defaultSize = DEFAULT_FLYER_CELL_SIZE;
//    self.titleLabel.preferredMaxLayoutWidth = defaultSize.width - 2 * [metricDict[@"padding"] floatValue] - [metricDict[@"imageViewSize"] floatValue];
//    
//    self.minorLabel.preferredMaxLayoutWidth = defaultSize.width - 2 * [metricDict[@"padding"] floatValue] - [metricDict[@"imageViewSize"] floatValue];
    
}


- (void)setupCellWithDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *dayFormattedString = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"EEE"];
    NSString *dayInWeekFormattedString = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"MMMM"];
    NSString *monthFormattedString = [[dateFormatter stringFromDate:date] uppercaseString];

    
    self.dayLabel.text = dayFormattedString;
    self.monthLabel.text = monthFormattedString;
    self.dateNameLabel.text = dayInWeekFormattedString;
}


@end
