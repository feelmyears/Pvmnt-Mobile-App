//
//  SearchBar.h
//  pmvnt
//
//  Created by Phil Meyers IV on 8/13/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kSearchBarEventTypeButtonTappedNotification;

@interface SearchBar : UIView
@property (weak, nonatomic) IBOutlet UIButton *typesButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
