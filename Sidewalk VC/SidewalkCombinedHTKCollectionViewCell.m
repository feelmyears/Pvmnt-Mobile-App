//
//  SidewalkCombinedHTKCollectionViewCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/20/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "SidewalkCombinedHTKCollectionViewCell.h"
#import "NSDate+Utilities.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDImageCache.h>

@interface SidewalkCombinedHTKCollectionViewCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *minorLabel;
@property (strong, nonatomic) UIImageView *imageView;
@end

static CGFloat padding = 5.f;


@implementation SidewalkCombinedHTKCollectionViewCell

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
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    //    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    self.minorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.minorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    //    self.minorLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    self.minorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.minorLabel.textColor = [UIColor grayColor];
    self.minorLabel.numberOfLines = 0;
    self.minorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.minorLabel.textAlignment = NSTextAlignmentLeft;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];

    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.minorLabel];
    [self.contentView addSubview:self.imageView];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_minorLabel, _titleLabel, _imageView);
    NSDictionary *metricDict = @{@"padding" : [NSNumber numberWithFloat:padding]};
    
    //Constrain labels horizontally
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_titleLabel]-(>=padding)-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_minorLabel]-(>=padding)-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:0 metrics:metricDict views:viewDict]];
    
    //Constrain labels vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]-padding-[_titleLabel]-(0)-[_minorLabel]-(padding)-|" options:0 metrics:metricDict views:viewDict]];
    
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.minorLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.minorLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    CGSize defaultSize = DEFAULT_COMBINED_SIDEWALK_CELL_SIZE;
    self.titleLabel.preferredMaxLayoutWidth = defaultSize.width - 2 * [metricDict[@"padding"] floatValue];
    self.minorLabel.preferredMaxLayoutWidth = defaultSize.width - 2 * [metricDict[@"padding"] floatValue];
    
    
}

- (void)setupCellWithFlyer:(CD_V2_Flyer *)flyer
{
    
    self.titleLabel.text = flyer.title;
    NSMutableArray *minorLabelText = [[NSMutableArray alloc] init];
    [minorLabelText addObject:[NSString stringWithFormat:@"%@ %@", flyer.event_time.longDateString, flyer.event_time.shortTimeString]];
    if (flyer.location && [flyer.location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        [minorLabelText addObject:flyer.location];
    }
    self.minorLabel.text = [minorLabelText componentsJoinedByString:@" at "];
    
    
    [self.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:flyer.image.imageURL] andPlaceholderImage:[UIImage imageNamed:@"Concrete_Pattern"] options:0 progress:nil completed:nil];
   
    CGSize imageSize = [self sizeForImage:flyer.image];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_imageView);
    NSDictionary *metricDict = @{@"height" : [NSNumber numberWithFloat:imageSize.height],
                                 @"width" : [NSNumber numberWithFloat:imageSize.width],
                                 @"constant" : @100,
                                 };
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imageView(constant)]" options:0 metrics:metricDict views:viewDict]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imageView(width)]" options:0 metrics:metricDict views:viewDict]];
}

- (CGSize)sizeForImage:(CD_Image *)image
{
    CGFloat imageWidth = [image.width floatValue];
    CGFloat imageHeight = [image.height floatValue];
    
    CGFloat contentWidth = DEFAULT_COMBINED_SIDEWALK_CELL_SIZE.width;
    CGFloat fixedItemWidth = contentWidth;
    CGFloat heightToWidthRatio = imageHeight/imageWidth;
    CGFloat heightForItem = fixedItemWidth * heightToWidthRatio;
    
    return CGSizeMake(fixedItemWidth, heightForItem);
}

@end
