//
//  SchoolPickerViewController.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/13/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "SchoolPickerViewController.h"
//#import "PVMNT_CONSTANTS.h"

NSString *const kSchoolPickerSchoolChosenNotification       = @"kSchoolPickerSchoolChosenNotification";

@interface SchoolPickerViewController ()
@property (weak, nonatomic) IBOutlet UITableView *schoolListTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonItem;

@property (strong, nonatomic) NSArray *schoolList;
@property (strong, nonatomic) NSDictionary *schoolNameArraysOrganizedByFirstLetter;
@property (strong, nonatomic) NSString *selectedSchoolName;
@end

@implementation SchoolPickerViewController

static NSString *kSchoolNameCellIdentifier = @"SchoolNameCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //School List Setup
    self.schoolList = @[@"Northwestern University"];
    
    NSMutableDictionary *alphabetDictionary = [[NSMutableDictionary alloc] init];
    for (NSString *schoolName in self.schoolList) {
        NSString *firstLetter = [[schoolName substringToIndex:1] uppercaseString];
        NSMutableArray *letterList = [alphabetDictionary objectForKey:firstLetter];
        if (!letterList) {
            letterList = [NSMutableArray array];
            [alphabetDictionary setObject:letterList forKey:firstLetter];
        }
        [letterList addObject:schoolName];
    }
    
    self.schoolNameArraysOrganizedByFirstLetter = alphabetDictionary;

    self.schoolListTableView.delegate = self;
    self.schoolListTableView.dataSource = self;
//    self.schoolListTableView.sectionIndexMinimumDisplayRowCount = 1;
    
    self.barButtonItem.enabled = NO;
    
    
//    [self.schoolListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSchoolNameCellIdentifier];
}

- (NSString *)keyForSection:(NSUInteger)section
{
    NSArray *sortedKeys = [self.schoolNameArraysOrganizedByFirstLetter.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSString *keyForIndex = [sortedKeys objectAtIndex:section];
    return keyForIndex;
}

- (NSArray *)schoolListArrayForSection:(NSUInteger)section
{
    NSString *keyForIndex = [self keyForSection:section];
    NSArray *schoolListForIndex = [[self.schoolNameArraysOrganizedByFirstLetter objectForKey:keyForIndex] sortedArrayUsingSelector:@selector(compare:)];
    return schoolListForIndex;
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.schoolNameArraysOrganizedByFirstLetter.allKeys.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self schoolListArrayForSection:section].count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSchoolNameCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSchoolNameCellIdentifier];
    }
    
    NSString *schoolName = [[self schoolListArrayForSection:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = schoolName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedSchoolName = [[self schoolListArrayForSection:indexPath.section] objectAtIndex:indexPath.row];
    
//    [selectedCell setSelected:YES];
    self.barButtonItem.enabled = YES;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self keyForSection:section];
}


- (IBAction)handleSelectedSchoolButtonTap:(id)sender {
    if (self.selectedSchoolName) {
        [[NSUserDefaults standardUserDefaults] setObject:self.selectedSchoolName forKey:kNSUserDefaultsSchoolNameKey];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNSUserDefaultsHasPickedSchoolKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSchoolPickerSchoolChosenNotification object:nil];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
