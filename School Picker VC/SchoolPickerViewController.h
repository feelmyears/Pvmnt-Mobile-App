//
//  SchoolPickerViewController.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/13/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPGTextField.h"

extern NSString *const kSchoolPickerSchoolChosenNotification;

@interface SchoolPickerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MPGTextFieldDelegate>
@property (strong, nonatomic) NSString *schoolName;

@end
