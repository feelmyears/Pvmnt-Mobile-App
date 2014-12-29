//
//  CalendarFeedFlyerHTKCollectionViewCell.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/21/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "HTKDynamicResizingCollectionViewCell.h"
#import "CD_V2_Flyer.h"

#define DEFAULT_CALENDAR_FEED_FLYER_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width, 50}

@interface CalendarFeedFlyerHTKCollectionViewCell : HTKDynamicResizingCollectionViewCell
- (void)setupWithFlyer:(CD_V2_Flyer *)flyer;
@end
