//
//  EventInforViewController.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/5/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "EventInforViewController.h"
#import "EventInfoFlyerInformationCell.h"
#import "EventInfoFlyerTitleCell.h"
#import "EventInfoFlyerImageCell.h"
#import "EventInfoActionsCell.h"
#import "EventInfoFlyerDescriptionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <HTKDynamicResizingCell/HTKDynamicResizingCollectionViewCell.h>
#import "NSDate+Utilities.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <SDWebImage/SDWebImageManager.h>

#import <ISHPermissionKit/ISHPermissionKit.h>
#import "PvmntPermissionRequestISHPermissionRequestViewController.h"

#import "EventInfoFlyerImageHTKCollectionViewCell.h"
#import "EventInfoFlyerDetailHTKCollectionViewCell.h"
#import "EventInfoFlyerTitleHTKCollectionViewCell.h"
#import "EventInfoFlyerDescriptionHTKCollectionViewCell.h"
#import "EventInfoActionCollectionViewCell.h"


#import <EventKit/EventKit.h>
@interface EventInforViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UITapGestureRecognizer *backgroundDismissTap;
@property (strong, nonatomic) NSMutableArray *detailCellFeatures;
@end

#define DEFAULT_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width - 20, 100}
static NSString *EventInfoFlyerImageHTKCollectionViewCellIdentifier         = @"EventInfoFlyerImageHTKCollectionViewCellIdentifier";
static NSString *EventInfoFlyerDetailHTKCollectionViewCellIdentifier        = @"EventInfoFlyerDetailHTKCollectionViewCellIdentifier";
static NSString *EventInfoFlyerTitleHTKCollectionViewCellIdentifier         = @"EventInfoFlyerTitleHTKCollectionViewCellIdentifier";
static NSString *EventInfoFlyerDescriptionHTKCollectionViewCellIdentifier   = @"EventInfoFlyerDescriptionHTKCollectionViewCellIdentifier";
static NSString *EventInfoActionCollectionViewCellIdentifier                = @"EventInfoActionCollectionViewCellIdentifier";

@implementation EventInforViewController

- (UITapGestureRecognizer *)backgroundDismissTap {
    if (!_backgroundDismissTap) {
        _backgroundDismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackgroundDismissTap)];
    }
    return _backgroundDismissTap;
}

- (void)handleBackgroundDismissTap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(handleBackgroundDismissTap)];
    
    self.navigationItem.rightBarButtonItem = backButton;
    self.navigationItem.title = self.flyer.title;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setMinimumInteritemSpacing:0];
    [layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.collectionView setCollectionViewLayout:layout];
    
    /*
    [self.collectionView registerNib:[UINib nibWithNibName:@"EventInfoFlyerInformationCell" bundle:nil] forCellWithReuseIdentifier:@"Information Cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"EventInfoFlyerImageCell" bundle:nil] forCellWithReuseIdentifier:@"Image Cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"EventInfoFlyerTitleCell" bundle:nil] forCellWithReuseIdentifier:@"Title Cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"EventInfoActionsCell" bundle:nil] forCellWithReuseIdentifier:@"Actions Cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"EventInfoFlyerDescriptionCell" bundle:nil] forCellWithReuseIdentifier:@"Description Cell"];
     */
    
    
    [self.collectionView registerClass:[EventInfoFlyerImageHTKCollectionViewCell class] forCellWithReuseIdentifier:EventInfoFlyerImageHTKCollectionViewCellIdentifier];
    [self.collectionView registerClass:[EventInfoFlyerDetailHTKCollectionViewCell class] forCellWithReuseIdentifier:EventInfoFlyerDetailHTKCollectionViewCellIdentifier];
    [self.collectionView registerClass:[EventInfoFlyerTitleHTKCollectionViewCell class] forCellWithReuseIdentifier:EventInfoFlyerTitleHTKCollectionViewCellIdentifier];
    [self.collectionView registerClass:[EventInfoFlyerDescriptionHTKCollectionViewCell class] forCellWithReuseIdentifier:EventInfoFlyerDescriptionHTKCollectionViewCellIdentifier];
    [self.collectionView registerClass:[EventInfoActionCollectionViewCell class] forCellWithReuseIdentifier:EventInfoActionCollectionViewCellIdentifier];

    
    self.collectionView.backgroundView = [[UIView alloc] initWithFrame:self.collectionView.frame];
    [self.collectionView.backgroundView addGestureRecognizer:self.backgroundDismissTap];
    self.collectionView.backgroundView.userInteractionEnabled = YES;
    
    
    self.detailCellFeatures = [[NSMutableArray alloc] init];
