//
//  VoicePrintTextLogin.m
//  VoiceDemo
//
//  Created by 寒影 on 04/07/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VoicePrintTextLoginViewController.h"


@interface VoicePrintTextLogin()
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *pwdInput;

@end

@implementation VoicePrintTextLogin

-(void) viewDidLoad{
    
      [super viewDidLoad];
//    _nameInput.borderStyle = UITextBorderStyleLine;
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

@end
