//
//  CalendarSideDateActionCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/28/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "CalendarSideDateActionCell.h"

const CGFloat imageSize = 45;
const CGFloat padding = 10;

@interface CalendarSideDateActionCell()
@property (strong, nonatomic) UIImageView *selectDateImageView;
@property (strong, nonatomic) UIImageView *categoryFilterImageView;
@property (strong, nonatomic) UIImageView *searchImageView;
@property (weak, nonatomic) id<CalendarSideDateActionCellProtocol> delegate;
@property (nonatomic) BOOL searchMode;
@end

@implementation CalendarSideDateActionCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.searchMode = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    self.selectDateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, padding, imageSize, imageSize)];
    CGRect frame = self.frame;
    CGRect superFrame = self.superview.frame;
//    self.selectDateImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.selectDateImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.selectDateImageView.backgroundColor = [UIColor clearColor];
    self.selectDateImageView.image = [UIImage imageNamed:@"add_to_calendar_icon"];
    [self.selectDateImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelectDateImageViewTap)]];
    self.selectDateImageView.userInteractionEnabled = YES;
    [self addSubview:self.selectDateImageView];
    
    self.searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding * 2 + imageSize, padding, imageSize, imageSize)];
//    self.searchImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.searchImageView.backgroundColor = [UIColor clearColor];
    self.searchImageView.image = [UIImage imageNamed:@"search_icon"];
    [self.searchImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSearchImageViewTap)]];
    self.searchImageView.userInteractionEnabled = YES;
    [self addSubview:self.searchImageView];
    
//    
//    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_searchImageView, _selectDateImageView);
//    NSDictionary *metricDict = @{@"buffer": [NSNumber numberWithFloat:padding],
//                                 @"imageViewDimension": [NSNumber numberWithFloat:imageSize]};
//    
//    //Constraining elements horizontally
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-buffer-[_selectDateImageView(imageViewDimension)]" options:0 metrics:metricDict views:viewDict]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_searchImageView(imageViewDimension)]-buffer-|" options:0 metrics:metricDict views:viewDict]];
//    
//    
//    //Constraining elements vertically
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_selectDateImageView(imageViewDimension)]" options:0 metrics:metricDict views:viewDict]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_searchImageView(imageViewDimension)]" options:0 metrics:metricDict views:viewDict]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:_selectDateImageView attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:_searchImageView attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
}

- (void)handleSelectDateImageViewTap {
    [self.delegate presentDatePickerViewController];
    NSLog(@"Date tapped");
}

- (void)handleSearchImageViewTap {
    NSLog(@"Search tapped");
    
    [UIView animateWithDuration:.3 animations:^{
        if (!self.searchMode) {
            CGRect frame = self.frame;
            frame.size.width += 100;
            frame.origin.x = (self.superview.frame.size.width - frame.size.width)/2.0;
            self.frame = frame;
            
            CGRect selectDateFrame = self.selectDateImageView.frame;
            selectDateFrame.origin.x = frame.origin.x - selectDateFrame.size.width;
            self.selectDateImageView.frame = selectDateFrame;
            
            CGRect searchFrame = self.searchImageView.frame;
            searchFrame.origin.x = padding;
            self.selectDateImageView.frame = searchFrame;
        } else {
            CGRect frame = self.frame;
            frame.size.width -= 100;
            frame.origin.x = (self.superview.frame.size.width - frame.size.width)/2.0;
            self.frame = frame;
            
            CGRect selectDateFrame = self.selectDateImageView.frame;
            selectDateFrame.origin.x = 10;
            self.selectDateImageView.frame = selectDateFrame;
            
            CGRect searchFrame = self.searchImageView.frame;
            searchFrame.origin.x = self.frame.size.width - 10 - searchFrame.size.width;
            self.selectDateImageView.frame = searchFrame;
        }
    } completion:^(BOOL finished) {
        self.searchMode = !self.searchMode;
    }];
}

+ (CGSize)sizeForActionCellView
{
    return CGSizeMake(imageSize * 2 + padding * 3, imageSize + padding * 2);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
