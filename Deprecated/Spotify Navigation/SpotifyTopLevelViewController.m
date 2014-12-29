//
//  SpotifyTopLevelViewController.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/15/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "SpotifyTopLevelViewController.h"

@interface SpotifyTopLevelViewController ()

@end

@implementation SpotifyTopLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.title = @"PVMNT";
//    self.navigationController.navigationBar.clipsToBounds = YES;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pvmntLogoBlackText"]];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHideNavBar) name:@"HideNavBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShowNavBar) name:@"ShowNavBar" object:nil];
}


- (void)handleHideNavBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)handleShowNavBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
