//
//  CD_Colorscheme.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/1/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CD_Image;

@interface CD_Colorscheme : NSManagedObject

@property (nonatomic, retain) id backgroundColor;
@property (nonatomic, retain) id mainTextColor;
@property (nonatomic, retain) id secondaryTextColor;
@property (nonatomic, retain) CD_Image *image;

@end