//    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
//    [backgroundView addGestureRecognizer:self.backgroundDismissTap];
//    [self.view insertSubview:backgroundView belowSubview:self.collectionView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        NSUInteger detailCount;
        if (self.flyer.location && [self.flyer.location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
            detailCount++;
            [self.detailCellFeatures addObject:[NSNumber numberWithInteger:EventInfoFlyerDetailHTKCollectionViewCellTypeLocation]];
        }
        if (self.flyer.event_time) {
            detailCount++;
            [self.detailCellFeatures addObject:[NSNumber numberWithInteger:EventInfoFlyerDetailHTKCollectionViewCellTypeTime]];
        }
        if (self.flyer.flyerCategories.count) {
            detailCount++;
            [self.detailCellFeatures addObject:[NSNumber numberWithInteger:EventInfoFlyerDetailHTKCollectionViewCellTypeCategory]];
        }
//        return detailCount;
        return self.detailCellFeatures.count;
    } else if (section == 3) {
        return 1;
    } else if (section == 4) {
        return 1;
    }else return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if (indexPath.section == 0) {
        EventInfoFlyerImageHTKCollectionViewCell *imageCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:EventInfoFlyerImageHTKCollectionViewCellIdentifier forIndexPath:indexPath];
        [imageCell setupCellWithImage:self.flyer.image];
        cell = imageCell;
    } else if (indexPath.section == 1) {
        EventInfoFlyerTitleHTKCollectionViewCell *titleCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:EventInfoFlyerTitleHTKCollectionViewCellIdentifier forIndexPath:indexPath];
        [titleCell setupCellWithTitle:self.flyer.title];
        cell = titleCell;
    } else if (indexPath.section == 2) {
        EventInfoFlyerDetailHTKCollectionViewCell *detailCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:EventInfoFlyerDetailHTKCollectionViewCellIdentifier forIndexPath:indexPath];
        [detailCell setupCellWithFlyer:self.flyer forCellType:(EventInfoFlyerDetailHTKCollectionViewCellType)[_detailCellFeatures[indexPath.row] integerValue]];
        cell = detailCell;
    } else if (indexPath.section == 3) {
//        EventInfoActionsCell *actionsCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Actions Cell" forIndexPath:indexPath];
        EventInfoActionCollectionViewCell *actionsCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:EventInfoActionCollectionViewCellIdentifier forIndexPath:indexPath];
        NSArray *cellTitles = @[@"Add to cal",
                                @"Share",
                                @"Save flyer"];
        NSArray *cellImages = @[[UIImage imageNamed:@"add_to_calendar_icon"],
                                [UIImage imageNamed:@"share_event_icon"],
                                [UIImage imageNamed:@"internal_icon"]];
        NSArray *cellGRs = @[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAddToCalendarTap)],
                             [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleShareTap)],
                             [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSaveTap)]];
        [actionsCell setupWithTitles:cellTitles andImages:cellImages andGestureRecognizers:cellGRs];
        
        cell = actionsCell;
    } else if (indexPath.section == 4) {
        EventInfoFlyerDescriptionHTKCollectionViewCell *descriptionCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:EventInfoFlyerDescriptionHTKCollectionViewCellIdentifier forIndexPath:indexPath];
        [descriptionCell setupCellWithDescription:self.flyer.desc isHTML:YES];
        cell = descriptionCell;
    }
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [EventInfoFlyerImageHTKCollectionViewCell sizeForCellWithImage:self.flyer.image];
    } else if (indexPath.section == 1) {
        __weak typeof(self) weakSelf = self;
        CGSize defaultSize = DEFAULT_FLYER_TITLE_CELL_SIZE;
        
        // Create our size
        return [EventInfoFlyerTitleHTKCollectionViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
            [((EventInfoFlyerTitleHTKCollectionViewCell *)cellToSetup) setupCellWithTitle:weakSelf.flyer.title];
            // return cell
            return cellToSetup;
        }];
    } else if (indexPath.section == 2) {
        __weak typeof(self) weakSelf = self;
        CGSize defaultSize = DEFAULT_FLYER_DETAIL_CELL_SIZE;

        // Create our size
        return [EventInfoFlyerDetailHTKCollectionViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
            [((EventInfoFlyerDetailHTKCollectionViewCell *)cellToSetup) setupCellWithFlyer:weakSelf.flyer forCellType:EventInfoFlyerDetailHTKCollectionViewCellTypeLocation];
            // return cell
            return cellToSetup;
        }];
    } else if (indexPath.section == 3) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        return CGSizeMake(screenRect.size.width, 60);
    } else if (indexPath.section == 4 && self.flyer.desc.length) {
        __weak typeof(self) weakSelf = self;
        CGSize defaultSize = DEFAULT_FLYER_DESCRIPTION_CELL_SIZE;
        
        // Create our size
        return [EventInfoFlyerDescriptionHTKCollectionViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
            [((EventInfoFlyerDescriptionHTKCollectionViewCell *)cellToSetup) setupCellWithDescription:weakSelf.flyer.desc isHTML:YES];
            // return cell
            return cellToSetup;
        }];
        //        return CGSizeMake(contentWidth, 100);
    }else return CGSizeMake(0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 1.f;
    } else if (section == 1) {
        return 1.f;
    } else if (section == 2) {
        return 1.f;
    } else if (section == 3) {
        return 0.f;
    } else if (section == 4) {
        return 0.f;
    } else return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 0.f;
    } else if (section == 1) {
        return 1.f;
    } else if (section == 2) {
        return 1.f;
    } else if (section == 3) {
        return 0.f;
    } else if (section == 4) {
        return 0.f;
    } else return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else if (section == 1) {
        return UIEdgeInsetsMake(0, 0, 1.f, 0);
    } else if (section == 2) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else if (section == 3) {
        return UIEdgeInsetsMake(10, 0, 10, 0);
    } else if (section == 4) {
        return UIEdgeInsetsMake(1.f, 0, 0, 0);
    } else return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)handleAddToCalendarTap
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
                
                NSError *error;
                BOOL success = [eventStore saveEvent:eventForFlyer span:EKSpanThisEvent commit:YES error:&error];
                if (!success) {
                    NSLog(@"Failed to save event with error: %@", error);
                    [SVProgressHUD showErrorWithStatus:@"Failed to save event, please try again"];
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"Event added"];
                }

            }
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Calendar access denied" message:@"The event cannot be added to the calendar because the app does not have permission to access your calendar. Please modify this in the settings" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
            [alertView show];
        }
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Settings"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)handleShareTap
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

- (void)handleSaveTap
{
    /*
    NSArray *permissions = @[
                             @(ISHPermissionCategoryPhotoLibrary)
                             ];
    ISHPermissionsViewController *permissionsVC = [ISHPermissionsViewController permissionsViewControllerWithCategories:permissions dataSource:self];
    permissionsVC.delegate = self;
    if (permissionsVC) {
        [self presentViewController:permissionsVC
                           animated:YES
                         completion:nil];
    } else {
        
    }
     */
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Save flyer to camera roll?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save flyer", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] containsString:@"Save"]) {
        UIImageWriteToSavedPhotosAlbum(self.flyer.image.imageforCD_Image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        [SVProgressHUD showWithStatus:@"Saving image"];
    }
}

- (void)               image: (UIImage *) image
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo;
{
    if (!error) {
        [SVProgressHUD showSuccessWithStatus:@"Saved image"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Failed to save image. Please check your privacy settings."];
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
        [self handleAddToCalendarTap];
    }];
}

//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
