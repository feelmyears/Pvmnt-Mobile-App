//
//  SidewalkTitleHTKCollectionViewCell.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/1/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "HTKDynamicResizingCollectionViewCell.h"
#import "CD_V2_Flyer.h"

#define DEFAULT_SIDEWALK_FLYER_TITLE_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width, 40}


@interface SidewalkTitleHTKCollectionViewCell : HTKDynamicResizingCollectionViewCell
- (void)setupCellWithFlyer:(CD_V2_Flyer *)flyer;
@end
