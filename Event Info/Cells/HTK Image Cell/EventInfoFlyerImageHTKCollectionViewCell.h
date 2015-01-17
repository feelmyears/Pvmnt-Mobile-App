//
//  EventInfoFlyerImageHTKCollectionViewCell.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/26/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "HTKDynamicResizingCollectionViewCell.h"
#import "CD_Image.h"

#define DEFAULT_FLYER_IMAGE_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width, 85}

@interface EventInfoFlyerImageHTKCollectionViewCell : HTKDynamicResizingCollectionViewCell
@property (readonly) UIImageView *imageView;
- (void)setupCellWithImage:(CD_Image *)image;
+ (CGSize)sizeForCellWithImage:(CD_Image *)image;
@end
