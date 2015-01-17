//
//  CalendarSideDateFlyerHTKCollectionViewCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/30/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "CalendarSideDateFlyerHTKCollectionViewCell.h"
#import "NSDate+Utilities.h"
#import "Colours.h"
#import "PvmntStyleKit.h"

@interface CalendarSideDateFlyerHTKCollectionViewCell ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *minorLabel;
@end

static CGFloat cellPadding = 5.f;
static CGFloat imageViewSize = 73.f;
static BOOL circularImageView = YES;
static CGFloat nonCircularImageViewCornerRadius = 20.f;

@implementation CalendarSideDateFlyerHTKCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.imageView.layer.cornerRadius = (circularImageView) ? imageViewSize/2.0 : nonCircularImageViewCornerRadius;
    self.imageView.clipsToBounds = YES;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:15];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 3;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    self.minorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.minorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.minorLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    self.minorLabel.textColor = [UIColor grayColor];
    self.minorLabel.numberOfLines = 2;
    self.minorLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.minorLabel.textAlignment = NSTextAlignmentLeft;
    
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.minorLabel];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_imageView, _titleLabel, _minorLabel);
    NSDictionary *metricDict = @{@"padding": [NSNumber numberWithFloat:cellPadding],
                                 @"zeroPadding": @0,
                                 @"verticalBuffer": @0,
                                 @"imageViewSize": [NSNumber numberWithFloat:imageViewSize],
                                 @"zeroValue": @0,
                                 @"cellInset": @75};
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(cellInset)-[_imageView(imageViewSize)]" options:0 metrics:metricDict views:viewDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imageView]-(padding)-[_titleLabel]-(>=padding)-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imageView]-(padding)-[_minorLabel]-(>=padding)-|" options:0 metrics:metricDict views:viewDict]];
    
    //Constrain elements vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-zeroPadding-[_imageView(imageViewSize)]-(>=zeroPadding)-|" options:0 metrics:metricDict views:viewDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5.0-[_titleLabel]-(-2)-[_minorLabel]" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_minorLabel]-(>=zeroPadding)-|" options:0 metrics:metricDict views:viewDict]];
    
    
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.minorLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.minorLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    CGSize defaultSize = DEFAULT_FLYER_CELL_SIZE;
    self.titleLabel.preferredMaxLayoutWidth = defaultSize.width - 2 * [metricDict[@"padding"] floatValue] - [metricDict[@"imageViewSize"] floatValue] - [metricDict[@"cellInset"] floatValue];
    
    self.minorLabel.preferredMaxLayoutWidth = defaultSize.width - 2 * [metricDict[@"padding"] floatValue] - [metricDict[@"imageViewSize"] floatValue] - [metricDict[@"cellInset"] floatValue];
    
}

- (void)setupWithFlyer:(CD_V2_Flyer *)flyer
{
    [self.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:flyer.image.imageURL] andPlaceholderImage:[PvmntStyleKit imageOfPvmntLoadingImage] options:0 progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        <#code#>
    }];
    self.titleLabel.text = flyer.title;
//    self.minorLabel.text = ([flyer.location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) ? [NSString stringWithFormat:@"%@ | %@", [flyer.event_time shortTimeString], [flyer.location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] : [flyer.event_time shortTimeString];
    self.minorLabel.text = flyer.event_time.shortTimeString;
    self.imageView.layer.borderWidth = .5;
    self.imageView.layer.borderColor = [PvmntStyleKit gold].CGColor;
}


@end
