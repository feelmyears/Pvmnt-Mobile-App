//
//  PvmntPView.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 12/30/14.
//  Copyright (c) 2014 Pvmnt. All rights reserved.
//

#import "PvmntPView.h"
#import "PvmntStyleKit.h"

@implementation PvmntPView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [PvmntStyleKit drawInsetP];
}


@end
