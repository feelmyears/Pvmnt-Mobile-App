//
//  SidewalkFlyerCollectionCell.h
//  pmvnt
//
//  Created by Phil Meyers IV on 8/8/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kSidewalkFlyerCollectionCellDoubleTapNotificationKey;
extern NSString *const kSidewalkFlyerCollectionCellDoubleTapNotificationCellReferenceKey;

@protocol SidewalkFlyerDelegate <NSObject>
@required
- (BOOL)shouldCellEventInformation:(UICollectionViewCell *)cell;
@end

@interface SidewalkFlyerCollectionCell : UICollectionViewCell

@property (strong, nonatomic) UIImage *flyerImage;
@property (weak, nonatomic) IBOutlet UIImageView *flyerImageView;

@property (weak, nonatomic) id<SidewalkFlyerDelegate> delegate;

@end
