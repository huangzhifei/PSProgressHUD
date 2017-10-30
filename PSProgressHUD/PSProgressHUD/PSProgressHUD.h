//
//  PSProgressHUD.h
//  PSProgressHUD
//
//  Created by eric on 2017/6/9.
//  Copyright © 2017年 Formax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define kPSProgressHUD [PSProgressHUD new]

typedef NS_ENUM(NSUInteger, PSHUDMaskType) {
    PSHUDMaskType_Clear = 0,        //不允许操作, default
    PSHUDMaskType_None,             //允许操作其他UI
};

typedef NS_ENUM(NSUInteger, PSHUDInViewType) {
    PSHUDInViewType_KeyWindow = 0,  //UIApplication.KeyWindow 为 default
    PSHUDInViewType_CurrentView,    //currentViewController.view
};

typedef NS_ENUM(NSUInteger, PSProgressType) {
    PSProgressType_Default = 0,
    PSProgressType_HorizontalBar,   //水平进度条
    PSProgressType_AnnularBar,      //环形进度条
};

@interface PSProgressHUD : NSObject

/**
 .showMessage(@"需要显示的文字")
 */
- (PSProgressHUD *(^)(NSString *))message;

/**
 .animated(YES)是否动画，YES动画，NO不动画
 */
- (PSProgressHUD *(^)(BOOL))animated;

/**
 .inView(view)
 有特殊需要inView的才使用，一般使用.inViewType()
 */
- (PSProgressHUD *(^)(UIView *))inView;

/**
 .inViewType(inViewType) 指定的InView
 PSHUDInViewType_KeyWindow--KeyWindow,配合MaskType_Clear，就是全部挡住屏幕不能操作了，只能等消失
 PSHUDInViewType_CurrentView--当前的ViewController,配合MaskType_Clear,就是view不能操作，但是导航栏能操作（例如返回按钮）。
 */
- (PSProgressHUD *(^)(PSHUDInViewType))inViewType;

/**
 .maskType(MaskType) HUD显示是否允许操作背后,
 PSHUDMaskType_None:允许
 PSHUDMaskType_Clear:不允许
 */
- (PSProgressHUD *(^)(PSHUDMaskType))maskType;

/**
 .customView(view),设置customView
 */
- (PSProgressHUD *(^)(UIView *))customView;

/**
 .afterDelay 消失时间，默认是0秒表示常在
 */
- (PSProgressHUD *(^)(NSTimeInterval))afterDelay;

/**
 progressType()设置进度条类型
 PSProgressType_HorizontalBar--水平进度条
 PSProgressType_AnnularBar-----环形进度条
 */
- (PSProgressHUD *(^)(PSProgressType))progressType;

// 显示带有转子动画的内容（可以包括文本）
+ (MBProgressHUD *)showHUD:(void (^)(PSProgressHUD *make))block;

// 仅仅显示纯文本内容
+ (MBProgressHUD *)showMessageHUD:(void (^)(PSProgressHUD *make))block;

// hide 的 view 要和 show 的 view 是一样的
+ (void)hideHUD:(void (^)(PSProgressHUD *make))block;

@end
