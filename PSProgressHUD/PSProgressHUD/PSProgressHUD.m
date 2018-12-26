//
//  PSProgressHUD.m
//  PSProgressHUD
//
//  Created by eric on 2017/6/9.
//  Copyright © 2017年 Formax. All rights reserved.
//

#import "PSProgressHUD.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG
static DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif

typedef NS_ENUM(NSUInteger, PSProgressType) {
    PSProgressType_Default = 0,
    PSProgressType_HorizontalBar, //水平进度条
    PSProgressType_AnnularBar,    //环形进度条
};

@interface PSProgressHUD ()

//全都可以使用的参数
@property (nonatomic, strong) UIView *ps_inView;            /* hud加在那个view上 */
@property (nonatomic, assign) BOOL ps_animated;             /* 是否动画显示、消失 */
@property (nonatomic, assign) PSHUDMaskType ps_maskType;    /* hud背后的view是否还可以操作 */
@property (nonatomic, strong) UIView *ps_customView;        /* 自定义的view */
@property (nonatomic, strong) NSString *ps_customIconName;  /* 自定义的小图标 */
@property (nonatomic, strong) NSString *ps_message;         /* hud上面的文字 */
@property (nonatomic, assign) NSTimeInterval ps_afterDelay; /* 自动消失时间,default = 0 */
//只有进度条使用的
@property (nonatomic, assign) PSProgressType ps_progressType; /* 进度条类型：水平横条或者圆形 */

@end

@implementation PSProgressHUD

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        //这里可以设置一些默认的属性
        _ps_inView = [UIApplication sharedApplication].keyWindow;
        _ps_maskType = PSHUDMaskType_Clear;
        _ps_afterDelay = 0.0f;
        _ps_progressType = 0;
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
        [MBBarProgressView appearanceWhenContainedIn:[MBProgressHUD class], nil].progressRemainingColor = [UIColor whiteColor];
    }
    return self;
}

- (PSProgressHUD * (^)(UIView *) )inView {
    __weak typeof(self) weakSelf = self;
    return ^PSProgressHUD *(id obj) {
        weakSelf.ps_inView = obj;
        return weakSelf;
    };
}

- (PSProgressHUD * (^)(UIView *) )customView {
    __weak typeof(self) weakSelf = self;
    return ^PSProgressHUD *(id obj) {
        weakSelf.ps_customView = obj;
        return weakSelf;
    };
}

- (PSProgressHUD * (^)(NSString *) )customIconName {
    __weak typeof(self) weakSelf = self;
    return ^PSProgressHUD *(id obj) {
        weakSelf.ps_customIconName = obj;
        return weakSelf;
    };
}

- (PSProgressHUD * (^)(PSHUDInViewType))inViewType {
    __weak typeof(self) weakSelf = self;
    return ^PSProgressHUD *(PSHUDInViewType inViewType) {
        if (inViewType == PSHUDInViewType_KeyWindow) {
            weakSelf.ps_inView = [UIApplication sharedApplication].keyWindow;
        } else if (inViewType == PSHUDInViewType_CurrentView) {
            weakSelf.ps_inView = [self fmi_topViewController].view;
        }
        return weakSelf;
    };
}

- (PSProgressHUD * (^)(BOOL))animated {
    __weak typeof(self) weakSelf = self;
    return ^PSProgressHUD *(BOOL animated) {
        weakSelf.ps_animated = animated;
        return weakSelf;
    };
}

- (PSProgressHUD * (^)(PSHUDMaskType))maskType {
    __weak typeof(self) weakSelf = self;
    return ^PSProgressHUD *(PSHUDMaskType maskType) {
        weakSelf.ps_maskType = maskType;
        return weakSelf;
    };
}

- (PSProgressHUD * (^)(NSTimeInterval))afterDelay {
    __weak typeof(self) weakSelf = self;
    return ^PSProgressHUD *(NSTimeInterval afterDelay) {
        weakSelf.ps_afterDelay = afterDelay;
        return weakSelf;
    };
}

- (PSProgressHUD * (^)(NSString *) )message {
    __weak typeof(self) weakSelf = self;
    return ^PSProgressHUD *(NSString *msg) {
        weakSelf.ps_message = msg;
        return weakSelf;
    };
}

- (PSProgressHUD * (^)(PSProgressType))progressType {
    __weak typeof(self) weakSelf = self;
    return ^PSProgressHUD *(PSProgressType progressType) {
        weakSelf.ps_progressType = progressType;
        return weakSelf;
    };
}

#pragma mark - Method

#pragma mark - Loading

+ (void)showLoadingHUD:(void (^)(PSProgressHUD *))block {
    [self showLoadingHUD:block multiline:NO];
}

