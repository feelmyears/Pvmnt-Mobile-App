//
//  EventInfoActionsCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/6/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "EventInfoActionsCell.h"
@interface EventInfoActionsCell()
@property (weak, nonatomic) IBOutlet UIView *opaqueBackgroundView;

@end

@implementation EventInfoActionsCell

- (void)awakeFromNib {
    self.opaqueBackgroundView.layer.cornerRadius = 5.f;
    [self.opaqueBackgroundView setClipsToBounds:YES];
}

@end
