//
//  TransferAccountsViewController.m
//  VoiceDemo
//
//  Created by 寒影 on 14/07/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransferAccountsViewController.h"
@interface TransferAccountsViewController()

@end

@implementation  TransferAccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    UIImage *bgImage = [UIImage imageNamed:@"voice_bg.png"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}


@end


