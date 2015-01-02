//
//  SidewalkFlyerImageHTKCollectionViewCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/20/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "SidewalkFlyerImageHTKCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+Utilities.h"
#import "PvmntStyleKit.h"
#import "GradientView.h"

@interface SidewalkFlyerImageHTKCollectionViewCell()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) GradientView *gradientView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@end

static CGFloat hairlineSize = 0.5;

@implementation SidewalkFlyerImageHTKCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];
    
    self.gradientView = [[GradientView alloc] initWithFrame:CGRectZero];
    self.gradientView.translatesAutoresizingMaskIntoConstraints = NO;
 
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.numberOfLines = 0;
    self.timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.gradientView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
   
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_imageView, _timeLabel, _titleLabel, _gradientView);
    NSDictionary *metricDict = @{@"padding" : @5};
    
    //Constrain elements horizontally
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_gradientView]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[_titleLabel]-(>=padding)-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[_timeLabel]-(>=padding)-|" options:0 metrics:metricDict views:viewDict]];
    
    //Constrain elements vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_gradientView]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]-(0)-[_timeLabel]-(padding)-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.gradientView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeTop multiplier:1 constant:-20]];
    
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    
    for (UILabel *label in @[self.titleLabel, self.timeLabel]) {
        [label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        CGSize defaultSize = DEFAULT_SIDEWALK_FLYER_IMAGE_CELL_SIZE;
        label.preferredMaxLayoutWidth = defaultSize.width - 2 * [metricDict[@"padding"] floatValue];
    }
}

- (void)setupCellWithFlyer:(CD_V2_Flyer *)flyer
{
    [self.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:flyer.image.imageURL] andPlaceholderImage:[UIImage imageNamed:@"Concrete_Pattern"] options:0 progress:nil completed:nil];
    self.titleLabel.text = flyer.title;
    self.timeLabel.text = flyer.event_time.mediumString;
}

- (void)setupCellWithImage:(CD_Image *)image
{
    [self.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:image.imageURL] andPlaceholderImage:[UIImage imageNamed:@"Concrete_Pattern"] options:0 progress:nil completed:nil];
    
}

+ (CGSize)sizeForCellWithImage:(CD_Image *)image
{
    CGFloat imageWidth = [image.width floatValue];
    CGFloat imageHeight = [image.height floatValue];
    
    CGFloat contentWidth = DEFAULT_SIDEWALK_FLYER_IMAGE_CELL_SIZE.width;
    CGFloat fixedItemWidth = contentWidth;
    CGFloat heightToWidthRatio = imageHeight/imageWidth;
    CGFloat heightForItem = fixedItemWidth * heightToWidthRatio;
    
    return CGSizeMake(fixedItemWidth, heightForItem + hairlineSize);
}

@end
