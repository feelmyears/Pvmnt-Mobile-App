//
//  EventInfoFlyerImageHTKCollectionViewCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/26/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "EventInfoFlyerImageHTKCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

static CGFloat VERTICAL_BUFFER = 20.f;
static CGFloat MASK_SIZE = 10.f;
static CGFloat FRAME_HEIGHT = 40;

@interface EventInfoFlyerImageHTKCollectionViewCell()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *frameView;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) CD_Image *image;
@end

@implementation EventInfoFlyerImageHTKCollectionViewCell


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
    
    self.frameView = [[UIView alloc] initWithFrame:CGRectZero];
    self.frameView.translatesAutoresizingMaskIntoConstraints = NO;
    self.frameView.backgroundColor = [UIColor clearColor];
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectZero];
    self.maskView.translatesAutoresizingMaskIntoConstraints = NO;
    self.maskView.backgroundColor = [UIColor clearColor];
    self.maskView.alpha = 0;
    
    
    [self.contentView addSubview:self.frameView];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.maskView];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_imageView, _frameView, _maskView);
    NSDictionary *metricDict = @{@"sideBuffer": @0,
                                 @"verticalBuffer": [NSNumber numberWithFloat:VERTICAL_BUFFER],
                                 @"verticalFrameValue": @(20 + VERTICAL_BUFFER),
                                 @"zeroValue": @0};
    
    //Constrain elements horizontally
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[_imageView]-(>=0)-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_frameView]|" options:0 metrics:metricDict views:viewDict]];
    
    //Constrain elements vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_frameView(verticalFrameValue)]|" options:0 metrics:metricDict views:viewDict]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_frameView attribute:NSLayoutAttributeTop relatedBy:0 toItem:_imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:-60]];
    
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_frameView]|" options:0 metrics:metricDict views:viewDict]];
    
    
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [self.frameView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.frameView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
}

- (void)setupCellWithImage:(CD_Image *)image
{
    self.image = image;
    
    [self.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:image.imageURL] andPlaceholderImage:[UIImage imageNamed:@"Concrete_Pattern"] options:0 progress:nil completed:nil];
}

+ (CGSize)sizeForCellWithImage:(CD_Image *)image
{
    CGFloat imageWidth = [image.width floatValue];
    CGFloat imageHeight = [image.height floatValue];
    CGFloat dimConstant = 225.f;
    CGSize finalImageSize = CGSizeZero;
    
    if (imageWidth > imageHeight) { //Landscape image
        CGFloat widthToHeightRatio = imageWidth / imageHeight;
        CGFloat newWidth = dimConstant * widthToHeightRatio;
        if (newWidth > DEFAULT_FLYER_IMAGE_CELL_SIZE.width) {
            newWidth = DEFAULT_FLYER_IMAGE_CELL_SIZE.width;
            CGFloat heightToWidthRatio = imageHeight / imageWidth;
            CGFloat newHeight = newWidth * heightToWidthRatio;
            finalImageSize.width = newWidth;
            finalImageSize.height = newHeight;
            //            self.bottomVerticalSpace.constant = -1 * newHeight/2;
        } else {
            finalImageSize.width = newWidth;
            finalImageSize.height = dimConstant;
            //            self.bottomVerticalSpace.constant = -1 * dimConstant/2;
        }
    } else { //Portrait image
        CGFloat widthToHeightRatio = imageWidth / imageHeight;
        CGFloat newWidth = dimConstant * widthToHeightRatio;
        finalImageSize.width = newWidth;
        finalImageSize.height = dimConstant;
        //        self.bottomVerticalSpace.constant = -1 * dimConstant/2;
    }
    
    return (CGSizeMake(DEFAULT_FLYER_IMAGE_CELL_SIZE.width, finalImageSize.height + VERTICAL_BUFFER));

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
//    UIBezierPath *framePath = [UIBezierPath bezierPath];
//    
//    [framePath moveToPoint:CGPointMake(0, rect.size.height)];           //starting at bottom left
//    [framePath addLineToPoint:CGPointMake(0, FRAME_HEIGHT)];
//    [framePath addLineToPoint:CGPointMake(_imageView.frame.origin.x - MASK_SIZE, FRAME_HEIGHT)];
//    [framePath addLineToPoint:CGPointMake(_imageView.frame.origin.x - MASK_SIZE, rect.size.height - MASK_SIZE)];
//    [framePath addLineToPoint:CGPointMake(_imageView.frame.origin.x + _imageView.frame.size.width + MASK_SIZE, rect.size.height - MASK_SIZE)];
//    [framePath addLineToPoint:CGPointMake(_imageView.frame.origin.x + _imageView.frame.size.width + MASK_SIZE, FRAME_HEIGHT)];
//    [framePath addLineToPoint:CGPointMake(rect.size.width, FRAME_HEIGHT)];
//    [framePath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
//    [framePath closePath];
//    
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.path = framePath.CGPath;
    
//    [self.frameView.layer setMask:maskLayer];
//    [[UIColor whiteColor] setFill];
//    [framePath fill];
}

@end
