//
//  EmptyStateView.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/2/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import "EmptyStateView.h"
#import "PvmntStyleKit.h"

@implementation EmptyStateView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [PvmntStyleKit drawEmptyState];
}


@end
