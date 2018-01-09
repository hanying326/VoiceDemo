//
//  ThirdViewController.m
//  VoiceDemo
//
//  Created by 寒影 on 23/06/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThirdViewController.h"
#import <xiaoi/SpeechSessionController.h>
#import <xiaoi/SpeechSessionResponseDomain.h>
#import <xiaoi/AudioPlayerController.h>
#import <xiaoi/AudioRecorderController.h>
#import <xiaoi/XISpeexCodec.h>
#import <xiaoi/AudioAQEngineRecorder.h>
#import <xiaoi/AudioSessionHelper.h>
#import <xiaoi/AppInfo.h>
#import "Macros.h"
#import "YCXMenu.h"
#import "MyPopupController.h"
#import "AppDelegate.h"
#import "TextToSpeech.h"


#import <CFNetwork/CFNetwork.h>

#import <AFNetworking/AFNetworking.h>

@interface ThirdViewController()< SpeechSessionControllerDelegate,UITextViewDelegate,TTSDelegate>
{
    AudioPlayerController   *_audioPlayer;
    bool isPlaying;
    NSString *voiceName;
    UISwipeGestureRecognizer * recognizer;
    NSString *defaultString;
}

@property (nonatomic , strong) NSMutableArray *items;
@property (nonatomic , strong) UITextView *inputView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIImageView *waveImage;
@property (nonatomic , strong) AppDelegate *appDelegate;

@property (nonatomic , strong) NSInputStream *in;
@property (nonatomic,strong)UILabel *placeHolder;
@property (nonatomic,strong)NSMutableData *voiceData;
@property (nonatomic,strong)TextToSpeech *tts;
@property (nonatomic,strong)NSMutableArray *tempSpeechData;
@property NSInteger currentAudioIndex;

- (void)speechSession;  //语音转化系统Session(将文字转换成声音)

@end

@implementation ThirdViewController
@synthesize items = _items;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _voice = @"ST_FEMALE";
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.title = @"语音合成";
    defaultString = @"小i机器人：全球领先的智能机器人平台和架构提供者";
    
    if (_appDelegate.VOICEFORTTS.length == 0){
        
        _appDelegate.VOICEFORTTS = @"Bin-Bin";
        
    }
    
    _currentAudioIndex = 0;
    
    _tempSpeechData = [[NSMutableArray alloc]init];
    
    [self.view setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillAppear) name:YCXMenuWillAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidAppear) name:YCXMenuDidAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillDisappear) name:YCXMenuWillDisappearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidDisappear) name:YCXMenuDidDisappearNotification object:nil];
    
    //   [ input setFrame:CGRectMake(PADDING, PADDING + 44, WIDTH_SCREEN-2*PADDING, HEIGHT_SCREEN-5*PADDING)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_inputView.layer setCornerRadius:10];
    
    CGSize labelSize = {0, 0};
    NSString *showStr = [NSString stringWithFormat:@"%@(请输入需要TTS的内容)",defaultString];
    
    labelSize = [showStr sizeWithFont:[UIFont systemFontOfSize:14]
                 
                    constrainedToSize:CGSizeMake(200, 5000)
                        lineBreakMode:NSLineBreakByCharWrapping];
    
    _placeHolder = [[UILabel alloc]initWithFrame:CGRectMake(1, 1, 288, 50)];
    _placeHolder.enabled = NO;
    _placeHolder.numberOfLines = 0;
    
    _placeHolder.lineBreakMode = NSLineBreakByCharWrapping;
    [_placeHolder setText:@"小i机器人：全球领先的智能机器人平台和架构提供者 \n (请输入需要TTS的内容)"];
    _placeHolder.font =  [UIFont systemFontOfSize:15];
    _placeHolder.textColor = [UIColor lightGrayColor];
    
    _placeHolder.frame = CGRectMake(_placeHolder.frame.origin.x, _placeHolder.frame.origin.y, _placeHolder.frame.size.width, labelSize.height+20);//保持原来Label的位置和宽度，只是改变高度。
    
    [self.inputView addSubview:_placeHolder];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    UIImage *bgImage = [UIImage imageNamed:@"voice_bg.png"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    _audioPlayer  = [[AudioPlayerController alloc] initWithEngineType:AudioPlayerEngine_Type_AQ];
    
    [AppInfo shareInstance].isActive = false;
    [_inputView setDelegate:self];
    
    _btn.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint constraintWithItem:_btn
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_btn
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:-PADDING].active = YES;
    
    CGFloat navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    _inputView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint constraintWithItem:_inputView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:navigationHeight + 2*PADDING].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_inputView
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:PADDING].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_inputView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.btn
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:-PADDING].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_inputView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:-PADDING].active = YES;
    
    _waveImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint constraintWithItem:_waveImage
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:WIDTH_SCREEN].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_waveImage
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0].active = YES;
    
    _btn.userInteractionEnabled = YES;
    //初始化一个手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    //为图片添加手势
    [_btn addGestureRecognizer:singleTap];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.view addGestureRecognizer:recognizer];
    
    _tts = [[TextToSpeech alloc]init];
    
    _tts.delegate = self;
    
    
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        [_inputView resignFirstResponder];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [_audioPlayer stop];
    
    _audioPlayer = nil;
}

