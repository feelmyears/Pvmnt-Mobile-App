//
//  FlyerDetailInformationCell.m
//  pmvnt
//
//  Created by Phil Meyers IV on 8/10/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import "FlyerDetailInformationCell.h"
@interface FlyerDetailInformationCell()
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *informationIcon;

@end

@implementation FlyerDetailInformationCell
- (CGFloat)heightForCell
{
    CGFloat yOrigin = [self convertRect:self.informationLabel.layer.frame fromView:self.informationLabel].origin.y;
    CGSize size = [self sizeOfMultiLineLabel:self.informationLabel];
    CGFloat bottomPadding = 10.f;
    return yOrigin  + bottomPadding;
}

- (void)setTextForCell:(NSString *)textForCell
{
    _textForCell = textForCell;
    self.informationLabel.text = textForCell;
}

-(CGSize)sizeOfMultiLineLabel:(UILabel *)label
{
    
    NSAssert(label, @"UILabel was nil");
    
    //Label text
    NSString *aLabelTextString = [label text];
    
    //Label font
    UIFont *aLabelFont = [label font];
    
    //Width of the Label
    CGFloat aLabelSizeWidth = label.frame.size.width;
    
    return [aLabelTextString boundingRectWithSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{
                                                        NSFontAttributeName : aLabelFont
                                                        }
                                              context:nil].size;

    
}
@end
