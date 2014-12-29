//
//  FlyerDetailCollectionViewController.m
//  pmvnt
//
//  Created by Phil Meyers IV on 8/10/14.
//  Copyright (c) 2014 b220. All rights reserved.
//

#import "FlyerDetailCollectionViewController.h"
#import "FlyerDetailInformationCell.h"
#import "FlyerDetailHeaderCell.h"
#import "FlyerDetailParallaxCell.h"
#import "CSStickyHeaderFlowLayout.h"
#import "XLMediaZoom.h"
#import "NSDate+Utilities.h"

@interface FlyerDetailCollectionViewController ()
@property (strong, nonatomic) NSMutableArray *eventInformationArray;
@property (strong, nonatomic) FlyerDetailInformationCell *prototypeCell;
@property (strong, nonatomic) UIImageView *flyerImageView;
@end

@implementation FlyerDetailCollectionViewController
#pragma mark - ActionSheet
- (IBAction)flyerActionButton:(UIBarButtonItem *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Flyer Title" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Join Event", @"Save Flyer", @"Share Flyer", nil];
    [actionSheet setTintColor:[UIColor blackColor]];
    [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

//- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
//{
//    for (UIView *subview in actionSheet.subviews) {
//        if ([subview isKindOfClass:[UIButton class]]) {
//            UIButton *button = (UIButton *)subview;
//            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        }
//    }
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self performSelectorInBackground:@selector(textRecognition) withObject:nil];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 400);
        layout.parallaxHeaderAlwaysOnTop = YES;
    }
    
    // If we want to disable the sticky header effect
    layout.disableStickyHeaders = YES;
    
    // Also insets the scroll indicator so it appears below the search bar
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
    [self.collectionView registerNib:[UINib nibWithNibName:@"FlyerDetailParallaxCell" bundle:nil]
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"Parallax Header"];
    
    _eventInformationArray = [NSMutableArray arrayWithObjects:@"Location: Cahn Auditorium", [NSString stringWithFormat:@"Time: %@", [self.flyer.event_date mediumString]] , @"Promotional Information and additional information about the event...", nil];
    //_eventInformationArray = [NSMutableArray arrayWithObjects:@"Location", nil];
    
    //NSLog(@"%@", self.flyer.flyerDescription);
    NSLog(@"%@", self.flyer.event_date);

}


#pragma mark - Tesseract
/*
- (void)textRecognition
{
    // language are used for recognition. Ex: eng. Tesseract will search for a eng.traineddata file in the dataPath directory; eng+ita will search for a eng.traineddata and ita.traineddata.
    
    //Like in the Template Framework Project:
    // Assumed that .traineddata files are in your "tessdata" folder and the folder is in the root of the project.
    // Assumed, that you added a folder references "tessdata" into your xCode project tree, with the ‘Create folder references for any added folders’ options set up in the «Add files to project» dialog.
    // Assumed that any .traineddata files is in the tessdata folder, like in the Template Framework Project
    
    //Create your tesseract using the initWithLanguage method:
    // Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng+ita"];
    
    // set up the delegate to recieve tesseract's callback
    // self should respond to TesseractDelegate and implement shouldCancelImageRecognitionForTesseract: method
    // to have an ability to recieve callback and interrupt Tesseract before it finishes
    
    Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng"];
    tesseract.delegate = self;
    
    //[tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"]; //limit search
    [tesseract setImage:[self.flyerImage blackAndWhite]]; //image to check
    [tesseract recognize];
    
    UIAlertView *recognized = [[UIAlertView alloc] initWithTitle:@"Tesseract Recgonized Characters" message:[tesseract recognizedText] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [recognized show];
    NSLog(@"Recognized characters: %@", [tesseract recognizedText]);
    
    tesseract = nil; //deallocate and free all memory
}


- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract
{
    NSLog(@"progress: %d", tesseract.progress);
    return NO;  // return YES, if you need to interrupt tesseract before it finishes
}
 */

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _eventInformationArray.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Information Cell";
    FlyerDetailInformationCell *cell = (FlyerDetailInformationCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textForCell = (NSString *)_eventInformationArray[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@", kind);
        UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
//        NSLog(@"%@", indexPath);
        static NSString *headerIdentifier = @"Parallax Header";
         FlyerDetailParallaxCell *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        //headerView.image = self.flyerImage;
        headerView.image = self.flyer.flyerImage;
        self.flyerImageView = headerView.imageView;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullscreenFlyer)];
        [headerView addGestureRecognizer:tapGR];
        reusableView = headerView;
        return reusableView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        static NSString *headerIdentifier = @"Header Cell";
        FlyerDetailHeaderCell *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        headerView.textForCell = self.flyer.title;
        headerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.20f];
        reusableView = headerView;
        return reusableView;
    }
    return nil;
}


/*
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
 {
 
 }
 */

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}


#pragma mark - MWPhotoBrowser
- (void)showFullscreenFlyer
{
    XLMediaZoom *imageZoom = [[XLMediaZoom alloc] initWithAnimationTime:@(0.25) image:self.flyerImageView blurEffect:YES];
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:imageZoom];
    [self.flyerImageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageZoom show];
    [self.flyerImageView setContentMode:UIViewContentModeScaleAspectFill];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