-(void)singleTapAction
{
    if(isPlaying){
        //结束播放
        [_audioPlayer stop];
        [_btn setBackgroundImage:[UIImage imageNamed:@"tts_button_nol"] forState:UIControlStateNormal];
        isPlaying = false;
    }
    
    else {
        //开始播放
        
        NSString *ttsText = _inputView.text;
        
        if(_inputView.text.length == 0){
            ttsText = defaultString;
        }
        
                     [self speechSession:ttsText];
        
        
        //        [self testTTS:ttsText];
        
        
//        [_tts testTTS:ttsText];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void)menuWillAppear {
    
}

- (void)menuDidAppear {
}

- (void)menuWillDisappear {
    
}

- (void)menuDidDisappear {
    
}

- (void)speechSessionController:(SpeechSessionController *)ctrl didFinished:(SpeechSessionResponseDomain *)domain
{
    
    NSData *encodeAudioData = domain.audioData;
    if(encodeAudioData != nil && [encodeAudioData length] > 0)
    {
        
        isPlaying = true;
        [_btn setBackgroundImage:[UIImage imageNamed:@"tts_button_pre"] forState:UIControlStateNormal];
        
        NSDictionary *dic = @{@"sample_rate" : @8000, @"num_channels" : @1};
        
        [AudioSessionHelper setupWhenWillBeginRecord];
        [AudioSessionHelper teardownWhenFinishedRecord];
        
        XISpeexCodec *speexCodec = [[XISpeexCodec alloc] initWithMode:0];
        NSData *rawDate = [speexCodec decode:encodeAudioData];
        [_audioPlayer preparePlay:rawDate format:dic];
        //        [_audioPlayer play:NO];
        
        [_audioPlayer play:NO finished:^(id content) {
            
            [self  performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
        }];
    }
}

-(void)delayMethod{
    isPlaying =false;
    [_btn setBackgroundImage:[UIImage imageNamed:@"tts_button_nol"] forState:UIControlStateNormal];
}

- (void)speechSessionController:(SpeechSessionController *)ctrl failed:(NSError *)error
{
    NSLog(@"SpeechSession Error:%@", error);
}

- (void)speechSession:(NSString *)text
{
    //从文字到语音，并播放
    SpeechSessionParams *params = [[SpeechSessionParams alloc] init];
    
    [AppInfo shareInstance].key = @"QdkyupmTq42500upmTq";
    [AppInfo shareInstance].secret = @"soB129d06crMEVDMg88v";
    [AppInfo shareInstance].isActive = true;
    
    params.baseURL = _appDelegate.TTSADDR;
    
    if(!(_appDelegate.TTSADDR.length > 0)){
        params.baseURL = TTS_ADDR;
    }
    
    /* audio属性目前不能改 */
    params.audioBitsPerSample = 16;
    params.audioEncode = @"speex-nb;7";
    params.audioRate = 8000;
    
    params.textEncode = @"utf-8";
    params.speechType = ST_FEMALE;
    
    if([_voice isEqual:@"ST_MALE"]){
        params.speechType = ST_MALE;
    }
    
    params.content = text;
    params.platform = @"ioscloud";
    
    SpeechSessionController *ctrl = [[SpeechSessionController alloc] init];
    [ctrl begin:params delegate:self];
}

-(void)changeVoice:(NSString *)name{
    
}

- (void) textViewDidChange:(UITextView *)textView{
    if ([_inputView.text length] == 0) {
        [_placeHolder setHidden:NO];
    }else{
        [_placeHolder setHidden:YES];
    }
}

-(BOOL)textView:(UITextView *)input shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [input resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (IBAction)menu:(id)sender {
    
    if (sender == self.navigationItem.rightBarButtonItem) {
        [YCXMenu setTintColor: MENU_BACKGROUND_COLOR];
        [YCXMenu setSelectedColor:[UIColor grayColor]];
        if ([YCXMenu isShow]){
            [YCXMenu dismissMenu];
        } else {
            [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 65, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
                
                MyPopupController *alert = [MyPopupController alertWithType:item.tag withController:self];
                alert.alertViewCornerRadius = 10;
                [alert drawPopupViewWithType:item.tag];
                [self presentViewController:alert animated:YES completion:nil];
                
                [_audioPlayer stop];
                [_btn setBackgroundImage:[UIImage imageNamed:@"tts_button_nol"] forState:UIControlStateNormal];
                isPlaying = false;
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
                    [YCXMenuItem menuItem:@"声音选择"
                                    image:nil
                                      tag:105
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"地址设置"
                                    image:nil
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}]
                    
                    ] mutableCopy];
    }
    return _items;
}

-(void)onReceiveVoiceData:(NSData * )data{
    
    NSLog(@"onReceiveVoiceData-----%d",data.length);
    
    [_tempSpeechData addObject:data];
    
    if (!isPlaying){
        
        isPlaying = true;
        [_btn setBackgroundImage:[UIImage imageNamed:@"tts_button_pre"] forState:UIControlStateNormal];
        [self playAudio];
    }
}


-(void)playAudio{
    
    if ([_tempSpeechData count] > _currentAudioIndex ){
        
        NSData *data = [_tempSpeechData objectAtIndex:_currentAudioIndex];
        
        if(data != nil && [data length] > 0)
        {
            
            NSDictionary *dic = @{@"sample_rate" : @8000, @"num_channels" : @1};
            [AudioSessionHelper setupWhenWillBeginRecord];
            [AudioSessionHelper teardownWhenFinishedRecord];
            
            XISpeexCodec *speexCodec = [[XISpeexCodec alloc] initWithMode:0];
            NSData *rawDate = [speexCodec decode:data];
            [_audioPlayer preparePlay:rawDate format:dic];
            //        [_audioPlayer play:NO];
            
            [_audioPlayer play:NO finished:^(id content) {
                
                //            [_tempSpeechData removeObjectAtIndex:_currentAudioIndex];
                
                if ([_tempSpeechData count] > 0){
                    
                    _currentAudioIndex++;
                    [self playAudio];
                }
                
                else {
                    [self  performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
                }
            }];
        }
    }
}


-(void)testTTS:(NSString *)str {
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/synth?platform=%@&userId=%@",TTS_ADDR,PLAT_FORM,USER_ID];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    
    [request addValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [request addValue:@"speex" forHTTPHeaderField:@"X-AUE"];
    [request addValue:@"utf-8" forHTTPHeaderField:@"X-TXE"];
    [request addValue:@"Bin-Bin" forHTTPHeaderField:@"X-AUT"];
    [request addValue:@"audio/L16;rate=8000" forHTTPHeaderField:@"X-AUF"];
    [request addValue:[NSString stringWithFormat:@"%lu", jsonData.length] forHTTPHeaderField:@"Content-length"];
    request.timeoutInterval = 5;
    
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    
    _in = nil;
    _in =  [NSInputStream inputStreamWithData:jsonData];
    //    _in.delegate  = self;
    [_in open];
    //    [request setHTTPBodyStream:_in];
    //      [request.HTTPBodyStream copy];
    
    [request setHTTPBody:jsonData];
    
    NSURLConnection *connection  = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [connection start];
    
    //        NSOperationQueue *queue = [NSOperationQueue mainQueue];
    //        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    //            NSLog(@"返回数据-%@",data);
    //        }];
    
}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"producer stream opened");
        } break;
        case NSStreamEventHasBytesAvailable: {
            // 这里写入buffer
            NSLog(@"NSStreamEventHasBytesAvailable");
        }break;
            
        case NSStreamEventHasSpaceAvailable:{
            NSLog(@"NSStreamEventHasSpaceAvailable");
        }break;
    }}

-(void)testAfNetWork:(NSString *)str {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/synth?platform=%@&userId=%@",TTS_ADDR,PLAT_FORM,USER_ID];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request addValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [request addValue:@"speex" forHTTPHeaderField:@"X-AUE"];
    [request addValue:@"utf-8" forHTTPHeaderField:@"X-TXE"];
    [request addValue:@"Susan" forHTTPHeaderField:@"X-AUT"];
    [request addValue:@"audio/L16;rate=8000" forHTTPHeaderField:@"X-AUF"];
    [request addValue:[NSString stringWithFormat:@"%lu", jsonData.length] forHTTPHeaderField:@"Content-length"];
    
    _in = nil;
    
    _in =  [NSInputStream inputStreamWithData:jsonData];
    
    [_in open];
    [request setHTTPBodyStream:_in];
    
    //    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:jsonData progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    //        if (error) {
    //            NSLog(@"Error: %@", error);
    //        } else {
    //            NSLog(@"Success: %@ %@", response, responseObject);
    //        }
    //    }];
    //    [uploadTask resume];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil  destination:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    [task resume];
}

@end

























