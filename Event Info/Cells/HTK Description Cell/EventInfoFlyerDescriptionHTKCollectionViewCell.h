//
//  EventInfoFlyerDescriptionHTKCollectionViewCell.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/27/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "HTKDynamicResizingCollectionViewCell.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import <MessageUI/MessageUI.h>

#define DEFAULT_FLYER_DESCRIPTION_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width, 50}

@interface EventInfoFlyerDescriptionHTKCollectionViewCell : HTKDynamicResizingCollectionViewCell<TTTAttributedLabelDelegate, MFMailComposeViewControllerDelegate>
- (void)setupCellWithDescription:(NSString *)description isHTML:(BOOL)isDescriptionHTML __attribute__((deprecated("Use setupCellWithDescription: instead")));
- (void)setupCellWithDescription:(NSString *)description;
@end
