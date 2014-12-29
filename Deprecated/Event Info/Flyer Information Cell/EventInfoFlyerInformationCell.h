//
//  EventInfoFlyerInformationCell.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/5/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTKDynamicResizingCell/HTKDynamicResizingCollectionViewCell.h>

@interface EventInfoFlyerInformationCell : HTKDynamicResizingCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;


- (NSInteger)informationLabelWidth;

@end
