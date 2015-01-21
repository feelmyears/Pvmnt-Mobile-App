//
//  FeedEventInfoHTKCollectionViewCell.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/2/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//
#import "FeedEventInfoHTKCollectionViewCell.h"
#import "PvmntStyleKit.h"
#import "NSDate+Utilities.h"
#import "SVModalWebViewController.h"
#import "UIActionSheet+Blocks.h"
#import "UIAlertView+Blocks.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <FormatterKit/TTTAddressFormatter.h>
#import <MapKit/MapKit.h>
#import "FlyerCloseLookButtonView.h"
#import "FlyerCloseLookIconButton.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import <ISHPermissionKit/ISHPermissionKit.h>


@interface FeedEventInfoHTKCollectionViewCell()
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) TTTAttributedLabel *descriptionLabel;
@property (strong, nonatomic) UIView *hairline;
@property (strong, nonatomic) FlyerCloseLookButtonView *addToCalButton;
@property (strong, nonatomic) FlyerCloseLookButtonView *shareEventButton;
@property (strong, nonatomic) FlyerCloseLookButtonView *moreButton;
@end

static CGFloat padding = 7.5;

@implementation FeedEventInfoHTKCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = [PvmntStyleKit mainBlack];
    UIColor *textColor = [PvmntStyleKit pureWhite];
    
    self.hairline = [[UIView alloc] initWithFrame:CGRectZero];
    self.hairline.translatesAutoresizingMaskIntoConstraints = NO;
    self.hairline.backgroundColor = textColor;
    self.hairline.alpha = .75;
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.timeLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    self.timeLabel.textColor = textColor;
    self.timeLabel.numberOfLines = 0;
    self.timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.locationLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    self.locationLabel.textColor = textColor;
    self.locationLabel.numberOfLines = 0;
    self.locationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.locationLabel.textAlignment = NSTextAlignmentLeft;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18];
    self.titleLabel.textColor = textColor;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    self.descriptionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.descriptionLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
    self.descriptionLabel.textColor = textColor;
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    
    NSMutableDictionary *linkAttributes = [self.descriptionLabel.linkAttributes mutableCopy];
    [linkAttributes setObject:@(NSUnderlineStyleNone) forKey:NSUnderlineStyleAttributeName];
    [linkAttributes setObject:[PvmntStyleKit gold] forKey:(NSString *)kCTForegroundColorAttributeName];
    self.descriptionLabel.linkAttributes = linkAttributes;
    
    NSMutableDictionary *activeLinkAttributes = [self.descriptionLabel.activeLinkAttributes mutableCopy];
    [activeLinkAttributes setObject:@(NSUnderlineStyleNone) forKey:NSUnderlineStyleAttributeName];
    [activeLinkAttributes setObject:[PvmntStyleKit pureWhite] forKey:(NSString *)kCTForegroundColorAttributeName];
    self.descriptionLabel.activeLinkAttributes = activeLinkAttributes;
    
    self.descriptionLabel.enabledTextCheckingTypes = NSTextCheckingTypeAddress | NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber;
    self.descriptionLabel.delegate = self;
    
    CGFloat buttonSpacing = 0.5;
    CGSize flyerCloseLookButtonSize = CGSizeMake((DEFAULT_FEED_EVENT_INFO_CELL_SIZE.width - 3*buttonSpacing)/3.0, 40);
    NSUInteger i = 0;
//    self.addToCalButton = [[FlyerCloseLookIconButton alloc] initWithFrame:CGRectMake((i++)*(flyerCloseLookButtonSize.width + buttonSpacing), 0, flyerCloseLookButtonSize.width, flyerCloseLookButtonSize.height) text:@"Save Event" image:[UIImage imageNamed:@"AddToCalIcon"]];
    self.addToCalButton = [[FlyerCloseLookButtonView alloc] initWithFrame:CGRectMake((i++)*(flyerCloseLookButtonSize.width + buttonSpacing), 0, flyerCloseLookButtonSize.width, flyerCloseLookButtonSize.height) andLabel:@"Save Event"];
    [self.addToCalButton addGestureRecognizer:[UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [self.delegate handleCalendarAction];
    }]];
    
//    self.shareEventButton = [[FlyerCloseLookIconButton alloc] initWithFrame:CGRectMake((i++)*(flyerCloseLookButtonSize.width+buttonSpacing), 0, flyerCloseLookButtonSize.width, flyerCloseLookButtonSize.height) text:@"Share" image:[UIImage imageNamed:@"ShareIcon"]];
    self.shareEventButton = [[FlyerCloseLookButtonView alloc] initWithFrame:CGRectMake((i++)*(flyerCloseLookButtonSize.width+buttonSpacing), 0, flyerCloseLookButtonSize.width, flyerCloseLookButtonSize.height) andLabel:@"Share"];
    [self.shareEventButton addGestureRecognizer:[UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [self.delegate handleShareAction];
    }]];
    
