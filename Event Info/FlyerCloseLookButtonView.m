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
@end


static CGFloat horizontalPadding = 4.f;
static CGFloat verticalPadding = 0;
static CGFloat borderWidth = 2.f;
@implementation FlyerCloseLookButtonView
- (instancetype)initWithLabel:(NSString *)label
{
    UIFont *font = [UIFont fontWithName:@"Lobster 1.4" size:20];
    CGSize textSize = [label sizeWithAttributes:@{NSFontAttributeName : font}];
    CGRect frame = CGRectMake(0, 0, textSize.width + 2*(horizontalPadding + borderWidth), textSize.height + 2*(verticalPadding + borderWidth));
    if (self = [super initWithFrame:frame]) {
        [self setupViewWithLabel:label andFont:font];
    }
    
    return self;
}

- (void)setupViewWithLabel:(NSString *)string andFont:(UIFont *)font
{
    CGSize textSize = [string sizeWithAttributes:@{NSFontAttributeName : font}];
    CGRect frame = CGRectMake((self.frame.size.width - textSize.width)/2, (self.frame.size.height - textSize.height)/2, textSize.width, textSize.height);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    label.text = string;
    label.textColor = [PvmntStyleKit pureWhite];
    [self addSubview:label];
    
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [PvmntStyleKit pureWhite].CGColor;
}

@end
