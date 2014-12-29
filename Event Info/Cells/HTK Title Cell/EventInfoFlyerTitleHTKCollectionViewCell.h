//
//  EventInfoFlyerTitleHTKCollectionViewCell.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/27/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "HTKDynamicResizingCollectionViewCell.h"

#define DEFAULT_FLYER_TITLE_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width, 50}


@interface EventInfoFlyerTitleHTKCollectionViewCell : HTKDynamicResizingCollectionViewCell
- (void)setupCellWithTitle:(NSString *)title;
@end
