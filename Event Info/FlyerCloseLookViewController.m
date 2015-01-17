//
//  FlyerCloseLookViewController.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/10/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import "FlyerCloseLookViewController.h"
#import "FeedEventInfoHTKCollectionViewCell.h"
#import "EventInfoFlyerImageHTKCollectionViewCell.h"
#import "PvmntStyleKit.h"
#import <EventKit/EventKit.h>
#import <ISHPermissionKit/ISHPermissionKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSDate+Utilities.h"
#import "PvmntPermissionRequestISHPermissionRequestViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "UIActionSheet+Blocks.h"
#import "UIAlertView+Blocks.h"
#import <URBMediaFocusViewController/URBMediaFocusViewController.h>
#import "CD_V2_Flyer.h"



static NSString *EventInfoFlyerImageHTKCollectionViewCellIdentifier = @"EventInfoFlyerImageHTKCollectionViewCellIdentifier";
static NSString *FeedEventInfoHTKCollectionViewCellIdentifier       = @"FeedEventInfoHTKCollectionViewCellIdentifier";

@interface FlyerCloseLookViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) URBMediaFocusViewController *URBMediaFocusVC;
@end

@implementation FlyerCloseLookViewController
- (void)setFlyer:(CD_V2_Flyer *)flyer
{
    _flyer = flyer;
    self.title = flyer.title;
    [Flurry logEvent:kFlurryClickedOnFlyerKey withParameters:@{kFlurryClickedOnFlyerFlyerIdKey : flyer.flyerId,
                                                               kFlurryClickedOnFlyerEventNameKey : flyer.title}
               timed:YES];
}

- (URBMediaFocusViewController *)URBMediaFocusVC
{
    if (!_URBMediaFocusVC) {
        _URBMediaFocusVC = [[URBMediaFocusViewController alloc] init];
        _URBMediaFocusVC.parallaxEnabled = NO;
        _URBMediaFocusVC.shouldBlurBackground = YES;
        _URBMediaFocusVC.shouldDismissOnImageTap = YES;
    }
    return _URBMediaFocusVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100.f, 0) forBarMetrics:UIBarMetricsDefault];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [PvmntStyleKit mainBlack];
       
    [self.collectionView registerClass:[EventInfoFlyerImageHTKCollectionViewCell class] forCellWithReuseIdentifier:EventInfoFlyerImageHTKCollectionViewCellIdentifier];
    [self.collectionView registerClass:[FeedEventInfoHTKCollectionViewCell class] forCellWithReuseIdentifier:FeedEventInfoHTKCollectionViewCellIdentifier];
}
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    if (!parent) {
        [Flurry endTimedEvent:kFlurryClickedOnFlyerKey withParameters:@{kFlurryClickedOnFlyerFlyerIdKey : self.flyer.flyerId,
                                                                        kFlurryClickedOnFlyerEventNameKey : self.flyer.title}];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem.backBarButtonItem setTitle:@" "];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if (indexPath.row == 0) {
        EventInfoFlyerImageHTKCollectionViewCell *imageCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:EventInfoFlyerImageHTKCollectionViewCellIdentifier forIndexPath:indexPath];
        [imageCell setupCellWithImage:self.flyer.image];
        UITapGestureRecognizer *tapGR = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            [self.URBMediaFocusVC showImage:self.flyer.image.imageforCD_Image fromView:imageCell];
        } delay:0];
        [imageCell addGestureRecognizer:tapGR];
        
        UILongPressGestureRecognizer *longPressGR = [UILongPressGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            if (state == UIGestureRecognizerStateBegan) {
                [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@[@"Save image"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Save"]) {
                        [self saveImage];
                    }
                }];
                
            }
        } delay:0];
        [longPressGR requireGestureRecognizerToFail:tapGR];
        [imageCell addGestureRecognizer:longPressGR];
        cell = imageCell;
    } else if (indexPath.row == 1) {
        FeedEventInfoHTKCollectionViewCell *feedCell = [collectionView dequeueReusableCellWithReuseIdentifier:FeedEventInfoHTKCollectionViewCellIdentifier forIndexPath:indexPath];
        CD_V2_Flyer *flyerForCell = self.flyer;
        [feedCell setupCellWithFlyer:flyerForCell];
        feedCell.delegate = self;
        cell = feedCell;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [EventInfoFlyerImageHTKCollectionViewCell sizeForCellWithImage:self.flyer.image];
    } else if (indexPath.row == 1) {
        CGSize defaultSize = DEFAULT_FEED_EVENT_INFO_CELL_SIZE;
        CD_V2_Flyer *flyerForCell = self.flyer;
        return [FeedEventInfoHTKCollectionViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
            [((FeedEventInfoHTKCollectionViewCell *)cellToSetup) setupCellWithFlyer:flyerForCell];
            return cellToSetup;
        }];
    } else return CGSizeZero;
}

#pragma mark - FeedEventInfoHTKCollectionViewCell Delegate

