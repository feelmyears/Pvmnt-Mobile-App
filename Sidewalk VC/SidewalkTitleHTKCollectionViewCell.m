//
//  SidewalkTitleHTKCollectionViewCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 12/1/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "SidewalkTitleHTKCollectionViewCell.h"
#import "NSDate+Utilities.h"
#import "LEColorPicker.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDImageCache.h>
//#import "UIColor-MJGAdditions.h"
#import "Colours.h"
#import "ColorUtils.h"

@interface SidewalkTitleHTKCollectionViewCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *minorLabel;
@property (strong, nonatomic) UIView *hairlineView;
@end


#define USE_COLORS NO
static CGFloat hairlineSize = 0.5;
static CGFloat padding = 5.f;

@implementation SidewalkTitleHTKCollectionViewCell

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
//    self.titleLabel.font = [UIFont fontWithName:@"Lobster" size:20];
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
    
    
    self.hairlineView = [[UIView alloc] initWithFrame:CGRectZero];
    self.hairlineView.translatesAutoresizingMaskIntoConstraints = NO;
    self.hairlineView.backgroundColor = [UIColor grayColor];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.minorLabel];
    [self.contentView addSubview:self.hairlineView];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_minorLabel, _titleLabel, _hairlineView);
    NSDictionary *metricDict = @{@"padding" : [NSNumber numberWithFloat:padding],
                                 @"hairlineSize" : @(hairlineSize)};
    
    //Constrain labels horizontally
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_titleLabel]-(>=padding)-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_minorLabel]-(>=padding)-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_hairlineView]|" options:0 metrics:metricDict views:viewDict]];

    
    //Constrain labels vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[_titleLabel]-(0)-[_minorLabel]-(padding)-[_hairlineView(hairlineSize)]|" options:0 metrics:metricDict views:viewDict]];
    
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.minorLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.minorLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.hairlineView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.hairlineView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    CGSize defaultSize = DEFAULT_SIDEWALK_FLYER_TITLE_CELL_SIZE;
    self.titleLabel.preferredMaxLayoutWidth = defaultSize.width - 2 * [metricDict[@"padding"] floatValue];
    self.minorLabel.preferredMaxLayoutWidth = defaultSize.width - 2 * [metricDict[@"padding"] floatValue];


}

- (void)setupCellWithFlyer:(CD_V2_Flyer *)flyer
{

    if (USE_COLORS) {
        CD_Colorscheme *colorScheme = flyer.image.colorscheme;

        self.backgroundColor = (UIColor *)colorScheme.backgroundColor;
        static CGFloat brightnessThreshold  = 0.85f;
        
        
        UIColor *textColor;
        if (self.backgroundColor.brightness < brightnessThreshold) {
            textColor = [UIColor whiteColor];
        } else {
            textColor = [UIColor blackColor];
        }
        
        self.titleLabel.textColor = textColor;
        self.minorLabel.textColor = textColor;
    
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor blackColor];
        self.minorLabel.textColor = [UIColor blackColor];
    }
    
    self.titleLabel.text = flyer.title;
    NSMutableArray *minorLabelText = [[NSMutableArray alloc] init];
    [minorLabelText addObject:[NSString stringWithFormat:@"%@ %@", flyer.event_time.longDateString, flyer.event_time.shortTimeString]];
    if (flyer.location && [flyer.location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        [minorLabelText addObject:flyer.location];
    }
    self.minorLabel.text = [minorLabelText componentsJoinedByString:@" at "];
}


@end
