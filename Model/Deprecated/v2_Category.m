//
//  v2_Category.m
//  PVMNT
//
//  Created by Phil Meyers IV on 10/25/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import "v2_Category.h"

@implementation v2_Category
- (void)setCategoryName:(NSString *)categoryName
{
    _categoryName = categoryName;
    
    NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    self.categoryURL = [[categoryName componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
}
@end
