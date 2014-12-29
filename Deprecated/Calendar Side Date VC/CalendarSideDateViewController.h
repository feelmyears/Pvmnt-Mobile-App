//
//  CalendarSideDateViewController.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/23/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarSideDateModel.h"

@interface CalendarSideDateViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CalendarSideDateModelDelegate>

@end
