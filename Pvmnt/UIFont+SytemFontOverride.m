//
//  UIFont+SytemFontOverride.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/20/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import "UIFont+SytemFontOverride.h"

@implementation UIFont (SytemFontOverride)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

static NSString *fontName = @"OpenSans";

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:fontName size:fontSize];
}

#pragma clang diagnostic pop

@end
