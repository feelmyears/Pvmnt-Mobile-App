//
//  CalendarFeedViewController.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/21/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarSideDateModel.h"
@interface CalendarFeedViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CalendarSideDateModelDelegate>

@end
