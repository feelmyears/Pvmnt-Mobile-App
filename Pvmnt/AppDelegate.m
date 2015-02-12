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

#import "PvmntSideDrawerViewController.h"
#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerController/MMDrawerVisualState.h>

#import <SVProgressHUD/SVProgressHUD.h>

#import "SidewalkViewController.h"
#import "CalendarFeedViewController.h"

#import "iRate.h"

#import "Flurry.h"


@interface AppDelegate ()
@property (strong, nonatomic) MMDrawerController *drawerController;
@property (strong, nonatomic) UINavigationController *sidewalkViewController;
@property (strong, nonatomic) UINavigationController *calendarFeedViewController;
@property (strong, nonatomic) UINavigationController *sideDateCalendarViewController;
@end

@implementation AppDelegate

#ifndef DEBUG
#define FLURRY_SESSION_ID @"CW77P66GWF5XJ943FVT4"
#else
#define FLURRY_SESSION_ID @"XCWB5TDPDHRD6VH9B5ZC"
#endif


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
    
    [iRate sharedInstance].daysUntilPrompt = 5;
    [iRate sharedInstance].usesUntilPrompt = 15;
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [Flurry startSession:FLURRY_SESSION_ID];
    return YES;
}

- (UINavigationController *)sidewalkViewController
{
    if (!_sidewalkViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        _sidewalkViewController = [storyboard instantiateViewControllerWithIdentifier:@"Sidewalk VC Nav"];
        _sidewalkViewController = [storyboard instantiateViewControllerWithIdentifier:@"Sidewalk Calendar VC Nav"];
        
    }
    return _sidewalkViewController;
}

- (UINavigationController *)calendarFeedViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (!_calendarFeedViewController) {
        _calendarFeedViewController = [storyboard instantiateViewControllerWithIdentifier:@"Calendar Feed VC Nav"];
    }
    return _calendarFeedViewController;
}

- (UINavigationController *)sideDateCalendarViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (!_sideDateCalendarViewController) {
        _sideDateCalendarViewController = [storyboard instantiateViewControllerWithIdentifier:@"Calendar Feed VC Nav"];
    }
    return _sideDateCalendarViewController;
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
