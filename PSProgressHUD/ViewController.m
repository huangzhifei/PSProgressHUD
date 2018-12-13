//
//  ViewController.m
//  PSProgressHUD
//
//  Created by eric on 2017/11/16.
//  Copyright © 2017年 huangzhifei. All rights reserved.
//

#import "ViewController.h"
#import "PSProgressHUD.h"
#import <HZFGCDTimer.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"HUD";

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"下一页"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(jumpNext:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)jumpNext:(id)sender {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor greenColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)HUD_KeyWindow:(id)sender {
    [PSProgressHUD showHUD:^(PSProgressHUD *make) {
        make.afterDelay(2);
    }];
}

- (IBAction)HUD_Text_KeyWindow:(id)sender {
    [PSProgressHUD showHUD:^(PSProgressHUD *make) {
        make.message(@"正在加载...").afterDelay(2);
    }];
}

- (IBAction)HUD_Toast_KeyWindow:(id)sender {
    [PSProgressHUD showMessageHUD:^(PSProgressHUD *make) {
        make.message(@"我是提示");
    }];
}

- (IBAction)HUD_CurrentView:(id)sender {
    [PSProgressHUD showHUD:^(PSProgressHUD *make) {
        make.inViewType(PSHUDInViewType_CurrentView).afterDelay(2);
    }];
}

- (IBAction)HUD_Text_CurrentView:(id)sender {
    [PSProgressHUD showHUD:^(PSProgressHUD *make) {
        make.message(@"正在加载...").afterDelay(2).inViewType(PSHUDInViewType_CurrentView);
    }];
}

- (IBAction)HUD_Toast_CurrentView:(id)sender {
    [PSProgressHUD showMessageHUD:^(PSProgressHUD *make) {
        make.message(@"我是提示").inViewType(PSHUDInViewType_CurrentView);
    }];
}

- (IBAction)HUD_Program_KeyWindow:(id)sender {
    [PSProgressHUD showHUD:^(PSProgressHUD *make) {
        make.message(@"正在加载...");
    }];
    [HZFGCDTimer scheduledTimerWithTimeInterval:5.0 repeats:NO block:^{
        [PSProgressHUD hideHUD:^(PSProgressHUD *make) {
            
        }];
    }];
}

- (IBAction)HUD_Program_CurrentView:(id)sender {
    [PSProgressHUD showHUD:^(PSProgressHUD *make) {
        make.inViewType(PSHUDInViewType_CurrentView).message(@"正在加载...");
    }];
    [HZFGCDTimer scheduledTimerWithTimeInterval:5.0 repeats:NO block:^{
        [PSProgressHUD hideHUD:^(PSProgressHUD *make) {
            make.inViewType(PSHUDInViewType_CurrentView);
        }];
    }];
}


@end
