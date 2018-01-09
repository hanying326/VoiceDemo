//
//  ASPopupController.h
//  ASPopupController
//
//  Created by Cyrus on 16/3/26.
//  Copyright © 2016年 Cyrus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPopupAction.h"
#import "MyPopupHeader.h"

@class MyPopupView;

/** 灰色背景透明度 */
static const CGFloat as_backgroundAlpha = 0.4;

@interface ASPopupController : UIViewController

/** alert 视图 */
@property (nonnull, nonatomic, strong)UIView *alertView;

/** 半透明背景 */
@property (nonnull, nonatomic, strong)UIImageView *backgroundView;

/** present 转场风格 */
@property (nonatomic, assign)ASPopupPresentStyle presentStyle;

/** dismiss 转场风格 */
@property (nonatomic, assign)ASPopupDismissStyle dismissStyle;

@property (nonatomic, assign)NSInteger type;

- (void)setAlertViewCornerRadius:(CGFloat)cornerRadius;

/**
 *    添加 action
 *
 *    @param action action
 */
- (void)addAction:(MyPopupAction * _Nonnull)action;

/**
 *    直接添加一个数组的 action
 *
 *    @param actions 放有 action 的数组
 */
- (void)addActions:(NSArray<MyPopupAction *> * _Nonnull)actions;

-(void)drawPopupViewWithType : (NSInteger) type;

/**
 *    标准初始化方法
 *
 *    @param title        标题
 *    @param message      消息
 *    @param presentStyle present 转场风格
 *    @param dismissStyle dismiss 转场风格
 *
 *    @return alert控制器
 */
//+ (_Nonnull instancetype)alertWithTitle:(NSString * _Nullable)title
//                                message:(NSString * _Nullable)message
//                           presentStyle:(ASPopupPresentStyle)presentStyle
//                           dismissStyle:(ASPopupDismissStyle)dismissStyle;

/**
 *    默认转场初始化方法
 *
 *    @param type   类型
 *
 *    @return alert控制器
 */
+ (_Nonnull instancetype)alertWithType:(NSInteger)type withController:(UIViewController * ) controller;

@end
