//
//  ASPopupController.m
//  ASPopupController
//
//  Created by Cyrus on 16/3/26.
//  Copyright © 2016年 Cyrus. All rights reserved.
//

#import "MyPopupController.h"
#import "MyPopupView.h"
#import "Macros.h"

#import "MyPopupPresentAnimator.h"
#import "MyPopupDismissAnimator.h"
#import "PopupTable.h"

/** 弹窗总宽度 */
const static CGFloat alertWidth = WIDTH_SCREEN - 6*PADDING;

@interface ASPopupController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)PopupTable *messagetable;
@property (nonatomic, strong)UIButton *actionButton;
@property (nonatomic, assign)CGFloat popupTableHeight;

@property (nonatomic, assign)UIViewController *controller;
@end

@implementation ASPopupController

- (instancetype)init {
    if (self = [super init]) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        // 灰色半透明背景
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = as_backgroundAlpha;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 背景透明
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_backgroundView];
    [self.view addSubview:_alertView];
    
    // 设置灰色半透明背景的约束
    [NSLayoutConstraint constraintWithItem:_backgroundView
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_backgroundView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_backgroundView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_backgroundView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    
    // 设置 alertView 在屏幕中心
    
       _alertView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint constraintWithItem:_alertView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:_alertView
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    
    
    
    [NSLayoutConstraint constraintWithItem:_alertView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:alertWidth].active = YES;
    
    
    
    
    
    
    
//
    CGFloat maxHeight = HEIGHT_SCREEN - 150.0;
    CGFloat viewHeight = _popupTableHeight +100;
    
    
    
    if(viewHeight > maxHeight){  viewHeight = maxHeight; }
    
    
    
    [NSLayoutConstraint constraintWithItem:_alertView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:viewHeight].active = YES;
    
    
    
    
////
//    [NSLayoutConstraint constraintWithItem:_alertView
//                                 attribute:NSLayoutAttributeHeight
//                                 relatedBy:NSLayoutRelationLessThanOrEqual
//                                    toItem:nil
//                                 attribute:NSLayoutAttributeNotAnAttribute
//                                multiplier:1.0
//                                  constant:maxHeight].active = YES;
    
}

/** 添加 action */
- (void)addAction:(MyPopupAction * _Nonnull)action {
    if ([_alertView isMemberOfClass:[MyPopupView class]]) {
        [(MyPopupView *)_alertView addAction: action];
    }
}

/** 直接添加一个数组的 action */
- (void)addActions:(NSArray<MyPopupAction *> * _Nonnull)actions {
    for (MyPopupAction *action in actions) {
        [self addAction:action];
    }
}

/** 设置 alertView 的圆角半径 */
- (void)setAlertViewCornerRadius:(CGFloat)cornerRadius {
    _alertView.layer.cornerRadius = cornerRadius;
}



/** 默认转场初始化 */
+ (_Nonnull instancetype)alertWithType:(NSInteger )type withController :(UIViewController *) controller{
    
    ASPopupController *alertController = [[ASPopupController alloc] init];
    alertController.presentStyle = ASPopupPresentStyleSystem;
    alertController.dismissStyle = ASPopupDismissStyleFadeOut;
    
    alertController.type = type;
    [alertController drawPopupViewWithType:type];
    
    //    alertController.alertView = [[MyPopupView alloc] initWithType:type];
//    ((MyPopupView *)(alertController.alertView)).controller = alertController;
    
    alertController.controller = controller;
    
    return alertController;
}

#pragma mark - UIViewControllerTransitioningDelegate

/** 返回Present动画 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    ASPopupPresentAnimator *animator = [[ASPopupPresentAnimator alloc] init];
    animator.presentStyle = self.presentStyle;
    return animator;
}

/** 返回Dismiss动画 */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    ASPopupDismissAnimator *animator = [[ASPopupDismissAnimator alloc] init];
    animator.dismissStyle = self.dismissStyle;
    return animator;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    CGPoint point = [[touches anyObject] locationInView:self.view];

    point = [_backgroundView.layer convertPoint:point fromLayer:self.view.layer];
    if ([_backgroundView.layer containsPoint:point]) {

        point = [_alertView.layer convertPoint:point fromLayer:_backgroundView.layer];
        if (![_alertView.layer containsPoint:point])
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }

        else{
//            NSLog(@"touchesBegan");
            
//            [_backgroundView resignFirstResponder];
        }
    }
}



