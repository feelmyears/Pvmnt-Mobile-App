//
//  SidewalkCollectionViewFlowLayout.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/2/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import "SidewalkCollectionViewFlowLayout.h"
@interface SidewalkCollectionViewFlowLayout()
@property (nonatomic, strong) NSMutableArray *indexPathsToAnimate;
@end

@implementation SidewalkCollectionViewFlowLayout
- (instancetype)init
{
    if (self = [super init]) {
        [self setupLayout];
    }
    return self;
}

- (void)setupLayout
{
    self.indexPathsToAnimate = [NSMutableArray new];
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    if ([_indexPathsToAnimate containsObject:itemIndexPath] && itemIndexPath.row == 1) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        CGRect frame = attributes.frame;
        
        frame.origin.y = CGRectGetMaxY([self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:itemIndexPath.section]].frame) - CGRectGetHeight(frame);
        attributes.frame = frame;
        return attributes;
    }
    else return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    if ([_indexPathsToAnimate containsObject:itemIndexPath] && itemIndexPath.row == 1) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        CGRect frame = attributes.frame;
        
        frame.origin.y = CGRectGetMaxY([self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:itemIndexPath.section]].frame) - CGRectGetHeight(frame);
        attributes.frame = frame;
        return attributes;
    }
    else return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            case UICollectionUpdateActionDelete:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
            case UICollectionUpdateActionMove:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            default:
                NSLog(@"unhandled case: %@", updateItem);
                break;
        }
    }
    self.indexPathsToAnimate = indexPaths;
}

@end
