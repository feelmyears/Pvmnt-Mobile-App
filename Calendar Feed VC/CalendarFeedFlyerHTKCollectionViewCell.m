//
//  CalendarFeedFlyerHTKCollectionViewCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/21/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "CalendarFeedFlyerHTKCollectionViewCell.h"
#import "NSDate+Utilities.h"

@interface CalendarFeedFlyerHTKCollectionViewCell()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *minorLabel;
@end

static CGFloat cellPadding = 7.5f;
static CGFloat imageViewSize = 73.f;
static BOOL circularImageView = YES;
static CGFloat nonCircularImageViewCornerRadius = 20.f;

@implementation CalendarFeedFlyerHTKCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.imageView.layer.cornerRadius = (circularImageView) ? imageViewSize/2.0 : nonCircularImageViewCornerRadius;
    self.imageView.clipsToBounds = YES;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    self.minorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.minorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.minorLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    self.minorLabel.textColor = [UIColor grayColor];
    self.minorLabel.numberOfLines = 0;
    self.minorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.minorLabel.textAlignment = NSTextAlignmentLeft;
    
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.minorLabel];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_imageView, _titleLabel, _minorLabel);
    NSDictionary *metricDict = @{@"padding": [NSNumber numberWithFloat:cellPadding],
                                 @"zeroPadding": @0,
                                 @"verticalBuffer": @0,
                                 @"imageViewSize": [NSNumber numberWithFloat:imageViewSize],
                                 @"zeroValue": @0};
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[_imageView(imageViewSize)]" options:0 metrics:metricDict views:viewDict]];
    
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
    
    CGSize defaultSize = DEFAULT_CALENDAR_FEED_FLYER_CELL_SIZE;
    self.titleLabel.preferredMaxLayoutWidth = defaultSize.width - 2 * [metricDict[@"padding"] floatValue] - [metricDict[@"imageViewSize"] floatValue];
    
    self.minorLabel.preferredMaxLayoutWidth = defaultSize.width - 2 * [metricDict[@"padding"] floatValue] - [metricDict[@"imageViewSize"] floatValue];
    
}

- (void)setupWithFlyer:(CD_V2_Flyer *)flyer
{
    [self.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:flyer.image.imageURL] andPlaceholderImage:[PvmntStyleKit imageOfPvmntLoadingImage] options:0 progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //        <#code#>
    }];
    self.titleLabel.text = flyer.title;
    self.minorLabel.text = ([flyer.location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) ? [NSString stringWithFormat:@"%@ at %@", [flyer.event_time shortTimeString], [flyer.location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] : [flyer.event_time shortTimeString];
    
}


@end
