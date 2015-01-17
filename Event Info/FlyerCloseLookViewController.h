//
//  FlyerCloseLookViewController.h
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/10/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CD_V2_Flyer.h"
#import "FeedEventInfoHTKCollectionViewCell.h"
#import <ISHPermissionKit/ISHPermissionsViewController.h>
#import <EventKitUI/EventKitUI.h>
@interface FlyerCloseLookViewController : UIViewController
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
FeedEventInfoDelegate,
ISHPermissionsViewControllerDataSource,
ISHPermissionsViewControllerDelegate,
UIActionSheetDelegate,
EKEventEditViewDelegate>
@property (strong, nonatomic) CD_V2_Flyer *flyer;

@end
