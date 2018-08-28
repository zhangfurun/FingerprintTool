//
//  ViewController.m
//  FingerprintTool
//
//  Created by ifenghui on 2018/8/27.
//  Copyright © 2018年 ifenghui. All rights reserved.
//

#import "ViewController.h"

#import "FingerprintTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)a:(id)sender {
    [FingerprintTool fingerprintVerification:^(BOOL isSuccess, NSString *resultString) {
       
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
