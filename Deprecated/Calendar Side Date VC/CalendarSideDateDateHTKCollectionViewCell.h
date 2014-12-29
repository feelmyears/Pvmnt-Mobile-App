//
//  CalendarSideDateDateHTKCollectionViewCell.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/2/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "HTKDynamicResizingCollectionViewCell.h"

#define DEFAULT_CALENDAR_SIDE_DATE_CELL_SIZE (CGSize){60, 60}

@interface CalendarSideDateDateHTKCollectionViewCell : HTKDynamicResizingCollectionViewCell
- (void)setupCellWithDate:(NSDate *)date;
@end
