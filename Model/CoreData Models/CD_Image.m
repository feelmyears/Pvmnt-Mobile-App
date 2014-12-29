//
//  CD_Image.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/1/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "CD_Image.h"
#import <SDWebImage/SDWebImageManager.h>
#import "LEColorPicker.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "FlyerDB.h"

@implementation CD_Image

@dynamic height;
@dynamic imageDownloaded;
@dynamic imageURL;
@dynamic width;
@dynamic flyer;
@dynamic colorscheme;

- (UIImage *)imageforCD_Image
{
    SDImageCache *imageCache = [[SDWebImageManager sharedManager] imageCache];
    UIImage *flyerImage = [imageCache imageFromDiskCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:self.flyer.image.imageURL]]];
    return flyerImage;
}

- (void)generateColorSchemeFromImage:(UIImage *)image
{
    LEColorPicker *colorPicker = [[LEColorPicker alloc] init];
    LEColorScheme *colorScheme = [colorPicker colorSchemeFromImage:image];
    
    CD_Colorscheme *cd_colorscheme = [CD_Colorscheme MR_createEntity];
    cd_colorscheme.backgroundColor = colorScheme.backgroundColor;
    cd_colorscheme.mainTextColor = colorScheme.primaryTextColor;
    cd_colorscheme.secondaryTextColor = colorScheme.secondaryTextColor;
    
    self.colorscheme = cd_colorscheme;
    [[NSNotificationCenter defaultCenter] postNotificationName:kCD_V2_FlyerImageDownloadedNotification object:self.flyer];
}

@end
