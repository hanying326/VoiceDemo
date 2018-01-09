//
//  SecondViewController.m
//  VoiceDemo
//
//  Created by 寒影 on 28/06/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondViewController.h"

#import <AVFoundation/AVAudioSession.h>
#import "YCXMenu.h"
#import "Macros.h"
#import "MyPopupController.h"
#import "PopupTable.h"
#import "AURecorder.h"
#import "SRWebSocket.h"
#import "AppDelegate.h"

#import "KryptonManager.h"

@interface SecondViewController(){
    
    NSMutableData *_data;
    
    BOOL isRecording;
    NSString *totalResult;
    
      NSString *tempResult;
    
    NSTimer *timer;
    
    
    NSMutableArray *wordset;
    
    NSMutableArray *sentence;
    
}
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@property (nonatomic , strong) NSMutableArray *items;
//@property (weak, nonatomic) IBOutlet UITextView *resultView;
//@property (nonatomic, strong) AURecorder *auRecorder;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (nonatomic,strong) NSString *resultStr;
@property (weak, nonatomic) IBOutlet UITextView *testResult;
@property (weak, nonatomic) IBOutlet UILabel *recResultTitle;
@property (weak, nonatomic) IBOutlet UIImageView *wave;

//@property (nonatomic, strong) SocketModel *socketM;
//@property (nonatomic, strong) WebSocket *socket;

@property (nonatomic, strong) AppDelegate *appDelegate;


@end

@implementation  SecondViewController

@synthesize items = _items;

-(void) viewDidLoad{
    
    [super viewDidLoad];
    totalResult = @"";
    [self.view setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillAppear) name:YCXMenuWillAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidAppear) name:YCXMenuDidAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillDisappear) name:YCXMenuWillDisappearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidDisappear) name:YCXMenuDidDisappearNotification object:nil];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    UIImage *bgImage = [UIImage imageNamed:@"voice_bg.png"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    _data = [NSMutableData data];
    
    _line1.hidden = YES;
    _line2.hidden = YES;
    _testResult.editable  = NO;
    
    [_testResult.layer setCornerRadius:10];
    _testResult.layoutManager.allowsNonContiguousLayout = false;
    
    
    //布局
    _line2.translatesAutoresizingMaskIntoConstraints = NO;
    _line1.translatesAutoresizingMaskIntoConstraints = NO;
    _recordBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _testResult.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint constraintWithItem:_line2
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_line1
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_recordBtn
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_line2
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:-PADDING].active = YES;
    
    
    CGFloat btnCenterToBottom = _line2.bounds.size.height /2 + PADDING;
    
    CGFloat line1ToBottom = btnCenterToBottom - _line1.bounds.size.height/2;
    
    [NSLayoutConstraint constraintWithItem:_line1
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:-line1ToBottom].active = YES;
    
    CGFloat btnToBottom = btnCenterToBottom - _recordBtn.bounds.size.height/2;
    
    [NSLayoutConstraint constraintWithItem:_recordBtn
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:-btnToBottom].active = YES;
    
    CGFloat navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    //    [NSLayoutConstraint constraintWithItem:_recResultTitle
    //                                 attribute:NSLayoutAttributeTop
    //                                 relatedBy:NSLayoutRelationEqual
    //                                    toItem:self.recResultTitle
    //                                 attribute:NSLayoutAttributeTop
    //                                multiplier:1.0
    //                                  constant:navigationHeight + 2*PADDING].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_testResult
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.recResultTitle
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:PADDING].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_testResult
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:PADDING].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_testResult
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.line2
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:-PADDING].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_testResult
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:-PADDING].active = YES;
    
    _wave.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint constraintWithItem:_wave
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:WIDTH_SCREEN].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_wave
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0].active = YES;
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    _appDelegate.APPKEYREC = @"";
    _appDelegate.APPSECRETREC = @"";
    
    
    [KryptonManager share].delegate = self;
    
    [KryptonManager share].appSecret = @"xiaoirecdemo";
    
    [KryptonManager share].appKey = @"xiaoirecdemo";
    
    [KryptonManager share].url = WS_URL;
    
    
//    [KryptonManager share].languageType = @"wuu-CHN";
    
    [[KryptonManager share]getLanguageModel];
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(void)viewWillDisappear:(BOOL)animated{
    //      [_auRecorder stopRecorder];
//    [_socket closeSocket];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)menuWillAppear {
    
}

- (void)menuDidAppear {
    
}

- (void)menuWillDisappear {
    
}

