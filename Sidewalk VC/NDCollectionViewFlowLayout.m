//  Created by Nick Snyder on 11/13/12.
//  https://gist.github.com/nicksnyder/4075682
//  http://stackoverflow.com/questions/12927027/uicollectionview-flowlayout-not-wrapping-cells-correctly-ios
//  NDCollectionViewFlowLayout.m
#import "NDCollectionViewFlowLayout.h"

@implementation NDCollectionViewFlowLayout


/*
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *newAttributes = [NSMutableArray arrayWithCapacity:attributes.count];
    CGFloat maxX = 0;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        maxX = MAX(maxX, attribute.frame.origin.x);
    }
    
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
//        if (attribute.frame.origin.x >= maxX) {
//            [newAttributes addObject:attribute];
//        } else {
//            CGRect newFrame = attribute.frame;
//            newFrame.origin.x = maxX;
//            attribute.frame = newFrame;
//            [newAttributes addObject:attribute];
//        }
//        CGRect newFrame = attribute.frame;
//        newFrame.origin.x = maxX;
//        attribute.frame = newFrame;
//        [newAttributes addObject:attribute];
    }
    return newAttributes;
}

*/
@end
