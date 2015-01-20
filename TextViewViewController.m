//
//  TextViewViewController.m
//  Pvmnt
//
//  Created by Phil Meyers IV on 1/19/15.
//  Copyright (c) 2015 Pvmnt. All rights reserved.
//

#import "TextViewViewController.h"

@interface TextViewViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end
@implementation TextViewViewController
- (void)setText:(NSString *)text
{
    _text = text;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.textView.text = self.text;
    self.textView.font = [UIFont fontWithName:@"OpenSans" size:16];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
