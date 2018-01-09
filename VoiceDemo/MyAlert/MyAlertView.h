//
//  AlertView.h
//  VoiceDemo
//
//  Created by 寒影 on 07/07/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#ifndef AlertView_h
#define AlertView_h
#endif /* AlertView_h */
#import <UIKit/UIKit.h>

@class MyPopupView;

typedef NS_ENUM(NSUInteger, MyAlertAnimationType)
{
    KTAlertControllerAnimationTypeCenterShow = 0,   // 从中间放大弹出
    KTAlertControllerAnimationTypeUpDown            // 从上往下掉
};

typedef NS_ENUM(NSInteger, MyAlertDismissStyle) {
    ASPopupDismissStyleFadeOut,             // 渐出
    ASPopupDismissStyleContractHorizontal,  // 水平收起
    ASPopupDismissStyleContractVertical   // 垂直收起
    
};

static const CGFloat as_backgroundAlpha = 0.4;

@interface MyAlertView : UIViewController


@property (nonnull, nonatomic, strong)UIView *alertView;


@property (nonnull, nonatomic, strong)UIView *backgroundView;

-(void)show;

-(id) initWithType: (NSInteger )type withTitle:(NSString *) title;
@end
