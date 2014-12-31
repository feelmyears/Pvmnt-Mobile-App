//
//  PvmntSideDrawerViewController.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 12/30/14.
//  Copyright (c) 2014 Pvmnt. All rights reserved.
//

#import "PvmntSideDrawerViewController.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "AppDelegate.h"
#import "PvmntPView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "SchoolPickerViewController.h"

@interface PvmntSideDrawerViewController ()
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation PvmntSideDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(OSVersionIsAtLeastiOS7()){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    else {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	
	/*
    UIColor * tableViewBackgroundColor;

    if(OSVersionIsAtLeastiOS7()){
        tableViewBackgroundColor = [UIColor colorWithRed:110.0/255.0
                                                   green:113.0/255.0
                                                    blue:115.0/255.0
                                                   alpha:1.0];
    }
    else {
        tableViewBackgroundColor = [UIColor colorWithRed:77.0/255.0
                                                   green:79.0/255.0
                                                    blue:80.0/255.0
                                                   alpha:1.0];
    }
	 */
	[self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view setBackgroundColor:[UIColor colorWithRed:66.0/255.0
                                                  green:69.0/255.0
                                                   blue:71.0/255.0
                                                  alpha:1.0]];
    
	UIColor * barColor = [UIColor whiteColor];
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
        [self.navigationController.navigationBar setBarTintColor:barColor];
    }
    else {
        [self.navigationController.navigationBar setTintColor:barColor];
    }
	
	self.navigationController.navigationBar.translucent = NO;
    
    
    NSDictionary *navBarTitleDict;
    UIColor * titleColor = [UIColor colorWithRed:55.0/255.0
                                           green:70.0/255.0
                                            blue:77.0/255.0
                                           alpha:1.0];
    navBarTitleDict = @{NSForegroundColorAttributeName:titleColor};
    [self.navigationController.navigationBar setTitleTextAttributes:navBarTitleDict];
	
	CGSize logoSize = CGSizeMake(89.95, 113.5);
	PvmntPView *logo = [[PvmntPView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.tableView.bounds)-logoSize.width/2.0,
																	-logoSize.height - logoSize.height/4.0,
																	logoSize.width,
																	logoSize.height)];
	[logo setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
	[self.tableView addSubview:logo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch (section) {
		case 0:
			return 2;	//Sidewalk and Calendar
		case 1:
			return 1;	//Search
		case 2:
			return 1;	//School Pvmnt
		case 3:
			return 4;
		default:
			return 0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
	
	switch (indexPath.section) {
		case 0: {
			if (indexPath.row == 0) {
				cell.textLabel.text = @"Sidewalk";
			} else {
				cell.textLabel.text = @"Calendar";
			}
			break;
		}
		case 1: {
			cell.textLabel.text = @"Search";
			break;
		}
		case 2: {
			cell.textLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:kNSUserDefaultsSchoolNameKey];
			break;
		}
		case 3: {
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = @"About Pvmnt";
					break;
				case 1:
					cell.textLabel.text = @"Share Pvmnt";
					break;
				case 2:
					cell.textLabel.text = @"Rate Pvmnt";
					break;
				case 3:
					cell.textLabel.text = @"Contact Us";
					break;
				default:
					break;
			}
		}
		default:
			break;
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	
	switch (indexPath.section) {
		case 0: {
			AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
			UINavigationController *newVC;
			
			if (indexPath.row == 0) {
				newVC = (UINavigationController *)[appDelegate sidewalkViewController];
			} else {
				newVC = (UINavigationController *)[appDelegate calendarFeedViewController];
			}
			
			if ([newVC.topViewController isMemberOfClass:[[(UINavigationController *)self.mm_drawerController.centerViewController topViewController] class]]) {
				[self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
					//				code
				}];
			} else {
				[self.mm_drawerController setCenterViewController:newVC withFullCloseAnimation:YES completion:^(BOOL finished) {
					//        code
				}];
			}
			break;
		}
		case 1: {
			[SVProgressHUD showErrorWithStatus:@"Feature not yet implemented!"];
			break;
		}
		case 2: {
			UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
			UINavigationController *newVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"Schoolpicker VC Nav"];
			[self presentViewController:newVC animated:YES completion:^{
//				code
			}];
			break;
		}
		case 3: {
			[SVProgressHUD showErrorWithStatus:@"Feature not yet implemented!"];
			break;
		}
		default:
			break;
	}

	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return nil;	//Sidewalk and Calendar
		case 1:
			return nil;	//Search
		case 2:
			return @"My School";	//School Pvmnt
		case 3:
			return @"Other";
		default:
			return 0;
			break;
	}
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	static NSString *header = @"customHeader";
	
	UITableViewHeaderFooterView *vHeader;
	
	vHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
	
	if (!vHeader) {
		vHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:header];
		vHeader.textLabel.backgroundColor = [UIColor whiteColor];
	}
	
	vHeader.textLabel.text = [self tableView:tableView titleForHeaderInSection:section];
	
	return vHeader;
}
 */
/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 return 44.0f;
 } 
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
