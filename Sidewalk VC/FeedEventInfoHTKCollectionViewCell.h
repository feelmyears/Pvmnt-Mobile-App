//
//  FeedEventInfoHTKCollectionViewCell.h
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/2/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import "HTKDynamicResizingCollectionViewCell.h"
#import "CD_V2_Flyer.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import <MessageUI/MessageUI.h>

#define DEFAULT_FEED_EVENT_INFO_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width, 50}

@interface FeedEventInfoHTKCollectionViewCell : HTKDynamicResizingCollectionViewCell<TTTAttributedLabelDelegate>
- (void)setupCellWithFlyer:(CD_V2_Flyer *)flyer;
@end
