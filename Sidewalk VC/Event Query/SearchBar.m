//
//  SearchBar.m
//  pmvnt
//
//  Created by Phil Meyers IV on 8/13/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import "SearchBar.h"

NSString *const kSearchBarEventTypeButtonTappedNotification = @"kSearchBarEventTypeButtonTappedNotification";

@implementation SearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)eventTypeTapped:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSearchBarEventTypeButtonTappedNotification object:self];
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
