//
//  FlyerCloseLookIconButton.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/15/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import "FlyerCloseLookIconButton.h"
#import "PvmntStyleKit.h"

@interface FlyerCloseLookIconButton()
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIImage *image;

@end


@implementation FlyerCloseLookIconButton
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text image:(UIImage *)image
{
    if (self = [super initWithFrame:frame]) {
        self.text = text;
        self.image = image;
    }
    return self;
}
- (void)layoutSubviews
{
    [self setupButton];
}

- (void)setupButton
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIFont *font = [UIFont fontWithName:@"OpenSans" size:15];
    CGSize labelSize = [self.text sizeWithAttributes:@{NSFontAttributeName : font}];
    
    CGFloat imageViewDimension = 20;
    CGSize imageViewSize = CGSizeMake(imageViewDimension, imageViewDimension);
    
    CGFloat paddingBetweenImageAndText = 3;
    CGFloat sidePadding = (CGRectGetWidth(self.frame) - paddingBetweenImageAndText - imageViewSize.width - labelSize.width)/2.0;
    
    CGRect imageViewFrame = CGRectMake(sidePadding, (CGRectGetHeight(self.frame) - imageViewSize.height)/2.0, imageViewSize.width, imageViewSize.height);
    self.imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    self.imageView.image = self.image;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect labelFrame = CGRectMake(CGRectGetMaxX(imageViewFrame) + paddingBetweenImageAndText, (CGRectGetHeight(self.frame) - labelSize.height)/2.0, labelSize.width, labelSize.height);
    
    self.label = [[UILabel alloc] initWithFrame:labelFrame];
    self.label.text = self.text;
    self.label.textColor = [PvmntStyleKit mainBlack];
    self.label.font = font;
    
    [self addSubview:self.label];
    [self addSubview:self.imageView];

}



@end
