//
//  EventInfoFlyerTitleHTKCollectionViewCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/27/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "EventInfoFlyerTitleHTKCollectionViewCell.h"

@interface EventInfoFlyerTitleHTKCollectionViewCell()
@property (strong, nonatomic) UILabel *label;
@end

@implementation EventInfoFlyerTitleHTKCollectionViewCell

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
//    self.label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
    self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.label.textColor = [UIColor blackColor];
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.label];

    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_label);
    NSDictionary *metricDict = @{@"sideBuffer": @10};
    
    //Constrain elements horizontally
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=sideBuffer)-[_label]-(>=sideBuffer)-|" options:0 metrics:metricDict views:viewDict]];
    
    //Constrain elements vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=sideBuffer)-[_label]-(>=sideBuffer)-|" options:0 metrics:metricDict views:viewDict]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    
    [self.label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    CGSize defaultSize = DEFAULT_FLYER_TITLE_CELL_SIZE;
    self.label.preferredMaxLayoutWidth = defaultSize.width - 2 * [metricDict[@"sideBuffer"] floatValue];
}

- (void)setupCellWithTitle:(NSString *)title
{
    self.label.text = title;
}

@end
