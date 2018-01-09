//
//  FirstViewController.m
//  VoiceDemo
//
//  Created by 寒影 on 20/06/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "FirstViewController.h"

#import <xiaoi/AskSessionResponseDomain.h>
#import <xiaoi/AskSessionController.h>
#import <xiaoi/SpeechSessionController.h>
#import <xiaoi/SpeechSessionResponseDomain.h>
#import <xiaoi/AudioPlayerController.h>
#import <xiaoi/AudioRecorderController.h>
#import <xiaoi/XISpeexCodec.h>
#import <xiaoi/SRSessionController.h>
#import <xiaoi/SRSessionResponseDomain.h>
#import <xiaoi/AudioAQEngineRecorder.h>
#import <xiaoi/AudioSessionHelper.h>
#import <xiaoi/AppInfo.h>
#import "Macros.h"
#import "TextMessageCell.h"
#import "ChatMessage.h"
#import "YCXMenu.h"
#import "MyPopupController.h"
#import "ZMChineseConvert.h"
#import "AppDelegate.h"

@interface FirstViewController()<AskSessionControllerDelegate, SRSessionControllerDelegate,SpeechSessionControllerDelegate, SpeechEndPointListener,RecordInputBufferHandlerListener,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    AudioPlayerController   *_audioPlayer;
    AudioRecorderController *_audioRecorder;
    NSMutableData           *_audioData;
    NSMutableArray          *_data;
    CGFloat viewHeight;
    NSTimer *timer;
    bool isRecording;
    
     
}

@property (weak, nonatomic) IBOutlet UITableView *contentTable;
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;
@property (nonatomic , strong) NSMutableArray *items;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIImageView *wave;
//@property (nonatomic,strong) UIImageView *bubbleView; // 气泡
//@property (nonatomic,strong) UILabel *contentLabel; // 气泡内文本

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation FirstViewController

@synthesize items = _items;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isRecording = false;
    _isSimple = true;
    
     _voice = @"ST_FEMALE";
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    _appDelegate.APPKEY = @"";
    _appDelegate.APPSECRET = @"";
    
    _appDelegate.PLATFORM = @"";
    _appDelegate.USERID = @"";
    
    _appDelegate.ASKADDR = @"";
    _appDelegate.RECADDR = @"";
    _appDelegate.TTSADDRF = @"";
    
    _appDelegate.VOICE = @"ST_FEMALE";
    
    
    viewHeight = HEIGHT_SCREEN - HEIGHT_NAVBAR - HEIGHT_STATUSBAR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillAppear) name:YCXMenuWillAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidAppear) name:YCXMenuDidAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillDisappear) name:YCXMenuWillDisappearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidDisappear) name:YCXMenuDidDisappearNotification object:nil];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    [self setHidesBottomBarWhenPushed:YES];
    
    [self.contentTable setFrame:CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, WIDTH_SCREEN, viewHeight - HEIGHT_TABBAR-50)];
    [self.contentTable setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    [self.contentTable setTableFooterView:[UIView new]];
    self.contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentTable registerClass:[TextMessageCell class] forCellReuseIdentifier:@"TextMessageCell"];
    [self.contentTable setDataSource:self];
    [self.contentTable setDelegate:self];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    UIImage *bgImage = [UIImage imageNamed:@"voice_bg.png"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    _audioPlayer    = [[AudioPlayerController alloc] initWithEngineType:AudioPlayerEngine_Type_AQ];
    _audioRecorder  = [[AudioRecorderController alloc] initWithEngineType:AudioRecordEngine_Type_AQ];
    
    [AppInfo shareInstance].isActive = false;
    _audioData = [NSMutableData data];
    
    _line1.hidden = YES;
    _line2.hidden = YES;
    
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
    
    _line2.translatesAutoresizingMaskIntoConstraints = NO;
    _line1.translatesAutoresizingMaskIntoConstraints = NO;
    _recordBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint constraintWithItem:_line2
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:-PADDING].active = YES;
    
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
    
    [NSLayoutConstraint constraintWithItem:_recordBtn
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    _contentTable.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint constraintWithItem:_contentTable
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.line2
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:-PADDING].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_contentTable
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:WIDTH_SCREEN].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_contentTable
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    CGFloat navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    [NSLayoutConstraint constraintWithItem:_contentTable
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:navigationHeight + 2*PADDING].active = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    if([_audioRecorder isRecording]){
        [_audioRecorder stop];
    }
    
    if([_audioPlayer isPlaying]){
        [_audioPlayer stop];
    }
}


