//
//  EventInfoFlyerDescriptionCell.m
//  pvmntapp
//
//  Created by Phil Meyers IV on 11/6/14.
//  Copyright (c) 2014 pvmnt. All rights reserved.
//

#import "EventInfoFlyerDescriptionCell.h"
@interface EventInfoFlyerDescriptionCell()
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end


@implementation EventInfoFlyerDescriptionCell
- (void)setHTMLstring:(NSString *)HTMLstring
{
    _HTMLstring = HTMLstring;
    NSAttributedString *markdownString = [[NSAttributedString alloc] initWithData:[HTMLstring dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    self.descriptionLabel.attributedText = markdownString;
}
- (void)awakeFromNib {
    // Initialization code
}

@end
