//
//  PvmntViewController.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 12/30/14.
//  Copyright (c) 2014 Pvmnt. All rights reserved.
//

#import "PvmntViewController.h"
#import <MMDrawerController/MMDrawerBarButtonItem.h>

@interface PvmntViewController ()

@end

@implementation PvmntViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MMDrawerBarButtonItem *barButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(handleSideDrawerBarButtonTap)];
    self.navigationItem.leftBarButtonItem = barButton;
    barButton.tintColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}

- (void)handleSideDrawerBarButtonTap
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
//        code
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
