//
//  CalendarListCollectionCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/1/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "CalendarListCollectionCell.h"
#import "NSDate+Utilities.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CD_Image.h"

@interface CalendarListCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *flyerImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flyerImageWidth;

@end


@implementation CalendarListCollectionCell

- (void)setFlyerForCell:(CD_V2_Flyer *)flyerForCell
{
    _flyerForCell = flyerForCell;
    self.timeLabel.text = flyerForCell.event_time.shortTimeString;
//    NSLog(@"%@", flyerForCell.event_date.shortString);
    self.eventTitleLabel.text = flyerForCell.title;
    
    [self.flyerImage sd_setImageWithURL:[NSURL URLWithString:flyerForCell.image.imageURL] placeholderImage:[PvmntStyleKit imageOfPvmntLoadingImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //Code
    }];
    
    self.flyerImageWidth.constant = self.flyerImage.frame.size.width;
    [self.flyerImage.layer setCornerRadius:self.flyerImage.frame.size.width/2];
}

- (void)awakeFromNib {
    // Initialization code
    self.flyerImageWidth.constant = self.flyerImage.frame.size.width;
    [self.flyerImage.layer setCornerRadius:self.flyerImage.frame.size.width/2];
    [self.flyerImage setClipsToBounds:YES];
}

@end
