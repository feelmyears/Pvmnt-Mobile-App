//
//  CalendarSideDateFlyerHTKCollectionViewCell.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/30/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "HTKDynamicResizingCollectionViewCell.h"
#import "CD_V2_Flyer.h"

#define DEFAULT_FLYER_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width - 70, 50}

@interface CalendarSideDateFlyerHTKCollectionViewCell : HTKDynamicResizingCollectionViewCell

- (void)setupWithFlyer:(CD_V2_Flyer *)flyer;
@end