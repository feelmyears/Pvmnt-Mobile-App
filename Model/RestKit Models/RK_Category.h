//
//  RK_Category.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/13/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RK_Category : NSObject
@property (nonatomic) NSInteger categoryId;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSString *categoryURL;
@end
