//
//  PvmntLaunchScreenShimmerTextView.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 12/31/14.
//  Copyright (c) 2014 Pvmnt. All rights reserved.
//

#import "PvmntLaunchScreenShimmerTextView.h"
#import "PvmntStyleKit.h"

@implementation PvmntLaunchScreenShimmerTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.shimmering = YES;
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [PvmntStyleKit drawDiscoverYourCampus];
}


@end
