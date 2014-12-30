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
@interface AppDelegate ()
@property (strong, nonatomic) MMDrawerController *drawerController;
@property (strong, nonatomic) UIViewController *sidewalkViewController;
@property (strong, nonatomic) UIViewController *calendarFeedViewController;
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
    
    UIViewController *leftSideDrawerViewController = [[PvmntSideDrawerViewController alloc] init];
    [leftSideDrawerViewController setRestorationIdentifier:@"PvmntSideDrawerViewControllerRestorationKey"];
    UINavigationController *leftSideNavController = [[UINavigationController alloc] initWithRootViewController:leftSideDrawerViewController];
    [leftSideNavController setRestorationIdentifier:@"PvmntLeftSideNavControllerRestorationKey"];
    
    UINavigationController *centerViewController = [self sidewalkViewController];
    
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:centerViewController leftDrawerViewController:leftSideNavController];
    [self. drawerController setShowsShadow:YES];
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];

    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.drawerController setShouldStretchDrawer:NO];
    [self.drawerController setCenterHiddenInteractionMode:MMDrawerOpenCenterInteractionModeNavigationBarOnly];
    
    [self.drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideVisualStateBlock]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.drawerController setMaximumLeftDrawerWidth:self.window.frame.size.width - 100];
    
    [self.window setTintColor:[UIColor blackColor]];
    [self.window setRootViewController:self.drawerController];
    return YES;
}

- (UIViewController *)sidewalkViewController
{
    if (!_sidewalkViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _sidewalkViewController = [storyboard instantiateViewControllerWithIdentifier:@"Sidewalk VC Nav"];
    }
    return _sidewalkViewController;
}

- (UIViewController *)calendarFeedViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (!_calendarFeedViewController) {
        _calendarFeedViewController = [storyboard instantiateViewControllerWithIdentifier:@"Calendar Feed VC Nav"];
    }
    return _calendarFeedViewController;
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
