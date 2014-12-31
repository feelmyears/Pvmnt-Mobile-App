//
//  SidewalkViewController.h
//  pmvnt
//
//  Created by Phil Meyers IV on 8/8/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PvmntViewController.h"

#import "CHTCollectionViewWaterfallLayout.h"
#import "SidewalkFlyerCollectionCell.h"
#import "SidewalkModel.h"
#import "PulldownMenu.h"

@interface SidewalkViewController : PvmntViewController
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
CHTCollectionViewDelegateWaterfallLayout,
UISearchBarDelegate,
SidewalkModelDelegate,
PulldownMenuDelegate
>

@end
