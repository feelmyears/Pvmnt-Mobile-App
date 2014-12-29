//
//  SidewalkViewController.h
//  pmvnt
//
//  Created by Phil Meyers IV on 8/8/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "SidewalkFlyerCollectionCell.h"
#import "SidewalkModel.h"

@interface SidewalkViewController : UIViewController
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
CHTCollectionViewDelegateWaterfallLayout,
UISearchBarDelegate,
SidewalkModelDelegate
>

@end
