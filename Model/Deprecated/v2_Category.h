//
//  v2_Category.h
//  PVMNT
//
//  Created by Phil Meyers IV on 10/25/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface v2_Category : NSObject
@property (nonatomic) NSInteger categoryId;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSString *categoryURL;
@end
