//
//  SidewalkFlyerImageHTKCollectionViewCell.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/20/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "HTKDynamicResizingCollectionViewCell.h"
#import "CD_Image.h"

#define DEFAULT_SIDEWALK_FLYER_IMAGE_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width, 85}


@interface SidewalkFlyerImageHTKCollectionViewCell : HTKDynamicResizingCollectionViewCell
- (void)setupCellWithImage:(CD_Image *)image;
- (void)setupCellWithFlyer:(CD_V2_Flyer *)flyer;
+ (CGSize)sizeForCellWithImage:(CD_Image *)image;
@end
