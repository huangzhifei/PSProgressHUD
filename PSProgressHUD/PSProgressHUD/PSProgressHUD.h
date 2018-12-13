//
//  PSProgressHUD.h
//  PSProgressHUD
//  0.0.5
//  Created by eric on 2017/6/9.
//  Copyright © 2017年 Formax. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

#define kPSProgressHUD [PSProgressHUD new]

typedef NS_ENUM(NSUInteger, PSHUDMaskType) {
    PSHUDMaskType_Clear = 0, //不允许操作, default
    PSHUDMaskType_None,      //允许操作其他UI
};

typedef NS_ENUM(NSUInteger, PSHUDInViewType) {
    PSHUDInViewType_KeyWindow = 0, //UIApplication.KeyWindow 为 default
    PSHUDInViewType_CurrentView,   //currentViewController.view
};

@interface PSProgressHUD : NSObject

/**
 .message(@"需要显示的文字")
 */
- (PSProgressHUD * (^)(NSString *) )message;

/**
 .animated(YES)是否动画消失，YES动画，NO不动画，默认为 NO
 */
- (PSProgressHUD * (^)(BOOL))animated;

/**
 .inView(view)
 有特殊需要inView的才使用，一般使用.inViewType(PSHUDInViewType)
 */
- (PSProgressHUD * (^)(UIView *) )inView;

/**
 .inViewType(inViewType) 指定的InView
 PSHUDInViewType_KeyWindow -- KeyWindow
 PSHUDInViewType_CurrentView -- 当前的ViewController
 */
- (PSProgressHUD * (^)(PSHUDInViewType))inViewType;

/**
 .maskType(MaskType) HUD显示是否允许操作背后视图，默认不需要设置此值
 PSHUDMaskType_None:允许
 PSHUDMaskType_Clear:不允许
 */
- (PSProgressHUD * (^)(PSHUDMaskType))maskType;

/**
 .customView(view),设置自定义的 customView
 */
- (PSProgressHUD * (^)(UIView *) )customView;

/**
 .afterDelay 消失时间，默认是 0 秒，即不消失，防止出现不消失的场景，如果传 0，会默认设置 20 秒后自动消失
 */
- (PSProgressHUD * (^)(NSTimeInterval))afterDelay;

/**
 显示带有转子动画的内容（可以包括文本），默认不消失，需要主动 hide 或设置自动消失时间
 */
+ (void)showHUD:(void (^)(PSProgressHUD *make))block;

/**
 仅仅显示纯文本内容 (Toast)，默认 2 秒后自动消失
 */
+ (void)showMessageHUD:(void (^)(PSProgressHUD *make))block;

/**
 hide 的 view 要和 show 的 view 是一样的，主要通过设置 inViewType
 */
+ (void)hideHUD:(void (^)(PSProgressHUD *make))block;

@end
