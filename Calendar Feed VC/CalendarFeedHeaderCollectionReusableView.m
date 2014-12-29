//
//  CalendarFeedHeaderCollectionReusableView.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/21/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "CalendarFeedHeaderCollectionReusableView.h"
#import "NSDate+Utilities.h"

@interface CalendarFeedHeaderCollectionReusableView()
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *topHairline;
@property (strong, nonatomic) UIView *bottomHairline;
@end

static CGFloat hairlineSize = 0.5;

@implementation CalendarFeedHeaderCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.f];
    self.label.textColor = [UIColor blackColor];
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.textAlignment = NSTextAlignmentLeft;
    
    
    self.topHairline = [[UIView alloc] initWithFrame:CGRectZero];
    self.topHairline.translatesAutoresizingMaskIntoConstraints = NO;
    self.topHairline.backgroundColor = [UIColor grayColor];
    
    self.bottomHairline = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomHairline.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomHairline.backgroundColor = [UIColor grayColor];

    
    [self.contentView addSubview:self.topHairline];
    [self.contentView addSubview:self.bottomHairline];
    [self.contentView addSubview:self.label];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_label, _topHairline, _bottomHairline);
    NSDictionary *metricDict = @{@"hairlineDimension" : @(hairlineSize)};
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topHairline]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomHairline]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(5)-[_label]" options:0 metrics:metricDict views:viewDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topHairline(hairlineDimension)]" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomHairline(hairlineDimension)]|" options:0 metrics:metricDict views:viewDict]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.topHairline setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.topHairline setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.bottomHairline setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.bottomHairline setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)setupCellWithDate:(NSDate *)date
{
    NSMutableString *dateString = [NSMutableString new];
    if ([date isToday]) {
        [dateString appendString:@"Today"];
        [dateString appendFormat:@" \u2022 "];
    } else if ([date isTomorrow]) {
        [dateString appendString:@"Tomorrow "];
        [dateString appendFormat:@" \u2022 "];
    }
    [dateString appendString:[date longDateString]];
    self.label.text = dateString;
}
@end
