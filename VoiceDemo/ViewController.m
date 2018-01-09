//
//  ViewController.m
//  VoiceDemo
//
//  Created by 寒影 on 20/06/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import "ViewController.h"
#import "Macros.h"

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

#import "AppDelegate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bottonText;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *forthBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (id obj in  self.view.subviews){
        if([obj isKindOfClass:[UIButton class]]){
            [obj setBackgroundImage:[UIImage imageNamed:@"home_button_pre"] forState:UIControlStateHighlighted];
        }
    }
    
    [_backgroundImage setFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN)];
    CGFloat btnWidth = (WIDTH_SCREEN - 70)/2;
    
    //约束
    _bottonText.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint constraintWithItem:_bottonText
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_bottonText
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:-30].active = YES;
    
      _thirdBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [NSLayoutConstraint constraintWithItem:_thirdBtn
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:btnWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_thirdBtn
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:-90].active = YES;
    
    
    [NSLayoutConstraint constraintWithItem:_thirdBtn
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:25].active = YES;
    
    _forthBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint constraintWithItem:_forthBtn
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:btnWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_forthBtn
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:-90].active = YES;
    
    
    [NSLayoutConstraint constraintWithItem:_forthBtn
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:-25].active = YES;
    
    _firstBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint constraintWithItem:_firstBtn
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:btnWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_firstBtn
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.thirdBtn
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:-30].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_firstBtn
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:25].active = YES;
    
    _secondBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint constraintWithItem:_secondBtn
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:btnWidth].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_secondBtn
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.forthBtn
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:-30].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_secondBtn
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:-25].active = YES;
    
    
    
    
    
  
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}


- (IBAction)touchup:(id)sender {
    
}


- (IBAction)touchdown:(id)sender {
    
    
    UIButton *button = sender;
    
    [button setAdjustsImageWhenHighlighted:NO];
    
}


@end
