//
//  FilterTableViewController.h
//  Pvmnt
//
//  Created by Phil Meyers IV on 12/31/14.
//  Copyright (c) 2014 Pvmnt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewController : UITableViewController
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) CGFloat numCells;
- (CGFloat)heightForTable;
@end