- (void)menuDidDisappear {
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (IBAction)touchDown:(id)sender {
}
- (IBAction)touchUp:(id)sender {
    
    if(isRecording){
        //停止录音
        [self stopRecord];
    }
    
    else {
        //开始录音
        [self startRecord];
    }
}


-(void)stopRecord{
    
    [timer invalidate];
    timer = nil;
    
    isRecording = NO;
    
    [[KryptonManager share]stopRecord];
    
    _line1.hidden = YES;
    _line2.hidden = YES;
    [_recordBtn setBackgroundImage:[UIImage imageNamed:@"voice_button_nol"] forState:UIControlStateNormal];
    
    
//      NSLog(@"totalResult:%@",totalResult);
    
    
    
    if (_testResult.text.length > 0 &&![_testResult.text isEqualToString:@"小i语音识别"] && ![totalResult hasSuffix:@"\n"]){
        
        totalResult = [_testResult.text stringByAppendingString:@"\n"];
        NSLog(@"totalResult:%@",totalResult);
        dispatch_async(dispatch_get_main_queue(), ^{
            _testResult.text = totalResult;
            
        });
    }
}


-(void)startRecord{
    
    [self btnAnimation];
    
    timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(btnAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
    //        _line1.hidden = NO;
    //        _line2.hidden = NO;
    
    [_recordBtn setBackgroundImage:[UIImage imageNamed:@"Voice_button_pre"] forState:UIControlStateNormal];
    
    
    isRecording = YES;
    
    
    [[KryptonManager share]startRecordWithWordset:nil withSentence:nil];
    
}


- (IBAction)menu:(id)sender {
    if (sender == self.navigationItem.rightBarButtonItem) {
        [YCXMenu setTintColor: MENU_BACKGROUND_COLOR];
        [YCXMenu setSelectedColor:[UIColor grayColor]];
        if ([YCXMenu isShow]){
            [YCXMenu dismissMenu];
        } else {
            [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 65, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
                
                
                if (item.tag == 102 && [_modelSettingDic count] == 0){
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有模型" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }
                
                else {
                
                MyPopupController *alert = [MyPopupController alertWithType:item.tag withController:self];
                
                [alert setAlertViewCornerRadius:10];
                
                alert.modelSettingDic = _modelSettingDic;
                
                [alert drawPopupViewWithType:item.tag];
                
                MyPopupAction *defaultAction = [MyPopupAction actionWithTitle:@"确定" style:ASPopupActionStyleDefault handler:^{ NSLog(@"Default"); }];
                
                [alert addActions:@[defaultAction]];
                
                [self presentViewController:alert animated:YES completion:nil];
                    
                }
                [self stopRecord];
            }];
        }
    }
}

- (NSMutableArray *)items {
    if (!_items) {
        
        // set title
        YCXMenuItem *menuTitle = [YCXMenuItem menuTitle:@"nn" WithIcon:nil];
        menuTitle.foreColor = [UIColor whiteColor];
        menuTitle.titleFont = [UIFont boldSystemFontOfSize:16.0f];
        
        //set item
        _items = [@[
                    [YCXMenuItem menuItem:@"语种设置"
                                    image:nil
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"地址设置"
                                    image:nil
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"模型选择"
                                    image:nil
                                      tag:102
                                 userInfo:@{@"title":@"Menu"}],
                    
                    [YCXMenuItem menuItem:@"参数配置"
                                    image:nil
                                      tag:107
                                 userInfo:@{@"title":@"Menu"}]
                    
                    ] mutableCopy];
    }
    return _items;
}


-(void)btnAnimation {
    
    _line1.hidden = NO;
    
    [self  performSelector:@selector(showLine2) withObject:nil afterDelay:0.25f];
    [self  performSelector:@selector(hiddenLines) withObject:nil afterDelay:0.5f];
    
}

-(void)showLine2{
    
    _line2.hidden = NO;
}

-(void)hiddenLines{
    
    _line1.hidden = YES;
    _line2.hidden = YES;
}




-(void)onReceivePartialResult:(NSString *)result{
    
    NSString *str = [self replace:result];
    
    
    
    NSLog(@"onReceivePartialResult:%@",str);
    
    tempResult = str;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _testResult.text = [NSString stringWithFormat:@"%@%@",totalResult,str];
        [_testResult scrollRangeToVisible:NSMakeRange(_testResult.text.length - 1, 1)];
        
    });
}

-(void)onReceiveFinalResult:(NSString *)str{
    
    NSString *result = [self replace:str];
    
    result = [self replacePun:result];
    
     NSLog(@"onReceiveFinalResult:%@",result);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        totalResult = [[totalResult stringByAppendingString:result]stringByAppendingString:@"\n"];
        _testResult.text = totalResult;
        
        
    });
    
}


-(void)onError:(NSString *)error{
    
    
    NSLog(@"onError:%@",error);
    
    
    if ([error isEqualToString:@"didCloseWithCode"]){
        
        
         [self stopRecord];
    }
    
    else{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误提示" message:error preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self stopRecord];
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    });
    
    
}
    
}



-(NSString *)replace:(NSString *)str
{
    
    NSString *temp = str;
    
    temp =  [temp stringByReplacingOccurrencesOfString:@"小爱" withString:@"小i"];
    temp =  [temp stringByReplacingOccurrencesOfString:@"小艾" withString:@"小i"];
    temp =  [temp stringByReplacingOccurrencesOfString:@"小哀" withString:@"小i"];
    
    return temp;
}


-(NSString *)replacePun:(NSString *)str{
    
     NSString *temp = str;
    
    if([temp hasPrefix:@"。"]  || [temp hasPrefix:@"，"] || [temp hasPrefix:@"，"] || [temp hasPrefix:@","]){
        
        temp = [temp substringFromIndex:1];
    }
    
     return temp;
}


-(void)onReceiveLanguageModel:(NSMutableDictionary *)array{
//    _modelSettingDic = array;
    
    NSLog(@"");
    
    
    wordset = [array objectForKey:@"wordSet"];
    
    
    sentence = [array objectForKey:@"sentence"];
    
    
    
}


-(void)onAudioData :(NSMutableData *)data{
    
    
    
    
    
    
}

@end

























