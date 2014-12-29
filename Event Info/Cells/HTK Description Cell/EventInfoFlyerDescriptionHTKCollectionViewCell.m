//
//  EventInfoFlyerDescriptionHTKCollectionViewCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/27/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "EventInfoFlyerDescriptionHTKCollectionViewCell.h"
@interface EventInfoFlyerDescriptionHTKCollectionViewCell()
@property (strong, nonatomic) UILabel *label;
@end


@implementation EventInfoFlyerDescriptionHTKCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
//    self.label.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:15];
    self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.label.textColor = [UIColor blackColor];
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.textAlignment = NSTextAlignmentNatural;
    
    [self.contentView addSubview:self.label];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_label);
    NSDictionary *metricDict = @{@"sideBuffer": @10};
    
    //Constrain elements horizontally
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(sideBuffer)-[_label]-(>=sideBuffer)-|" options:0 metrics:metricDict views:viewDict]];
    
    //Constrain elements vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=sideBuffer)-[_label]-(>=sideBuffer)-|" options:0 metrics:metricDict views:viewDict]];
    //    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    
    [self.label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    CGSize defaultSize = DEFAULT_FLYER_DESCRIPTION_CELL_SIZE;
    self.label.preferredMaxLayoutWidth = defaultSize.width - 2 * [metricDict[@"sideBuffer"] floatValue];
}

- (void)setupCellWithDescription:(NSString *)description isHTML:(BOOL)isDescriptionHTML;
{
    if (isDescriptionHTML) {
        NSAttributedString *markdownString = [[NSAttributedString alloc] initWithData:[description dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
//        self.label.attributedText = markdownString;
        self.label.text = [[markdownString string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    } else {
        self.label.text = [description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
