//
//  SidewalkFlyerImageHTKCollectionViewCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/20/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "SidewalkFlyerImageHTKCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface SidewalkFlyerImageHTKCollectionViewCell()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *hairlineView;
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
 
    
    self.hairlineView = [[UIView alloc] initWithFrame:CGRectZero];
    self.hairlineView.translatesAutoresizingMaskIntoConstraints = NO;
    self.hairlineView.backgroundColor = [UIColor grayColor];
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.hairlineView];
    
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_imageView, _hairlineView);
    NSDictionary *metricDict = @{@"hairlineSize" : @(hairlineSize)};
    
    //Constrain elements horizontally
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_hairlineView]|" options:0 metrics:metricDict views:viewDict]];
    
    //Constrain elements vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_hairlineView(hairlineSize)]-(0)-[_imageView]|" options:0 metrics:metricDict views:viewDict]];
    
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [self.hairlineView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.hairlineView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
}

- (void)setupCellWithImage:(CD_Image *)image
{
    [self.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:image.imageURL] andPlaceholderImage:[UIImage imageNamed:@"Concrete_Pattern"] options:0 progress:nil completed:nil];
    
    /*
    CGSize imageSize = [SidewalkFlyerImageHTKCollectionViewCell sizeForCellWithImage:image];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_imageView);
    NSDictionary *metricDict = @{@"height" : [NSNumber numberWithFloat:imageSize.height],
                                 @"width" : [NSNumber numberWithFloat:imageSize.width],
                                 @"constant" : @100,
                                 };
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imageView(height)]" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imageView(width)]" options:0 metrics:metricDict views:viewDict]];
     */
    
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
