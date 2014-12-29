//
//  EventInfoActionCellView.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/27/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "EventInfoActionCellView.h"
@interface EventInfoActionCellView()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;
@end

static CGFloat imageViewSize = 25.f;
static CGFloat padding = 5.f;
static CGFloat fontSize = 10.f;
static CGFloat topOffset = 10.f;
@implementation EventInfoActionCellView
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
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
        self.label.font = [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
//    self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.label.textColor = [UIColor blackColor];
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.imageView];
    [self addSubview:self.label];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_imageView, _label);
    NSDictionary *metricDict = @{@"imageViewSize" : @(imageViewSize),
                                 @"padding" : @(padding),
                                 @"topOffset" : @(topOffset)};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imageView(imageViewSize)]" options:0 metrics:metricDict views:viewDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=padding)-[_label]-(>=padding)-|" options:0 metrics:metricDict views:viewDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topOffset)-[_imageView(imageViewSize)]" options:0 metrics:metricDict views:viewDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_label]-(padding)-|" options:0 metrics:metricDict views:viewDict]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
}

-(void)setupActionCellWithTitle:(NSString *)title andImage:(UIImage *)image
{
    self.label.text = title;
    self.imageView.image = image;
}

@end
