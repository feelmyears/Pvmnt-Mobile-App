//
//  PvmntPermissionRequestISHPermissionRequestViewController.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/28/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <ISHPermissionKit/ISHPermissionKit.h>
//#import "ISHPermissionRequestViewController.h"

@interface PvmntPermissionRequestISHPermissionRequestViewController : ISHPermissionRequestViewController

- (void)setupWithPermissionCategory:(ISHPermissionCategory)category andText:(NSString *)text;
@end
