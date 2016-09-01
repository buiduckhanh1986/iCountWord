//
//  ViewController.m
//  iCountWord
//
//  Created by Bui Duc Khanh on 9/1/16.
//  Copyright © 2016 Bui Duc Khanh. All rights reserved.
//

#import "ViewController.h"
#import "ResultViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tvData;

@end

@implementation ViewController
{
    ResultViewController * resultView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Input Text & Count";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    resultView = [ResultViewController new];
}

- (IBAction)onBtnCountWordTouchUpInside:(id)sender {
    resultView.data = [self.tvData.text lowercaseString];
    
    [self.navigationController pushViewController:resultView animated:YES];
}

@end