- (void)handleCalendarAction
{
    NSArray *permissions = @[
                             @(ISHPermissionCategoryEvents)
                             ];
    ISHPermissionsViewController *permissionsVC = [ISHPermissionsViewController permissionsViewControllerWithCategories:permissions dataSource:self];
    permissionsVC.delegate = self;
    if (permissionsVC) {
        [self presentViewController:permissionsVC
                           animated:YES
                         completion:nil];
    } else {
        ISHPermissionRequest *eventPermissionRequest = [ISHPermissionRequest requestForCategory:ISHPermissionCategoryEvents];
        BOOL granted = ([eventPermissionRequest permissionState] == ISHPermissionStateAuthorized);
        if (granted) {
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            EKCalendar *calendar = [eventStore defaultCalendarForNewEvents];
            
            NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:self.flyer.event_time endDate:[self.flyer.event_time dateByAddingHours:1] calendars:@[calendar]];
            NSArray *events = [eventStore eventsMatchingPredicate:predicate];
            EKEvent *eventForFlyer = nil;
            
            for (EKEvent *queryResult in events) {
                if ([queryResult.title isEqualToString:self.flyer.title] && [queryResult.startDate isEqualToDate:self.flyer.event_time]) {
                    eventForFlyer = queryResult;
                }
            }
            
            if (eventForFlyer) {
                [SVProgressHUD showInfoWithStatus:@"Event already added!"];
            } else {
                eventForFlyer = [EKEvent eventWithEventStore:eventStore];
                
                eventForFlyer.title = self.flyer.title;
                eventForFlyer.startDate = self.flyer.event_time;
                eventForFlyer.endDate = [self.flyer.event_time dateByAddingHours:1];
                eventForFlyer.calendar = calendar;
                eventForFlyer.notes = self.flyer.desc;
                eventForFlyer.location = self.flyer.location;
                
                EKEventEditViewController *createEventVC = [EKEventEditViewController new];
                createEventVC.editViewDelegate = self;
                createEventVC.event = eventForFlyer;
                createEventVC.eventStore = eventStore;
                createEventVC.navigationController.navigationBar.tintColor = [PvmntStyleKit mainBlack];
                [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0) forBarMetrics:UIBarMetricsDefault];
                [self presentViewController:createEventVC animated:YES completion:NULL];
            }
            
        } else {
            [UIAlertView showWithTitle:@"Access Denied" message:@"Failed to add event. Please check your privacy settings." cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Settings"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Settings"]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
        }
    }
}


- (void)handleMoreAction
{
    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Report event" otherButtonTitles:@[@"Save image"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex != actionSheet.cancelButtonIndex)
        {
            if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Save image"]) {
                [self saveImage];
            } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Report event"]) {
                [UIAlertView showWithTitle:@"Report event?" message:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Report"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Report"]) {
                        [Flurry logEvent:kFlurryReportFlyerKey withParameters:@{kFlurryReportFlyerFlyerIdKey : self.flyer.flyerId}];
                    }
                }];
            }
        }}];
}

- (void)handleShareAction
{
    NSString *shareURL = [NSString stringWithFormat:@"https://northwestern.pvmnt.com/flyers/%@", self.flyer.flyerId];
    NSString *shareString = [NSString stringWithFormat:@"Check out this event on Pvmnt: %@", shareURL];
    UIImage *shareImage = [self.flyer.image imageforCD_Image];
    NSArray *activityItems = @[shareString, shareImage];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityViewController animated:YES completion:^{
        //        code
    }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Settings"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)saveImage
{
    UIImageWriteToSavedPhotosAlbum(self.flyer.image.imageforCD_Image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [SVProgressHUD showWithStatus:@"Saving image"];
}

- (void)               image: (UIImage *) image
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo;
{
    if (!error) {
        [SVProgressHUD showSuccessWithStatus:@"Saved image"];
    } else {
//        [SVProgressHUD showErrorWithStatus:@"Failed to save image. Please check your privacy settings."];
        [SVProgressHUD dismiss];
        [UIAlertView showWithTitle:@"Access Denied" message:@"Failed to save image. Please check your privacy settings."  cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Settings"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Settings"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }];
        NSLog(@"Failed to save image with error: %@", error);
    }
}

#pragma mark - ISHPermissions Data Source and Delegate

- (ISHPermissionRequestViewController *)permissionsViewController:(ISHPermissionsViewController *)vc requestViewControllerForCategory:(ISHPermissionCategory)category
{
    
    return [PvmntPermissionRequestISHPermissionRequestViewController new];
}

-(void)permissionsViewController:(ISHPermissionsViewController *)vc didConfigureRequest:(ISHPermissionRequest *)request
{
    NSLog(@"did configure request called");
    
}

- (void)permissionsViewControllerDidComplete:(ISHPermissionsViewController *)vc
{
    [vc dismissViewControllerAnimated:YES completion:^{
        [self handleCalendarAction];
    }];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark - EKEventEditViewController Delegate
- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    if (action == EKEventEditViewActionSaved) {
        EKEventStore *eventStore = controller.eventStore;
        EKEvent *event = controller.event;
       
        [controller dismissViewControllerAnimated:YES completion:^{
            NSError *error;
            BOOL success = [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
            if (!success) {
                NSLog(@"Failed to save event with error: %@", error);
                [SVProgressHUD showErrorWithStatus:@"Failed to save event, please try again"];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"Event added"];
            }
        }];
    } else {
        [controller dismissViewControllerAnimated:YES completion:NULL];
    }
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100.f, 0) forBarMetrics:UIBarMetricsDefault];
}

@end