- (IBAction)record:(id)sender {
    
    if(isRecording){
        
        //停止录音
        
        [self stopRecord];
        
        NSData *rawData = _audioRecorder.data;
        XISpeexCodec *codec = [[XISpeexCodec alloc] initWithMode:0];
        NSData *encodeData = [codec encode:rawData];
        [self demoSRSession:encodeData];
    }
    else {
        //开始录音
         [self btnAnimation];
         timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(btnAnimation) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
        
        [_audioPlayer stop];
        isRecording = true;
//        _line1.hidden = NO;
//        _line2.hidden = NO;
        
          [_recordBtn setBackgroundImage:[UIImage imageNamed:@"Voice_button_pre"] forState:UIControlStateNormal];
        [self startRecord:YES];
    }
}

- (void)SRSessionController:(SRSessionController *)ctrl didFinished:(SRSessionResponseDomain *)domain
{
    NSLog(@"SRSession content:%@", domain.textContent);
}

- (void)SRSessionController:(SRSessionController *)ctrl failed:(NSError *)error
{
    NSLog(@"SRSession Error:%@", error);
    
}


- (void)askSessionController:(AskSessionController *)ctrl didFinished:(AskSessionResponseDomain *)domain
{
    NSLog(@"askSessionController didFinished");
}

- (void)askSessionController:(AskSessionController *)ctrl failed:(NSError *)error
{
    NSLog(@"askSessionController  failed");
}

- (void)menuWillAppear {
    
}

- (void)menuDidAppear {
    
}

- (void)menuWillDisappear {
}

- (void)menuDidDisappear {
    
}

- (void)startRecord:(BOOL)hasEndPoint
{
    [AudioSessionHelper setupWhenWillBeginRecord];
    AudioAQEngineRecorder *recorder = (AudioAQEngineRecorder *)_audioRecorder.engine;
    NSDictionary *dic = @{@"sample_rate" : @8000, @"num_channels" : @1};
    recorder.inputBufferHandlerListener = self;
    [_audioRecorder prepareRecordToBuf:dic isSupportEndpointDetection:YES];
    recorder.speechEndPointListener = self;
    [_audioRecorder record];
}


- (BOOL)onSpeechEndPointActiveBegin:(NSInteger)beginLength
{
    //    NSLog(@"BeginBreak:%d", beginLength);
    return YES;
}

- (BOOL)onSpeechEndPointActiveEnd:(NSInteger)endLength
{
    
    [self stopRecord];
    
    [AppInfo shareInstance].key = @"QdkyupmTq42500upmTq";
    [AppInfo shareInstance].secret = @"soB129d06crMEVDMg88v";
    [AppInfo shareInstance].isActive = true;
    
    NSData *rawData = _audioRecorder.data;
    XISpeexCodec *codec = [[XISpeexCodec alloc] initWithMode:0];
    NSData *encodeData = [codec encode:rawData];
    
    SRSessionParams * param = [[SRSessionParams alloc] init];
    param.baseURL = @"http://vcloud.xiaoi.com";
    param.audioBitsPerSample = 16;
    param.audioRate = 16000;
    param.audioEncode = @"speex-wb;7";
    param.retTextEncode = @"utf-8";
    param.SREngineType = SRET_XIAOI_IREC;
    param.audioData = encodeData;
    param.platform = @"ioscloud";
    
    SRSessionController *ctrl = [[SRSessionController alloc] init];
    
    [ctrl begin:param
        success:
     ^(SRSessionParams *params, SRSessionResponseDomain *domain)
     {
         NSString *msg = domain.textContent;
         
         if(msg != nil && ![msg isEqualToString:@""])
         {
             NSLog(@"msg:%@", msg);
             if(!_isSimple){
//                 msg = [ZMChineseConvert convertSimplifiedToTraditional:msg];
             }
             
             ChatMessage *message = [[ChatMessage alloc] init];
             message.isRight = YES;
             message.text = msg;
             [self receivedMessage:message];
             [self AskSession:msg];
         }
         
     }
         failed:
     ^(SRSessionParams *params, NSError *error)
     {
         NSLog(@"SRSession is failed");
     }];
    return  YES;
}

- (void)stopRecord
{
    
    [timer invalidate];
    timer = nil;
    isRecording = false;
    _line1.hidden = YES;
    _line2.hidden = YES;
    [_recordBtn setBackgroundImage:[UIImage imageNamed:@"voice_button_nol"] forState:UIControlStateNormal];
    
    if(_audioRecorder.engine.isRecording)
    {
        [AudioSessionHelper teardownWhenFinishedRecord];
        [_audioRecorder stop];
    }
}