+ (void)showLoadingHUD:(void (^)(PSProgressHUD *))block multiline:(BOOL)flag {
    if ([NSThread isMainThread]) {
        PSProgressHUD *makeObj = [[PSProgressHUD alloc] init];
        if (block) {
            block(makeObj);
        }
        if (makeObj.ps_message.length > 0) {
            DDLogInfo(@"HUD: %@", makeObj.ps_message);
        } else {
            DDLogInfo(@"HUD: %@", @"正在加载");
        }
        [MBProgressHUD hideHUDForView:makeObj.ps_inView animated:makeObj.ps_animated];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:makeObj.ps_inView animated:makeObj.ps_animated];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.9f];
        if (flag) {
            hud.detailsLabel.text = makeObj.ps_message;
            hud.detailsLabel.font = [UIFont systemFontOfSize:17.0];
        } else {
            hud.label.text = makeObj.ps_message;
        }
        hud.removeFromSuperViewOnHide = YES;
        hud.userInteractionEnabled = !makeObj.ps_maskType;
        if (makeObj.ps_progressType == PSProgressType_HorizontalBar) {
            hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
            hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        } else if (makeObj.ps_progressType == PSProgressType_AnnularBar) {
            hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
            hud.mode = MBProgressHUDModeAnnularDeterminate;
        }
        if (makeObj.ps_afterDelay > 0) {
            [hud hideAnimated:YES afterDelay:makeObj.ps_afterDelay];
        } else {
            makeObj.ps_afterDelay = 20;
            [hud hideAnimated:YES afterDelay:makeObj.ps_afterDelay];
        }
        if (makeObj.ps_customView) {
            hud.customView = makeObj.ps_customView;
            hud.mode = MBProgressHUDModeCustomView;
        }
        if (flag) {
            hud.detailsLabel.textColor = [UIColor whiteColor];
        } else {
            hud.label.textColor = [UIColor whiteColor];
        }
    } else {
        NSAssert(NO, @"必须在主线程调用 UI 相关");
    }
}

#pragma mark - Toast Message

+ (void)showMessageHUD:(void (^)(PSProgressHUD *))block {
    [self showMessageHUD:block multiline:NO];
}

+ (void)showMultilineMessageHUD:(void (^)(PSProgressHUD *))block {
    [self showMessageHUD:block multiline:YES];
}

+ (void)showMessageHUD:(void (^)(PSProgressHUD *))block multiline:(BOOL)flag {
    if ([NSThread isMainThread]) {
        PSProgressHUD *makeObj = [[PSProgressHUD alloc] init];
        if (block) {
            block(makeObj);
        }
        if (makeObj.ps_message.length > 0) {
            DDLogInfo(@"HUD: %@", makeObj.ps_message);
        } else {
            DDLogInfo(@"HUD: %@", @"正在加载");
        }
        [MBProgressHUD hideHUDForView:makeObj.ps_inView animated:makeObj.ps_animated];
        // 默认 2 秒后自动消失
        if (makeObj.ps_afterDelay <= 0) {
            makeObj.ps_afterDelay = 2.0f;
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:makeObj.ps_inView animated:makeObj.ps_animated];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.9f];
        if (flag) {
            hud.detailsLabel.text = makeObj.ps_message;
            hud.detailsLabel.font = [UIFont systemFontOfSize:17];
        } else {
            hud.label.text = makeObj.ps_message;
            hud.label.font = [UIFont systemFontOfSize:17];
        }
        hud.mode = MBProgressHUDModeText;
        hud.removeFromSuperViewOnHide = YES;
        hud.userInteractionEnabled = !makeObj.ps_maskType;
        if (makeObj.ps_progressType == PSProgressType_HorizontalBar) {
            hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
            hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        } else if (makeObj.ps_progressType == PSProgressType_AnnularBar) {
            hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
            hud.mode = MBProgressHUDModeAnnularDeterminate;
        }
        if (makeObj.ps_afterDelay > 0) {
            [hud hideAnimated:YES afterDelay:makeObj.ps_afterDelay];
        } else {
            makeObj.ps_afterDelay = 20;
            [hud hideAnimated:YES afterDelay:makeObj.ps_afterDelay];
        }
        if (makeObj.ps_customView) {
            hud.customView = makeObj.ps_customView;
            hud.mode = MBProgressHUDModeCustomView;
        }
        if (flag) {
            hud.detailsLabel.textColor = [UIColor whiteColor];
        } else {
            hud.label.textColor = [UIColor whiteColor];
        }
    } else {
        NSAssert(NO, @"必须在主线程调用 UI 相关");
    }
}

#pragma mark - Hide HUD

+ (void)hideHUD:(void (^)(PSProgressHUD *))block {
    PSProgressHUD *makeObj = [[PSProgressHUD alloc] init];
    if (block) {
        block(makeObj);
    }
    [MBProgressHUD hideHUDForView:makeObj.ps_inView animated:makeObj.ps_animated];
}

#pragma mark - Get top view

- (UIViewController *)fmi_topViewController {
    UIViewController *topVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }

    if ([topVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *mainview = (UITabBarController *) topVC;
        UINavigationController *selectView = [mainview.viewControllers objectAtIndex:mainview.selectedIndex];
        if (selectView) {
            return selectView.visibleViewController;
        }
    } else if ([topVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *selectView = (UINavigationController *) topVC;
        return selectView.visibleViewController;
    } else if (topVC && [topVC isKindOfClass:[UIViewController class]]) {
        return topVC;
    }
    return nil;
}

@end
