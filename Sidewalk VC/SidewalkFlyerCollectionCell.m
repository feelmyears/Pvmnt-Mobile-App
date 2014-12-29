//
//  SidewalkFlyerCollectionCell.m
//  pmvnt
//
//  Created by Phil Meyers IV on 8/8/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import "SidewalkFlyerCollectionCell.h"

NSString *const kSidewalkFlyerCollectionCellDoubleTapNotificationKey                    = @"SidewalkFlyerCollectionCellDoubleTapNotification";
NSString *const kSidewalkFlyerCollectionCellDoubleTapNotificationCellReferenceKey       = @"SidewalkFlyerCollectionCellDoubleTapNotificationCellReference";

@interface SidewalkFlyerCollectionCell()
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) UISwipeGestureRecognizer *rightSwipeRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *leftSwipeRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *singleTapGestureRecognizer;
@end

@implementation SidewalkFlyerCollectionCell
- (UISwipeGestureRecognizer *)rightSwipeRecognizer
{
    if (!_rightSwipeRecognizer) {
        _rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureRecgonizer:)];
        [_rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    }
    return _rightSwipeRecognizer;
}

- (UISwipeGestureRecognizer *)leftSwipeRecognizer
{
    if (!_leftSwipeRecognizer) {
        _leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureRecgonizer:)];
        [_leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    }
    return _leftSwipeRecognizer;
}

- (void)handleSwipeGestureRecgonizer:(UIGestureRecognizer *)gestureRecognizer
{
    UISwipeGestureRecognizer *swipeGR = (UISwipeGestureRecognizer *)gestureRecognizer;
    UIViewAnimationOptions options = UIViewAnimationOptionShowHideTransitionViews;
    if (swipeGR.direction == UISwipeGestureRecognizerDirectionLeft) {
        options = options | UIViewAnimationOptionTransitionFlipFromRight;
    } else {
        options = options | UIViewAnimationOptionTransitionFlipFromLeft;
    }
    
    [UIView transitionFromView:(self.flyerImageView.hidden) ? self.backgroundView : self.flyerImageView
                        toView:(self.flyerImageView.hidden) ?  self.flyerImageView : self.backgroundView                      duration:0.5f
                       options:UIViewAnimationOptionShowHideTransitionViews | options
                    completion:nil];
}

- (UITapGestureRecognizer *)doubleTapGestureRecognizer
{
    if (!_doubleTapGestureRecognizer) {
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGestureRecognizer:)];
        [_doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    }
    return _doubleTapGestureRecognizer;
}

- (void)handleDoubleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecongizer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSidewalkFlyerCollectionCellDoubleTapNotificationKey object:self userInfo:@{kSidewalkFlyerCollectionCellDoubleTapNotificationCellReferenceKey : self}];
}

- (UITapGestureRecognizer *)singleTapGestureRecognizer
{
    if (!_singleTapGestureRecognizer) {
        _singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGestureRecognizer:)];
        [_singleTapGestureRecognizer setNumberOfTapsRequired:1];
    }
    return _singleTapGestureRecognizer;
}

- (void)handleSingleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecongizer
{
    if ([self.delegate shouldCellEventInformation:self]) {
        [UIView transitionFromView:(self.flyerImageView.hidden) ? self.backgroundView : self.flyerImageView
                            toView:(self.flyerImageView.hidden) ? self.flyerImageView : self.backgroundView                      duration:0.5f
                           options:UIViewAnimationOptionShowHideTransitionViews | UIViewAnimationOptionTransitionFlipFromRight
                        completion:nil];
    }
    
    
}

- (void)setFlyerImage:(UIImage *)flyerImage
{
    _flyerImage = flyerImage;
    self.flyerImageView.image = flyerImage;
    self.flyerImageView.contentMode = UIViewContentModeScaleToFill;
    [self setNeedsLayout];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        [self addGestureRecognizer:self.rightSwipeRecognizer];
//        [self addGestureRecognizer:self.leftSwipeRecognizer];
//        [self addGestureRecognizer:self.doubleTapGestureRecognizer];
//        [self addGestureRecognizer:self.singleTapGestureRecognizer];
//        [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
        //self.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    return self;
}


- (void)prepareForReuse
{
    
}


@end
