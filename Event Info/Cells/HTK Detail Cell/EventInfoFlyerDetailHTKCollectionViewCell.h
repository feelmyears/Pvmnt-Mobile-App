//
//  EventInfoFlyerDetailHTKCollectionViewCell.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/27/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "HTKDynamicResizingCollectionViewCell.h"
#import "CD_V2_Flyer.h"

typedef enum {
    EventInfoFlyerDetailHTKCollectionViewCellTypeLocation,
    EventInfoFlyerDetailHTKCollectionViewCellTypeTime,
    EventInfoFlyerDetailHTKCollectionViewCellTypeCategory
} EventInfoFlyerDetailHTKCollectionViewCellType;

#define DEFAULT_FLYER_DETAIL_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width, 50}

@interface EventInfoFlyerDetailHTKCollectionViewCell : HTKDynamicResizingCollectionViewCell
- (void)setupCellWithFlyer:(CD_V2_Flyer *)flyer forCellType:(EventInfoFlyerDetailHTKCollectionViewCellType)type;
@end
