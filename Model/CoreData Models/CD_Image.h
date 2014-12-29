//
//  CD_Image.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/1/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CD_Colorscheme.h"
#import "CD_V2_Flyer.h"
#import <SDWebImage/UIImageView+WebCache.h>

@class CD_Colorscheme, CD_V2_Flyer;

@interface CD_Image : NSManagedObject

@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * imageDownloaded;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) CD_V2_Flyer *flyer;
@property (nonatomic, retain) CD_Colorscheme *colorscheme;

- (UIImage *)imageforCD_Image;

@end
