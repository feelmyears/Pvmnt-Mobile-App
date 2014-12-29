//
//  EventInfoActionCollectionViewCell.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/27/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventInfoActionCollectionViewCell : UICollectionViewCell

- (void)setupWithTitles:(NSArray *)titles andImages:(NSArray *)images andGestureRecognizers:(NSArray *)gestureRecognizers;
@end