- (void)demoSRSession:(NSData *) encodeData
{
    //从语音数据到文字
//    [AppInfo shareInstance].key = @"QdkyupmTq42500upmTq";
//    [AppInfo shareInstance].secret = @"soB129d06crMEVDMg88v";
    
    [AppInfo shareInstance].key = _appDelegate.APPKEY;
    [AppInfo shareInstance].secret = _appDelegate.APPSECRET;
    
    if (!(_appDelegate.APPKEY.length > 0)){
        
          [AppInfo shareInstance].key = APP_KEY;
        
    }
    
    if (!(_appDelegate.APPSECRET.length > 0)){
        
        [AppInfo shareInstance].secret = APP_SECRET;
        
    }
    
    [AppInfo shareInstance].isActive = true;
    
    SRSessionParams * param = [[SRSessionParams alloc] init];
    param.baseURL = _appDelegate.RECADDR;
    
    if (!(_appDelegate.RECADDR.length > 0)){
         param.baseURL =REC_ADDR;
    }
    
    param.audioBitsPerSample = 16;
    param.audioRate = 16000;
    param.audioEncode = @"speex-wb;7";
    param.retTextEncode = @"utf-8";
    param.SREngineType = SRET_XIAOI_IREC;
    
    //    param.audioData = _audioData;
    param.audioData = encodeData;
    param.platform = _appDelegate.PLATFORM;
    param.userID = _appDelegate.USERID;
    
    if (!(_appDelegate.PLATFORM.length > 0)){
        param.platform = PLAT_FORM;
    }
    
    if (!(_appDelegate.USERID.length > 0)){
        param.userID = USER_ID;
    }
    
    SRSessionController *ctrl = [[SRSessionController alloc] init];
    
    [ctrl begin:param
        success:
     ^(SRSessionParams *params, SRSessionResponseDomain *domain)
     {
         NSString *msg = domain.textContent;
         if(msg != nil && ![msg isEqualToString:@""])
         {
             NSLog(@"msg:%@", msg);
             
             if(!_isSimple){
//                 msg = [ZMChineseConvert convertSimplifiedToTraditional:msg];
             }
             
             ChatMessage *message = [[ChatMessage alloc] init];
             message.isRight = YES;
             message.text = msg;
             
             [self receivedMessage:message];
             [self AskSession:msg];
         }
     }
     
         failed:
     ^(SRSessionParams *params, NSError *error)
     {
         NSLog(@"SRSession is failed");
         
     }];
}

- (void)AskSession:(NSString *) text
{
    NSString *format = @"json";
    NSString *urlStr =[NSString stringWithFormat:@"%@/ask?format=%@&question=%@",_appDelegate.ASKADDR,format,text];
    
    if(!(_appDelegate.ASKADDR.length > 0)){
        urlStr =[NSString stringWithFormat:@"%@/ask?format=%@&question=%@",ASK_ADDR,format,text];
    }
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:[self returnFormatString:urlStr]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if(received != nil){
        id json = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
        
        NSString *result = [json objectForKey:@"content"];
        NSLog(@"result:%@", result);
        ChatMessage *message = [[ChatMessage alloc] init];
        message.isRight = NO;
        message.text = result;
        [self receivedMessage:message];
        [self speechSession:result];
    }
}

- (void)speechSession :(NSString *)text
{
    //从文字到语音，并播放
    
    SpeechSessionParams *params = [[SpeechSessionParams alloc] init];
    
    [AppInfo shareInstance].key = @"QdkyupmTq42500upmTq";
    [AppInfo shareInstance].secret = @"soB129d06crMEVDMg88v";
    [AppInfo shareInstance].isActive = true;
    
    params.baseURL = _appDelegate.TTSADDRF;
    
    if(!(_appDelegate.TTSADDRF.length > 0)){
        
        params.baseURL = SYNTH_ADDR;
    }
    
    /* audio属性目前不能改 */
    params.audioBitsPerSample = 16;
    params.audioEncode = @"speex-nb;7";
    params.audioRate = 8000;
    
    params.textEncode = @"utf-8";
//    params.speechType = ST_FEMALE; //男女声切换
    
    if([_voice isEqual:@"ST_FEMALE"]){
        params.speechType = ST_FEMALE;
    }
    
    else {
        params.speechType = ST_MALE;
    }
    
    params.content = text;
    params.platform = @"ioscloud";
    
    SpeechSessionController *ctrl = [[SpeechSessionController alloc] init];
    [ctrl begin:params delegate:self];
    
}


