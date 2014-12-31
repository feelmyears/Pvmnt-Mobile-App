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
#import "UIActionSheet+Blocks.h"
#import "UIAlertView+Blocks.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <FormatterKit/TTTAddressFormatter.h>
#import <MapKit/MapKit.h>
#import "PvmntStyleKit.h"


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

- (void)setupCellWithDescription:(NSString *)description
{
    self.label.text = [description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
