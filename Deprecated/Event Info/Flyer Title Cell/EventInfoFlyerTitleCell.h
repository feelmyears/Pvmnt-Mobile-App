//
//  EventInfoFlyerTitleCell.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/5/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventInfoFlyerTitleCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


- (NSInteger)informationLabelWidth;
@end

