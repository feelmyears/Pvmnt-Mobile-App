//
//  CategoryFilterView.h
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/9/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategorySliderView.h"

@interface CategoryFilterView : UIView
@property (strong, nonatomic) UIColor *selectedColor;
@property (strong, nonatomic) UIColor *unselectedColor;

- (instancetype)initWithFrame:(CGRect)frame andCategorySelectionBlock:(categorySelected)block;
@end
