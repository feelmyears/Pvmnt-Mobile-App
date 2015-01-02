//
//  PvmntCategorySliderLabel.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/1/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import "PvmntCategorySliderLabel.h"

@implementation PvmntCategorySliderLabel
- (void)updateViewWithRatio:(CGFloat)ratio
{
    if (fabsf(ratio) > 0.95) {
        self.textColor = self.highlightColor;
        self.alpha = 1;
    } else {
        self.textColor = self.standardColor;
        self.alpha = powf(fabsf((1-ratio-0.95)),3);
    }
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