//    self.moreButton = [[FlyerCloseLookIconButton alloc] initWithFrame:CGRectMake((i++)*(flyerCloseLookButtonSize.width +buttonSpacing), 0, flyerCloseLookButtonSize.width, flyerCloseLookButtonSize.height) text:@"More" image:[UIImage imageNamed:@"MoreIcon"]];
    self.moreButton = [[FlyerCloseLookButtonView alloc] initWithFrame:CGRectMake((i++)*(flyerCloseLookButtonSize.width +buttonSpacing), 0, flyerCloseLookButtonSize.width, flyerCloseLookButtonSize.height) andLabel:@"More"];
    [self.moreButton addGestureRecognizer:[UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [self.delegate handleMoreAction];
    }]];
    
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.locationLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descriptionLabel];
    [self.contentView addSubview:self.hairline];
    [self.contentView addSubview:self.addToCalButton];
    [self.contentView addSubview:self.shareEventButton];
    [self.contentView addSubview:self.moreButton];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_timeLabel, _locationLabel, _titleLabel, _descriptionLabel, _hairline, _addToCalButton, _shareEventButton, _moreButton);
    NSDictionary *metricDict = @{@"padding" : @(padding),
                                 @"buttonHeight" : @(flyerCloseLookButtonSize.height + 5),
                                 @"buttonWidth" : @(flyerCloseLookButtonSize.width)};
    
    //Horizontal Constraints
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[_titleLabel]-(>=padding)-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[_locationLabel]-(>=padding)-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[_timeLabel]-(>=padding)-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[_descriptionLabel]-(>=padding)-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[_hairline]-(padding)-|" options:0 metrics:metricDict views:viewDict]];

    
    //Vertical Constraints
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(buttonHeight)-[_titleLabel]-(0)-[_timeLabel]-(0)-[_locationLabel]-(padding)-[_hairline(0.5)]-(padding)-[_descriptionLabel]-(padding)-|" options:0 metrics:metricDict views:viewDict]];
    
    
    
    for (UILabel *label in @[self.descriptionLabel, self.titleLabel, self.timeLabel, self.locationLabel]) {
        [label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        CGSize defaultSize = DEFAULT_FEED_EVENT_INFO_CELL_SIZE;
        label.preferredMaxLayoutWidth = defaultSize.width - 2 * [metricDict[@"padding"] floatValue];
    }
    
}

- (void)setupCellWithFlyer:(CD_V2_Flyer *)flyer
{
    
    self.titleLabel.text = flyer.title;
    self.timeLabel.text = [NSString stringWithFormat:@"Date: %@, %@", flyer.event_time.mediumDateString, flyer.event_time.shortTimeString];
    NSMutableAttributedString *mutableTimeLabelText = [self.timeLabel.attributedText mutableCopy];
    NSRange timeLabelRange = NSMakeRange(0, 1);
    CGFloat timeLabelFontSize = ((UIFont *)[mutableTimeLabelText attribute:NSFontAttributeName atIndex:0 effectiveRange:&timeLabelRange]).pointSize;
    [mutableTimeLabelText setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-SemiBold" size:timeLabelFontSize]} range:NSMakeRange(0, @"Time :".length)];
    self.timeLabel.attributedText = mutableTimeLabelText;
    
    
    if ([flyer.location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        self.locationLabel.text = [NSString stringWithFormat:@"Location: %@", flyer.location];
    } else {
        self.locationLabel.text = @"Location: TBA";
    }
    NSMutableAttributedString *mutableLocationLabelText = [self.locationLabel.attributedText mutableCopy];
    NSRange locationLabelRange = NSMakeRange(0, 1);
    CGFloat locationLabelFontSize = ((UIFont *)[mutableLocationLabelText attribute:NSFontAttributeName atIndex:0 effectiveRange:&locationLabelRange]).pointSize;
    [mutableLocationLabelText setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-SemiBold" size:locationLabelFontSize]} range:NSMakeRange(0, @"Location :".length)];
    self.locationLabel.attributedText = mutableLocationLabelText;
    
    self.descriptionLabel.text = flyer.desc;
}


#pragma mark - TTTAttributedLabel Delegate

//---------------------Phone Number Tap-----------------------
- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithPhoneNumber:(NSString *)phoneNumber atPoint:(CGPoint)point
{
    [UIActionSheet showFromTabBar:[self topMostController].tabBarController.tabBar withTitle:@"Copy Phone Number?" cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@[@"Copy"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            [[UIPasteboard generalPasteboard] setString:phoneNumber];
            [SVProgressHUD showSuccessWithStatus:@"Phone Number Copied"];
        }
    }];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    [UIAlertView showWithTitle:[NSString stringWithFormat:@"Call %@?", phoneNumber] message:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Call"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            NSString *callURL = [@"tel://" stringByAppendingString:phoneNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callURL]];
        }
    }];
}

