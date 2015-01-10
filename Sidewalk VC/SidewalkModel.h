//
//  SidewalkModel.h
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/1/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CD_V2_Flyer.h"

@class SidewalkModel;
@protocol SidewalkModelDelegate <NSObject>
@required
- (void)removeSectionsInIndexSet:(NSIndexSet *)sectionsToRemove addSectionsIndexSet:(NSIndexSet *)sectionsToAdd;
@optional
- (void)removeItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths;
@end

@interface SidewalkModel : NSObject
@property (weak, nonatomic) id<SidewalkModelDelegate> delegate;
@property (readonly) NSInteger expandedSection;
@property (strong, nonatomic) NSString *filterString;
- (void)refreshDatabase;
- (void)filterWithCategoryName:(NSString *)categoryName;
- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfItemsInSection:(NSUInteger)section;
- (CD_V2_Flyer *)flyerAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)showDescriptionCellForSection:(NSIndexPath *)indexPath;
@end
