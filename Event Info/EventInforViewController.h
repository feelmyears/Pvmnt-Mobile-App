//
//  EventInforViewController.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/5/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "v1_Flyer.h"
#import "v2_Category.h"
#import "CD_V2_Flyer.h"
#import "CD_V2_Category.h"
#import "CD_Image.h"

#import <ISHPermissionKit/ISHPermissionsViewController.h>
@interface EventInforViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ISHPermissionsViewControllerDataSource, ISHPermissionsViewControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) CD_V2_Flyer *flyer;

@end
