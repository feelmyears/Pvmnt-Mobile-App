//
//  EventInfoActionCollectionViewCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/27/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "EventInfoActionCollectionViewCell.h"
#import "EventInfoActionCellView.h"

@implementation EventInfoActionCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self setupView];
    }
    return self;
}

- (void)setupWithTitles:(NSArray *)titles andImages:(NSArray *)images andGestureRecognizers:(NSArray *)gestureRecognizers
{
    CGFloat cellHeight = self.frame.size.height;
    CGSize cellSize = CGSizeMake(cellHeight, cellHeight);
    
    NSUInteger numItems = titles.count;
    CGFloat cellWidth = self.frame.size.width;
    CGFloat spacingBetweenCells = (cellWidth - numItems * cellSize.width)/((CGFloat)(1 + numItems));
    
    for (int i = 0; i < numItems; i++) {
        NSString *cellTitle = titles[i];
        UIImage *cellImage = images[i];
        UITapGestureRecognizer *cellGR = gestureRecognizers[i];
        
        CGFloat xOffset = (1 + (CGFloat)i)*spacingBetweenCells + ((CGFloat)i)*cellSize.width;
        EventInfoActionCellView *actionCell = [[EventInfoActionCellView alloc] initWithFrame:CGRectMake(xOffset, 0, cellSize.height, cellSize.width)];
        [actionCell setupActionCellWithTitle:cellTitle andImage:cellImage];
        [actionCell addGestureRecognizer:cellGR];
        [self addSubview:actionCell];
    }
}
@end