//---------------------Address Tap-----------------------
- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithAddress:(NSDictionary *)addressComponents atPoint:(CGPoint)point
{
    [UIActionSheet showFromTabBar:[self topMostController].tabBarController.tabBar withTitle:@"Copy Address?" cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@[@"Copy"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            TTTAddressFormatter *addressFormatter = [[TTTAddressFormatter alloc] init];
            NSString *addressString = [addressFormatter stringFromAddressWithStreet:addressComponents[NSTextCheckingStreetKey]
                                                                           locality:addressComponents[NSTextCheckingCityKey]
                                                                             region:addressComponents[NSTextCheckingStateKey]
                                                                         postalCode:addressComponents[NSTextCheckingZIPKey]
                                                                            country:addressComponents[NSTextCheckingCountryKey]];
            [[UIPasteboard generalPasteboard] setString:addressString];
            [SVProgressHUD showSuccessWithStatus:@"URL Copied"];
        }
    }];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
    [UIAlertView showWithTitle:@"Open in Maps?" message:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Open"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            Class mapItemClass = [MKMapItem class];
            if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
            {
                CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                [geocoder geocodeAddressDictionary:addressComponents
                                 completionHandler:^(NSArray *placemarks, NSError *error) {
                                     
                                     // Convert the CLPlacemark to an MKPlacemark
                                     // Note: There's no error checking for a failed geocode
                                     CLPlacemark *geocodedPlacemark = [placemarks objectAtIndex:0];
                                     MKPlacemark *placemark = [[MKPlacemark alloc]
                                                               initWithCoordinate:geocodedPlacemark.location.coordinate
                                                               addressDictionary:geocodedPlacemark.addressDictionary];
                                     
                                     // Create a map item for the geocoded address to pass to Maps app
                                     MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                                     [mapItem setName:geocodedPlacemark.name];
                                     
                                     // Set the directions mode to "Driving"
                                     // Can use MKLaunchOptionsDirectionsModeWalking instead
                                     NSDictionary *launchOptions = @{};
                                     [mapItem openInMapsWithLaunchOptions:launchOptions];
                                 }];
            }
        }
    }];
}

//---------------------Link Tap-----------------------
-(void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithURL:(NSURL *)url atPoint:(CGPoint)point
{
    NSObject *shareObject;
    
    NSString *mailURLScheme = @"mailto";
    if ([[url scheme] isEqualToString:mailURLScheme]) {
        NSString *shareString = [[url absoluteString] stringByReplacingOccurrencesOfString:[url scheme] withString:@""];
        shareString = [shareString stringByReplacingOccurrencesOfString:@":" withString:@""];
        shareObject = shareString;
    } else {
        shareObject = url;
    }
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[shareObject] applicationActivities:nil];
    NSArray *excludedActivityTypes;
    
    if ([shareObject isMemberOfClass:[NSString class]]) {
        excludedActivityTypes = @[UIActivityTypeAddToReadingList,
                                  UIActivityTypeAirDrop,
                                  UIActivityTypePrint,
                                  UIActivityTypeSaveToCameraRoll];
    } else if ([shareObject isMemberOfClass:[NSURL class]]) {
        excludedActivityTypes = @[UIActivityTypeAirDrop,
                                  UIActivityTypePrint,
                                  UIActivityTypeSaveToCameraRoll];
    } else {
        excludedActivityTypes = @[UIActivityTypeAddToReadingList,
                                  UIActivityTypeAirDrop,
                                  UIActivityTypePrint,
                                  UIActivityTypeSaveToCameraRoll];
    }
    activityViewController.excludedActivityTypes = excludedActivityTypes;
    
    [[self topMostController] presentViewController:activityViewController animated:YES completion:nil];
    
    /*
     [UIActionSheet showFromTabBar:[self topMostController].tabBarController.tabBar withTitle:@"Copy URL?" cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@[@"Copy"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
     if (buttonIndex != actionSheet.cancelButtonIndex) {
     [[UIPasteboard generalPasteboard] setURL:url];
     [SVProgressHUD showSuccessWithStatus:@"URL Copied"];
     }
     }];
     */
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSString *mailURLScheme = @"mailto";
    if ([[url scheme] isEqualToString:mailURLScheme]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:[url absoluteString]];
        webViewController.barsTintColor = [UIColor blackColor];
        [[self topMostController] presentViewController:webViewController animated:YES completion:NULL];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

@end
