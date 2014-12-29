//
//  CD_V2_Category.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/13/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CD_V2_Flyer;

@interface CD_V2_Category : NSManagedObject

@property (nonatomic, retain) NSNumber * categoryId;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * urlExtension;
@property (nonatomic, retain) NSSet *flyers;

@end

@interface CD_V2_Category (CoreDataGeneratedAccessors)

- (void)addFlyersObject:(CD_V2_Flyer *)value;
- (void)removeFlyersObject:(CD_V2_Flyer *)value;
- (void)addFlyers:(NSSet *)values;
- (void)removeFlyers:(NSSet *)values;

@end
