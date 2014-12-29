//
//  FlyerDetailCollectionViewController.h
//  pmvnt
//
//  Created by Phil Meyers IV on 8/10/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "v1_Flyer.h"

@interface FlyerDetailCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>
@property (strong, nonatomic) UIImage *flyerImage;
@property (strong, nonatomic) v1_Flyer *flyer;
@end
