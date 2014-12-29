//
//  PvmntPermissionRequestISHPermissionRequestViewController.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/28/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "PvmntPermissionRequestISHPermissionRequestViewController.h"

@interface PvmntPermissionRequestISHPermissionRequestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pvmntLabel;
@property (weak, nonatomic) IBOutlet UILabel *permissionsExplanationLabel;

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation PvmntPermissionRequestISHPermissionRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.okButton addTarget:self action:@selector(requestPermissionFromSender:) forControlEvents:UIControlEventTouchUpInside];
    self.okButton.layer.cornerRadius = 5.;
    self.okButton.clipsToBounds = YES;
    

    self.permissionsExplanationLabel.numberOfLines = 2;
    self.permissionsExplanationLabel.textAlignment = NSTextAlignmentCenter;
    [self setup];
}
- (void)setup
{
    NSString *permissionText;
    switch (self.permissionCategory) {
        case ISHPermissionCategoryEvents:
            permissionText = @"We need access to your calendar \nto add this event!";
            break;
        default:
            permissionText = @"";
            break;
    }
    
    if (permissionText) {
        self.permissionsExplanationLabel.text = permissionText;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
