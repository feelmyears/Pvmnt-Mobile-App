//
//  FlyerDetailInformationCell.h
//  pmvnt
//
//  Created by Phil Meyers IV on 8/10/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlyerDetailInformationCell : UICollectionViewCell
@property (strong, nonatomic) NSString *textForCell;
- (CGFloat)heightForCell;
@end
