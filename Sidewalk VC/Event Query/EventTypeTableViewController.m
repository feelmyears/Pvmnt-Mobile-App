//
//  EventTypeTableViewController.m
//  pmvnt
//
//  Created by Phil Meyers IV on 9/21/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import "EventTypeTableViewController.h"

NSString *const kEventTypeChanged = @"kEventTypeChanged";
NSString *const kEventTypeChangedNewEventType = @"kEventTypeChangedNewEventType";

@interface EventTypeTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *eventTypes;
@end

@implementation EventTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _eventTypes = [NSArray arrayWithObjects:
                   @"all",
                   @"arts",
                   @"clubs",
                   @"sports",
                   @"greek",
                   @"night life",
                   @"food",
                   @"academics",
                   @"misc.",
                   nil];
    
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView reloadData];


}


- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _eventTypes.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSLog(@"Row: %d, Event Type: %d", indexPath.row, (int)_eventType);
    if (indexPath.row == _eventType) {
        cell.selected = YES;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.selected = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = _eventTypes[indexPath.row];
    return cell;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventType newType;
    
    if ([_eventTypes[indexPath.row] isEqualToString:@"all"]) {
        newType = All;
    } else if ([_eventTypes[indexPath.row] isEqualToString:@"arts"]) {
        newType = Arts;
    } else if ([_eventTypes[indexPath.row] isEqualToString:@"clubs"]) {
        newType = Clubs;
    } else if ([_eventTypes[indexPath.row] isEqualToString:@"sports"]) {
        newType = Sports;
    } else if ([_eventTypes[indexPath.row] isEqualToString:@"greek"]) {
        newType = Greek;
    } else if ([_eventTypes[indexPath.row] isEqualToString:@"night life"]) {
        newType = NightLife;
    } else if ([_eventTypes[indexPath.row] isEqualToString:@"academics"]) {
        newType = Academics;
    } else if ([_eventTypes[indexPath.row] isEqualToString:@"misc."]) {
        newType = Misc;
    } else if ([_eventTypes[indexPath.row] isEqualToString:@"food"]) {
        newType = Food;
    }
    
    if (newType != _eventType) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kEventTypeChanged object:self userInfo:@{kEventTypeChangedNewEventType : [NSNumber numberWithInt:newType]}];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
