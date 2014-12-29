//
//  AppDelegate.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 10/28/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "AppDelegate.h"
#import "FlyerDB.h"
#import <MagicalRecord/MagicalRecord.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <MagicalRecord/MagicalRecord+Setup.h>
#import <BlurryModalSegue/BlurryModalSegue.h>
#import "THTinderNavigationController.h"
#import "THTinderNavigationBar.h"
#import "CalendarListViewController.h"
#import "SidewalkViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>
@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    RKLogConfigureByName("*", RKLogLevelOff);
    [FlyerDB sharedInstance];
    //    [[FlyerDB sharedInstance] configureRestKit];
    [MagicalRecord setupCoreDataStack];
    [[BlurryModalSegue appearance] setBackingImageBlurRadius:@(5)];
    [[BlurryModalSegue appearance] setBackingImageSaturationDeltaFactor:@(.2)];
    [[BlurryModalSegue appearance] setBackingImageTintColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Lobster" size:12], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    //    [[UIView appearance] setTintColor:[UIColor blackColor]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
    //    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [MagicalRecord cleanUp];
}

@end
