//
//  EventInfoFlyerDetailHTKCollectionViewCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/27/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "EventInfoFlyerDetailHTKCollectionViewCell.h"
#import "CD_V2_Category.h"
#import "NSDate+Utilities.h"

@interface EventInfoFlyerDetailHTKCollectionViewCell()
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation EventInfoFlyerDetailHTKCollectionViewCell
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
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
//    self.label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16];
    self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.label.textColor = [UIColor blackColor];
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.imageView];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_label, _imageView);
    NSDictionary *metricDict = @{@"sideBuffer": @10,
                                 @"verticalBuffer": @10,
                                 @"minimumVerticalSize": @20,
                                 @"imageSize": @20};
    
    //Constrain elements horizontally
    //    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imageView]" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_imageView(imageSize)]-sideBuffer-[_label]-(>=sideBuffer)-|" options:0 metrics:metricDict views:viewDict]];
    
    //Constrain elements vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imageView(imageSize)]" options:0 metrics:metricDict views:viewDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=verticalBuffer)-[_imageView(imageSize)]-(>=verticalBuffer)-|" options:0 metrics:metricDict views:viewDict]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [self.label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    
    CGSize defaultSize = DEFAULT_FLYER_DETAIL_CELL_SIZE;
    self.label.preferredMaxLayoutWidth = defaultSize.width - 3 * [metricDict[@"sideBuffer"] floatValue] - [metricDict[@"imageSize"] floatValue];
}

- (void)setupCellWithFlyer:(CD_V2_Flyer *)flyer forCellType:(EventInfoFlyerDetailHTKCollectionViewCellType)type
{
    UIImage *imageForCell;
    NSString *textForCell;
    switch (type) {
        case EventInfoFlyerDetailHTKCollectionViewCellTypeCategory: {
            imageForCell = [UIImage imageNamed:@"info_icon"];
            NSArray *categoryNames = [[flyer.flyerCategories allObjects] valueForKey:@"name"];
            NSString *categoryString = [categoryNames componentsJoinedByString:@", "];
            textForCell = categoryString;
            break;
        }
        case EventInfoFlyerDetailHTKCollectionViewCellTypeTime: {
            imageForCell = [UIImage imageNamed:@"time_icon"];
            textForCell = [NSString stringWithFormat:@"%@ at %@", [flyer.event_time longDateString], [flyer.event_time shortTimeString]];
            break;
        }
        case EventInfoFlyerDetailHTKCollectionViewCellTypeLocation:{
            textForCell = flyer.location;
            imageForCell = [UIImage imageNamed:@"location_icon"];
            break;
        }
        default:
            break;
    }
    self.label.text = textForCell;
    self.imageView.image = imageForCell;
}


@end
