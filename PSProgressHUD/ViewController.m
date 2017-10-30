//
//  ViewController.m
//  PSProgressHUD
//
//  Created by eric on 2017/10/30.
//  Copyright © 2017年 huangzhifei. All rights reserved.
//

#import "ViewController.h"
#import "PSProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [PSProgressHUD showHUD:^(PSProgressHUD *make) {
        make.afterDelay(4.0);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
