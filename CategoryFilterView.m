//
//  CategoryFilterView.m
//  Pvmnts
//
//  Created by Phil Meyers IV on 1/9/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import "CategoryFilterView.h"
#import "CategorySliderView.h"
#import "FlyerDB.h"
#import "PvmntStyleKit.h"

@interface CategoryFilterView()
@property (strong, nonatomic) CategorySliderView *sliderView;
@end

@implementation CategoryFilterView
- (instancetype)initWithFrame:(CGRect)frame andCategorySelectionBlock:(categorySelected)block
{
    if (self = [super initWithFrame:frame]) {
        [self setupViewWithBlock:block];
        
        CGRect frame = self.frame;
        frame.size.width += 10;
        frame.origin.x -= 5;

        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 10;
    }
    
    return self;
}

- (void)setupViewWithBlock:(categorySelected)block
{
    NSMutableArray *categoryNames = [[[[FlyerDB sharedInstance] allCategoriesSortedByName] valueForKey:@"name"] mutableCopy];
    [categoryNames insertObject:@"all" atIndex:0];
    NSMutableArray *categoryViews = [[NSMutableArray alloc] initWithCapacity:categoryNames.count];
    UIColor *highlightedColor = [PvmntStyleKit pureWhite];
    UIColor *standardColor = [PvmntStyleKit pureWhite];
    CGFloat sliderHeight = self.frame.size.height;
    UIFont *font = [UIFont fontWithName:@"OpenSans" size:19];
    for (NSString *categoryName in categoryNames) {
        CGFloat width = [categoryName sizeWithAttributes:@{NSFontAttributeName:font}].width;
        
        PvmntCategorySliderLabel *label = [[PvmntCategorySliderLabel alloc] initWithFrame:CGRectMake(0, 0, width, sliderHeight)];
        [label setFont:font];
        [label setText:categoryName];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setHighlightColor:highlightedColor];
        [label setStandardColor:standardColor];
        [label setTextColor:standardColor];
        [categoryViews addObject:label];
    }
    
    self.sliderView = [[CategorySliderView alloc] initWithFrame:self.frame andCategoryViews:categoryViews sliderDirection:SliderDirectionHorizontal categorySelectionBlock:block];
    self.sliderView.backgroundColor = [PvmntStyleKit mainBlack];
    [self addSubview:self.sliderView];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
