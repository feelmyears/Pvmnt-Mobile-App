//
//  EventInfoFlyerImageCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/5/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "EventInfoFlyerImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <URBMediaFocusViewController/URBMediaFocusViewController.h>
#import "UIView+RoundedCorners.h"

@interface EventInfoFlyerImageCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *imageViewBorder;
@property (weak, nonatomic) IBOutlet UIView *baseView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomVerticalSpace;
@property (strong, nonatomic) UITapGestureRecognizer *imageTapGR;
@property (strong, nonatomic) URBMediaFocusViewController *URBMediaFocusVC;
@end

#define DIMENSION_CONSTANT 225

@implementation EventInfoFlyerImageCell

- (URBMediaFocusViewController *)URBMediaFocusVC
{
    if (!_URBMediaFocusVC) {
        _URBMediaFocusVC = [[URBMediaFocusViewController alloc] init];
        _URBMediaFocusVC.parallaxEnabled = NO;
        _URBMediaFocusVC.shouldBlurBackground = YES;
        _URBMediaFocusVC.shouldDismissOnImageTap = YES;
    }
    return _URBMediaFocusVC;
}

- (UITapGestureRecognizer *)imageTapGR
{
    if (!_imageTapGR) {
        _imageTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTapped:)];
    }
    return _imageTapGR;
}

- (void)handleImageTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.URBMediaFocusVC showImage:self.imageView.image fromView:self.imageView];
}

- (void)setImage:(CD_Image *)image
{
    _image = image;
    
    CGFloat imageWidth = [image.width floatValue];
    CGFloat imageHeight = [image.height floatValue];
    CGFloat dimConstant = DIMENSION_CONSTANT;
    
    
    if (imageWidth > imageHeight) { //Landscape image
        CGFloat widthToHeightRatio = imageWidth / imageHeight;
        CGFloat newWidth = dimConstant * widthToHeightRatio;
        if (newWidth > self.frame.size.width - 40) {
            newWidth = self.frame.size.width - 40;
            CGFloat heightToWidthRatio = imageHeight / imageWidth;
            CGFloat newHeight = newWidth * heightToWidthRatio;
            self.imageWidth.constant = newWidth;
            self.imageHeight.constant = newHeight;
//            self.bottomVerticalSpace.constant = -1 * newHeight/2;
        } else {
            self.imageWidth.constant = newWidth;
            self.imageHeight.constant = dimConstant;
//            self.bottomVerticalSpace.constant = -1 * dimConstant/2;
        }
    } else { //Portrait image
        CGFloat widthToHeightRatio = imageWidth / imageHeight;
        CGFloat newWidth = dimConstant * widthToHeightRatio;
        self.imageWidth.constant = newWidth;
        self.imageHeight.constant = dimConstant;
//        self.bottomVerticalSpace.constant = -1 * dimConstant/2;
    }
    self.bottomVerticalSpace.constant = -40;
//    }
    
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
    [self setNeedsDisplay];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.image.imageURL] placeholderImage:[PvmntStyleKit imageOfPvmntLoadingImage]];
    
}

- (void)awakeFromNib {
    [self.imageView addGestureRecognizer:self.imageTapGR];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageViewBorder.layer setCornerRadius:10.f];
//    [self.imageViewBorder.layer setBorderWidth:1.0f];
//    [self.imageViewBorder.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.imageViewBorder setClipsToBounds:YES];
    [self.imageView.layer setCornerRadius:5.f];
    [self.imageView setClipsToBounds:YES];
    
//    [self.baseView setRoundedCorners:UIRectCornerTopLeft radius:10.f];
//    [self.baseView setRoundedCorners:UIRectCornerTopRight radius:10.f];
    
}


@end