- (void)speechSessionController:(SpeechSessionController *)ctrl didFinished:(SpeechSessionResponseDomain *)domain
{
    
    NSData *encodeAudioData = domain.audioData;
    if(encodeAudioData != nil && [encodeAudioData length] > 0)
    {
        NSDictionary *dic = @{@"sample_rate" : @8000, @"num_channels" : @1};
        
        [AudioSessionHelper setupWhenWillBeginRecord];
        [AudioSessionHelper teardownWhenFinishedRecord];
        
        XISpeexCodec *speexCodec = [[XISpeexCodec alloc] initWithMode:0];
        NSData *rawDate = [speexCodec decode:encodeAudioData];
        
        [_audioPlayer stop];
        if (!isRecording){
            [_audioPlayer preparePlay:rawDate format:dic];
            [_audioPlayer play:NO];
        }
    }
}

- (void)speechSessionController:(SpeechSessionController *)ctrl failed:(NSError *)error
{
    NSLog(@"SpeechSession Error:%@", error);
}


-(NSString *)returnFormatString:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@" " withString:@" "];
}

- (void)onRecordInputBufferHandler:(void *)buf length:(NSUInteger)length {
    [_audioData appendBytes:buf length:length];
    if (!_audioRecorder.engine.isRecording) {
        
        [_audioData setData:[NSMutableData data]];
    }
}


- (IBAction)pauseRecord:(id)sender {
    
    _line1.hidden = YES;
    _line2.hidden = YES;
    
    [_audioRecorder pause];
}

- (IBAction)touchDown:(id)sender {
    
    
    _line1.hidden = NO;
    _line2.hidden = NO;
    
    [self startRecord:NO];
}

- (IBAction)touchUp:(id)sender {
    
    _line1.hidden = YES;
    _line2.hidden = YES;
    [self stopRecord];
    
    NSData *rawData = _audioRecorder.data;
    XISpeexCodec *codec = [[XISpeexCodec alloc] initWithMode:0];
    NSData *encodeData = [codec encode:rawData];
    [self demoSRSession:encodeData];
    
}

- (void) addNewMessage:(ChatMessage *)message
{
    [self.data addObject:message];
    [self.contentTable reloadData];
    
    //    [ self AskSession:message.text];
}

- (NSMutableArray *) data
{
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

- (void) scrollToBottom
{
    if (_data.count > 2) {
        [self.contentTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_data.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)contentTable
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)contentTable numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)contentTable cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMessage *message = [_data objectAtIndex:indexPath.row];
    
    id cell = [contentTable cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[TextMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextMessageCell"];
    }
    
    //     id cell = [self.contentTable dequeueReusableCellWithIdentifier:@"TextMessageCell"];
    [cell setMessage:message];
    //      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)contentTable heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMessage *message = [_data objectAtIndex:indexPath.row];
    
    CGFloat cellHeight =  message.cellHeight;
    
    return cellHeight+PADDING;
    
}

- (void)  receivedMessage:(ChatMessage *)message
{
    [self addNewMessage:message];
    [self scrollToBottom];
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
                
                MyPopupAction *defaultAction = [MyPopupAction actionWithTitle:@"确定" style:ASPopupActionStyleDefault handler:^{ NSLog(@"Default"); }];
                
                [alert addActions:@[defaultAction]];
                alert.presentStyle = ASPopupPresentStyleSystem;
                [self presentViewController:alert animated:YES completion:nil];
                [self stopRecord];
            }];
        }
    }
}


- (NSMutableArray *)items {
    if (!_items) {
        
        YCXMenuItem *menuTitle = [YCXMenuItem menuTitle:@"nn" WithIcon:nil];
        menuTitle.foreColor = [UIColor whiteColor];
        menuTitle.titleFont = [UIFont boldSystemFontOfSize:16.0f];
        
        _items = [@[
                    [YCXMenuItem menuItem:@"声音选择"
                                    image:nil
                                      tag:105
                                 userInfo:@{@"title":@"Menu"}],
                    
                    [YCXMenuItem menuItem:@"参数配置"
                                    image:nil
                                      tag:103
                                 userInfo:@{@"title":@"Menu"}],
                    
                    [YCXMenuItem menuItem:@"地址配置"
                                    image:nil
                                      tag:106
                                 userInfo:@{@"title":@"Menu"}]
//                    [YCXMenuItem menuItem:@"简繁转换"
//                                    image:nil
//                                      tag:104
//                                 userInfo:@{@"title":@"Menu"}]
                    
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


@end
