//
//  PvmntCategorySliderLabel.h
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/1/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategorySliderView.h"
#import "CD_V2_Category.h"

@interface PvmntCategorySliderLabel : UILabel<PvmntCategorySliderViewItem>
@property (strong, nonatomic) UIColor *highlightColor;
@property (strong, nonatomic) UIColor *standardColor;

- (void)updateViewWithRatio:(CGFloat)ratio;
@end
