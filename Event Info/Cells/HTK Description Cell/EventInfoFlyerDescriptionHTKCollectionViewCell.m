//
//  EventInfoFlyerDescriptionHTKCollectionViewCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/27/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "EventInfoFlyerDescriptionHTKCollectionViewCell.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "SVModalWebViewController.h"

@interface EventInfoFlyerDescriptionHTKCollectionViewCell()
@property (strong, nonatomic) TTTAttributedLabel *label;
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
    
    self.label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
//    self.label.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:15];
    self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.label.textColor = [UIColor blackColor];
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.textAlignment = NSTextAlignmentNatural;
    self.label.enabledTextCheckingTypes = NSTextCheckingTypeAddress | NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber;
    self.label.delegate = self;
    
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

#pragma mark - TTTAttributedLabel Delegate
//---------------------Phone Number Tap-----------------------
- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithPhoneNumber:(NSString *)phoneNumber atPoint:(CGPoint)point
{
    NSLog(@"Long phone number press");
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    NSString *callURL = [@"tel://" stringByAppendingString:phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callURL]];
}

//---------------------Address Tap-----------------------
- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithAddress:(NSDictionary *)addressComponents atPoint:(CGPoint)point
{
    NSLog(@"Long address press");
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
    NSLog(@"Address select");
}

//---------------------Link Tap-----------------------
- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithURL:(NSURL *)url atPoint:(CGPoint)point
{
    NSLog(@"Long url press");
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"URL select");
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:[url absoluteString]];
    [self.window.rootViewController presentViewController:webViewController animated:YES completion:NULL];
}

@end
