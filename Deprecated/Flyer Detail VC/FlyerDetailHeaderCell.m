//
//  FlyerDetailHeaderCell.m
//  pmvnt
//
//  Created by Phil Meyers IV on 8/10/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import "FlyerDetailHeaderCell.h"
@interface FlyerDetailHeaderCell()
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@end

@implementation FlyerDetailHeaderCell
- (void)setTextForCell:(NSString *)textForCell
{
    _textForCell = textForCell;
    self.eventTitleLabel.text = textForCell;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