-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)drawPopupViewWithType : (NSInteger) type{
    
    
    NSString * title;
    
    switch (type) {
        case LANG_SETTING:
            title = @"语种选择";
            break;
            
        case ARGU_SETTING:
            title = @"参数配置";
            break;
        case ADDR_SETTING:
            title = @"地址设置";
            break;
            
        case VOICE_SETTING:
            title = @"声音选择";
            break;
            
        case SIM_SWITCH:
            title = @"简繁转换";
            break;
            
        case MODEL_SETTING:
            title = @"模型选择";
            break;
            
        case ADDR_SETTING_ASK:
            title = @"地址配置";
            break;
            
        default:
            break;
    }
    
    _alertView = [[UIView alloc]init];
    
//      _alertView.backgroundColor =  [UIColor colorWithWhite:0.9 alpha:1];
    
    _titleLabel = [[UILabel alloc] init];
    
    _titleLabel.text = title;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 0;
    
    _titleLabel.font = [UIFont systemFontOfSize:17.0 ];
    
    _titleLabel.textColor = POP_TEXT_COLOR;
    
    
    
     [_alertView addSubview:_titleLabel];
    
    
      _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint constraintWithItem:_titleLabel
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:alertWidth-2*PADDING].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_titleLabel
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_alertView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:PADDING].active = YES;
    [NSLayoutConstraint constraintWithItem:_titleLabel
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_alertView
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:PADDING].active = YES;
    
    
    
    _messagetable = [[PopupTable alloc]initWithType:type];
    
      _popupTableHeight = [_messagetable tableHeight];
    
    if(_popupTableHeight > HEIGHT_SCREEN -150 - 100){
        _popupTableHeight =HEIGHT_SCREEN -150 - 100;
        
    }
    
    [_messagetable setFrame:CGRectMake(0,40, alertWidth, _popupTableHeight)];
      [_messagetable setTableFooterView:[UIView new]];
      _messagetable.separatorStyle =UITableViewCellSeparatorStyleNone ;
     [_alertView addSubview:_messagetable];
    
    
//    _messagetable.translatesAutoresizingMaskIntoConstraints = NO;
//    [NSLayoutConstraint constraintWithItem:_messagetable
//                                 attribute:NSLayoutAttributeWidth
//                                 relatedBy:NSLayoutRelationEqual
//                                    toItem:nil
//                                 attribute:NSLayoutAttributeNotAnAttribute
//                                multiplier:1.0
//                                  constant:alertWidth].active = YES;
    
    
//
//    [NSLayoutConstraint constraintWithItem:_messagetable
//                                 attribute:NSLayoutAttributeLeft
//                                 relatedBy:NSLayoutRelationEqual
//                                    toItem:_alertView
//                                 attribute:NSLayoutAttributeLeft
//                                multiplier:1.0
//                                  constant:0].active = YES;
    
    
//    [NSLayoutConstraint constraintWithItem:_messagetable
//                                 attribute:NSLayoutAttributeTop
//                                 relatedBy:NSLayoutRelationEqual
//                                    toItem:_titleLabel
//                                 attribute:NSLayoutAttributeBottom
//                                multiplier:1.0
//                                  constant:PADDING].active = YES;
    
    
//    [NSLayoutConstraint constraintWithItem:_messagetable
//                                 attribute:NSLayoutAttributeTop
//                                 relatedBy:NSLayoutRelationEqual
//                                    toItem:_alertView
//                                 attribute:NSLayoutAttributeTop
//                                multiplier:1.0
//                                  constant:3*PADDING].active = YES;
    
    
    
    
    
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_actionButton setTag:1];
    [_actionButton setTitle:@"确定" forState:UIControlStateNormal];
    [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_actionButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_actionButton setBackgroundImage:[UIImage imageNamed:@"Voice_popup_btn_nol"] forState:UIControlStateNormal];
    [_actionButton setBackgroundImage:[UIImage imageNamed:@"Voice_popup_btn_pre"]  forState:UIControlStateHighlighted];
//    [_actionButton addTarget:self action:@selector(actionButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_alertView addSubview:_actionButton];
    
    
    _actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint constraintWithItem:_actionButton
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:alertWidth].active = YES;
    
    
    
    
    [NSLayoutConstraint constraintWithItem:_actionButton
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_alertView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0].active = YES;
    
    
    
    [NSLayoutConstraint constraintWithItem:_actionButton
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_alertView
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:0].active = YES;
    
    
        _alertView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *confirm = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchConfirm)];
    [_actionButton addGestureRecognizer:confirm];
    
    
}


-(void) touchConfirm{
    
    
    
    switch (_type) {
        case LANG_SETTING:
            
            break;
            
        case ARGU_SETTING:
            
            break;
        case ADDR_SETTING:
            
            break;
            
        case VOICE_SETTING:
            
            break;
            
        case SIM_SWITCH:
            
            break;
            
        case MODEL_SETTING:
            
            
            
            
            
            
            
            
            
            break;
            
        case ADDR_SETTING_ASK:
            
            break;
            
        default:
            break;
    }
    
      [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
