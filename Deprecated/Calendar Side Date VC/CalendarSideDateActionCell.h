//
//  CalendarSideDateActionCell.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/28/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarSideDateActionCell;

@protocol CalendarSideDateActionCellProtocol <NSObject>
@required
- (void)presentDatePickerViewController;
@end

@interface CalendarSideDateActionCell : UIView
+ (CGSize)sizeForActionCellView;
@end


