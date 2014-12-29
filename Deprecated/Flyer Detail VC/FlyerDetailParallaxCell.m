//
//  FlyerDetailParallaxCell.m
//  pmvnt
//
//  Created by Phil Meyers IV on 8/10/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import "FlyerDetailParallaxCell.h"
@interface FlyerDetailParallaxCell()


@end

@implementation FlyerDetailParallaxCell
- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
