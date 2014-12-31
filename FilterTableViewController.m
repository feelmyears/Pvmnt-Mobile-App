//
//  FilterTableViewController.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 12/31/14.
//  Copyright (c) 2014 Pvmnt. All rights reserved.
//

#import "FilterTableViewController.h"
#import "FlyerDB.h"
#import "CD_V2_Category.h"
#import "Colours.h"

@interface FilterTableViewController ()
@property (strong, nonatomic) FlyerDB *model;
@property (strong, nonatomic) NSArray *categories;
@end

@implementation FilterTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [FlyerDB new];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.categories = [self.model allCategoriesSortedByName];
        [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)numCells
{
    return [self.tableView numberOfRowsInSection:0];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.categories.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = ((CD_V2_Category*)self.categories[indexPath.row]).name;
    cell.backgroundColor = [self colorForCellAtIndexPath:indexPath];
    cell.textLabel.textColor = [cell.backgroundColor blackOrWhiteContrastingColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}


- (UIColor *)colorForCellAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *startingColor = [UIColor whiteColor];
    CGFloat brightnessStep = 1/((CGFloat)([self.tableView numberOfRowsInSection:0]-1));
    CGFloat darkenValue = 1.0 - brightnessStep * (CGFloat)indexPath.row;
    return [startingColor darken:darkenValue];
}
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (CGFloat)heightForTable
{
    CGFloat height = self.cellHeight * [self.tableView numberOfRowsInSection:0];
    NSLog(@"%f", height);
    return height;
}

@end
