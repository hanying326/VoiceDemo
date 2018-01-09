//
//  MyAlertView.m
//  VoiceDemo
//
//  Created by 寒影 on 07/07/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyAlertView.h"
#import "Macros.h"


@interface MyAlertView()

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation MyAlertView





-(id) initWithType: (NSInteger )type withTitle:(NSString *) title{
    
    
    if(self = [super init]) {
        
        
        [self commonInit];
        
           [self setTitle:title];
        
        
        
        
        switch (type) {
            case 100:
                
                
                break;
            case 101:
                
                
                
                break;
                
            case 102:
                   
                break;
                
            default:
                break;
        }
    }
    return self;
}


- (void)commonInit {
    //如果自定义需要更大的现实面积，可以使用属性，是否裁剪超出super view的部分
    self.view.clipsToBounds = NO;
    
    //用于覆盖原有的样式
    self.customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.customView.backgroundColor = [UIColor redColor];
    self.customView.center = self.view.center;
    [self.view addSubview:self.customView];
    
    //用于出发隐藏的按钮
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0, 120, 30);
    self.button.center = self.customView.center;
    self.button.layer.cornerRadius = 5.f;
    [self.button setBackgroundColor:[UIColor blueColor]];
    [self.button setTitle:@"确定" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customView addSubview:self.button];
    
}


- (void)buttonAction:(UIButton *)button {
    
    
    
   
}

-(void) show{
     [self presentViewController:self animated:YES completion:nil];
}



- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tempWindow in windows)
        {
            if (tempWindow.windowLevel == UIWindowLevelNormal)
            {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}


@end
