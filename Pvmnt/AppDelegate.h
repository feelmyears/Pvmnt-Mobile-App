//
//  AppDelegate.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 10/28/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) UINavigationController *sidewalkViewController;
@property (strong, nonatomic, readonly) UINavigationController *calendarFeedViewController;
@end

