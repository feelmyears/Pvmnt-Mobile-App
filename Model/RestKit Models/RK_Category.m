//
//  RK_Category.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/13/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "RK_Category.h"

@implementation RK_Category
- (void)setCategoryName:(NSString *)categoryName
{
    _categoryName = categoryName;
    self.categoryURL = categoryName;
    
//    NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
//    self.categoryURL = [[categoryName componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
}
@end
