//
//  EventInfoFlyerImageCell.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/5/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CD_Image.h"
#import <HTKDynamicResizingCell/HTKDynamicResizingCollectionViewCell.h>

@interface EventInfoFlyerImageCell : HTKDynamicResizingCollectionViewCell
@property (strong, nonatomic) CD_Image *image;

@end
