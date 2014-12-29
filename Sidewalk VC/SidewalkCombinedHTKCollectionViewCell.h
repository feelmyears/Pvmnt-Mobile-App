//
//  SidewalkCombinedHTKCollectionViewCell.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/20/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "HTKDynamicResizingCollectionViewCell.h"
#import "CD_V2_Flyer.h"

#define DEFAULT_COMBINED_SIDEWALK_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width, 40}
@interface SidewalkCombinedHTKCollectionViewCell : HTKDynamicResizingCollectionViewCell
- (void)setupCellWithFlyer:(CD_V2_Flyer *)flyer;
@end
