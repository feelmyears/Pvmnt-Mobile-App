//
//  MenuTableViewController.m
//  PVMNT
//
//  Created by Phil Meyers IV on 8/14/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import "MenuTableViewController.h"
#import "SchoolPickerViewController.h"
#import "TextViewViewController.h"
#import "UIAlertView+Blocks.h"
#import "iRate.h"
#import "Flurry.h"

@interface MenuTableViewController ()
@end

@implementation MenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissVC
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0: {
            return 1;
        }
        case 1: {
            return 4;
        }
        default:
            return 0;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *textForCell;
    switch (indexPath.section) {
        case 0:
            textForCell = [[NSUserDefaults standardUserDefaults] stringForKey:kNSUserDefaultsSchoolNameKey];
            break;
        case 1: {
            switch (indexPath.row) {
                case 0:
                    textForCell = @"Share Pvmnt";
                    break;
                case 1:
                    textForCell = @"Rate Pvmnt";
                    break;
                case 2:
                    textForCell = @"Contact Us";
                    break;
                case 3:
                    textForCell = @"Upload Your Event";
                    break;
                default:
                    break;
            }
        }
        default:
            break;
    }
    cell.textLabel.text = textForCell;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: {
            return @"My School";
        }
        case 1: {
            return @"My Pvmnt";
        }
        default:
            return @"";
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"Pick School Segue" sender:nil];
            break;
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    NSString *shareString = @"Check out www.pvmnt.com and rediscover campus!";
                    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[shareString] applicationActivities:nil];
                    [self presentViewController:activityVC animated:YES completion:nil];
                }
                    break;
                case 1:
                    [[iRate sharedInstance] promptForRating];
                    break;
                case 2: {
                    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
                    [mailVC setToRecipients:[NSArray arrayWithObject:@"pvmntapp@gmail.com"]];
                    mailVC.mailComposeDelegate = self;
                    mailVC.navigationBar.tintColor = [UIColor blackColor];
                    [self presentViewController:mailVC animated:YES completion:NULL];                }
                    break;
                case 3: {
//                    NSString *uploadText = @"Upload to pvmnt via the website, bitch";
//                    [self performSegueWithIdentifier:@"Text View Segue" sender:uploadText];
                    [Flurry logEvent:kFlurryUploadAttemptKey];
                    [UIAlertView showWithTitle:nil message:@"Visit www.pvmnt.com on your computer to upload an event today!" cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    }];
                }
                    break;
                default:
                    break;
            }
        }
        default:
            break;
    }
}

#pragma mark - MFMailVi
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultCancelled) {
        [controller dismissViewControllerAnimated:YES completion:NULL];
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"School Pick Segue"] && [segue.destinationViewController isMemberOfClass:[SchoolPickerViewController class]]) {
        SchoolPickerViewController *destinationVC = segue.destinationViewController;
        destinationVC.schoolName = [[NSUserDefaults standardUserDefaults] stringForKey:kNSUserDefaultsSchoolNameKey];
    } else if ([segue.identifier isEqualToString:@"Text View Segue"] && [segue.destinationViewController isMemberOfClass:[TextViewViewController class]]) {
        TextViewViewController *destinationVC = segue.destinationViewController;
        destinationVC.text = (NSString *)sender;
    }
}


@end
