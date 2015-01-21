//
//  FlyerCloseLookButtonView.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/14/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import "FlyerCloseLookButtonView.h"
#import "PvmntStyleKit.h"
@interface FlyerCloseLookButtonView()
@property (strong, nonatomic) NSString *text;
@end

@implementation FlyerCloseLookButtonView
- (instancetype)initWithFrame:(CGRect)frame andLabel:(NSString *)label
{
    if (self = [super initWithFrame:frame]) {
        self.text = label;
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
    
    UIFont *font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    CGSize labelSize = [self.text sizeWithAttributes:@{NSFontAttributeName : font}];
    
    CGRect labelFrame = CGRectMake((CGRectGetWidth(self.frame)-labelSize.width)/2.0, (CGRectGetHeight(self.frame)-labelSize.height)/2.0, labelSize.width, labelSize.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = self.text;
    label.textColor = [PvmntStyleKit mainBlack];
    label.font = font;
    
    [self addSubview:label];

    
}


@end
