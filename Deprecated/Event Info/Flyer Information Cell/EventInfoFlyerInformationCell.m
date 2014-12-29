//
//  EventInfoFlyerInformationCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/5/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "EventInfoFlyerInformationCell.h"

@implementation EventInfoFlyerInformationCell


- (NSInteger)informationLabelWidth
{
    return 60;
}

- (void)awakeFromNib {
    self.informationLabel.preferredMaxLayoutWidth = self.frame.size.width - self.iconImageView.frame.size.width - 10*3;
}

@end
