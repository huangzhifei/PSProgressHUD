//
//  PSProgressHUD.m
//  PSProgressHUD
//
//  Created by eric on 2017/6/9.
//  Copyright © 2017年 Formax. All rights reserved.
//

#import "PSProgressHUD.h"

@interface PSProgressHUD ()

//全都可以使用的参数
@property (nonatomic, strong) UIView *ps_inView;            /* hud加在那个view上 */
@property (nonatomic, assign) BOOL ps_animated;             /* 是否动画显示、消失 */
@property (nonatomic, assign) PSHUDMaskType ps_maskType;    /* hud背后的view是否还可以操作 */
@property (nonatomic, strong) UIView *ps_customView;        /* 自定义的view */
@property (nonatomic, strong) NSString *ps_customIconName;  /* 自定义的小图标 */
@property (nonatomic, strong) NSString *ps_message;         /* hud上面的文字 */
@property (nonatomic, assign) NSTimeInterval ps_afterDelay; /* 自动消失时间,default = 1.5 */
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
    }
    return self;
}

- (PSProgressHUD * (^)(UIView *))inView {
    return ^PSProgressHUD *(id obj) {
        _ps_inView = obj;
        return self;
    };
}

- (PSProgressHUD * (^)(UIView *))customView {
    return ^PSProgressHUD *(id obj) {
        _ps_customView = obj;
        return self;
    };
}

- (PSProgressHUD * (^)(NSString *))customIconName {
    return ^PSProgressHUD *(id obj) {
        _ps_customIconName = obj;
        return self;
    };
}

- (PSProgressHUD * (^)(PSHUDInViewType))inViewType {
    return ^PSProgressHUD *(PSHUDInViewType inViewType) {
        if (inViewType == PSHUDInViewType_KeyWindow) {
            _ps_inView = [UIApplication sharedApplication].keyWindow;
        } else if (inViewType == PSHUDInViewType_CurrentView) {
            _ps_inView = [self fmi_topViewController].view;
        }
        return self;
    };
}

- (PSProgressHUD * (^)(BOOL))animated {
    return ^PSProgressHUD *(BOOL animated) {
        _ps_animated = animated;
        return self;
    };
}

- (PSProgressHUD * (^)(PSHUDMaskType))maskType {
    return ^PSProgressHUD *(PSHUDMaskType maskType) {
        _ps_maskType = maskType;
        return self;
    };
}

- (PSProgressHUD * (^)(NSTimeInterval))afterDelay {
    return ^PSProgressHUD *(NSTimeInterval afterDelay) {
        _ps_afterDelay = afterDelay;
        return self;
    };
}

- (PSProgressHUD * (^)(NSString *))message {
    return ^PSProgressHUD *(NSString *msg) {
        _ps_message = msg;
        return self;
    };
}

- (PSProgressHUD *(^)(PSProgressType))progressType {
    return ^PSProgressHUD *(PSProgressType progressType) {
        _ps_progressType = progressType;
        return self;
    };
}

#pragma mark - Method

+ (MBProgressHUD *)showHUD:(void (^)(PSProgressHUD *))block {
    PSProgressHUD *makeObj = [[PSProgressHUD alloc] init];
    block(makeObj);
    [MBProgressHUD hideHUDForView:makeObj.ps_inView animated:makeObj.ps_animated];
    __block MBProgressHUD *hud = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:makeObj.ps_inView animated:makeObj.ps_animated];
        hud.labelText = makeObj.ps_message;
        hud.userInteractionEnabled = !makeObj.ps_maskType;
        if (makeObj.ps_progressType == PSProgressType_HorizontalBar) {
            hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        } else if (makeObj.ps_progressType == PSProgressType_AnnularBar) {
            hud.mode = MBProgressHUDModeAnnularDeterminate;
        }
        if (makeObj.ps_afterDelay > 0) {
            [hud hide:YES afterDelay:makeObj.ps_afterDelay];
        }
        if (makeObj.ps_customView) {
            hud.customView = makeObj.ps_customView;
            hud.mode = MBProgressHUDModeCustomView;
        }
    });
    return hud;
}

+ (MBProgressHUD *)showMessageHUD:(void (^)(PSProgressHUD *))block {
    PSProgressHUD *makeObj = [[PSProgressHUD alloc] init];
    block(makeObj);
    [MBProgressHUD hideHUDForView:makeObj.ps_inView animated:makeObj.ps_animated];
    __block MBProgressHUD *hud = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:makeObj.ps_inView animated:makeObj.ps_animated];
        hud.labelText = makeObj.ps_message;
        hud.mode = MBProgressHUDModeText;
        hud.userInteractionEnabled = !makeObj.ps_maskType;
        if (makeObj.ps_progressType == PSProgressType_HorizontalBar) {
            hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        } else if (makeObj.ps_progressType == PSProgressType_AnnularBar) {
            hud.mode = MBProgressHUDModeAnnularDeterminate;
        }
        if (makeObj.ps_afterDelay > 0) {
            [hud hide:YES afterDelay:makeObj.ps_afterDelay];
        }
        if (makeObj.ps_customView) {
            hud.customView = makeObj.ps_customView;
            hud.mode = MBProgressHUDModeCustomView;
        }
    });
    return hud;
}

+ (void)hideHUD:(void (^)(PSProgressHUD *))block {
    PSProgressHUD *makeObj = [[PSProgressHUD alloc] init];
    block(makeObj);
    [MBProgressHUD hideHUDForView:makeObj.ps_inView animated:makeObj.ps_animated];
}

- (UIViewController *)fmi_topViewController {
    //页面分多层，找到当前打开的页面再navigation
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
