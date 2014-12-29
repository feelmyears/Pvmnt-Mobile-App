//
//  EventTypeTableViewController.h
//  pmvnt
//
//  Created by Phil Meyers IV on 9/21/14.
//  Copyright (c) 2014 b220. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SidewalkViewController.h"

typedef enum EventType: NSUInteger {
    All,
    Arts,
    Clubs,
    Sports,
    Greek,
    NightLife,
    Food,
    Academics,
    Misc
} EventType;

extern NSString *const kEventTypeChanged;
extern NSString *const kEventTypeChangedNewEventType;
@interface EventTypeTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) EventType eventType;
@end
