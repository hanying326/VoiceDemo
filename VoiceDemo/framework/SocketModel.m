//
//  SocketModel.m
//  VoiceDemo
//
//  Created by 寒影 on 04/07/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketModel.h"
#import "SRWebSocket.h"
#import "LoadInfo.h"
#import "KryptonEntity.h"
#import "MJExtension.h"
#import "SecondViewController.h"
#import "AppDelegate.h"

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


@interface SocketModel()<SRWebSocketDelegate>
{
    SRWebSocket * webSocket;
    NSTimer * heartBeat;
    NSTimeInterval reConnecTime;
//    NSString * wsUrl;
    NSString *modelStr;
    NSString *language;
}

@property (nonatomic,strong)NSMutableArray *loadInfos;

@property (nonatomic,strong)UIViewController *controller;

@property (nonatomic,strong)AppDelegate *appDelegate;


@end

@implementation SocketModel


+(instancetype)share
{
    static dispatch_once_t onceToken;
    static SocketModel * instance=nil;
    
    dispatch_once(&onceToken,^{
        instance=[[self alloc]init];
        [instance initSocket];
    });
    return instance;
}


-(void)initSocket
{
    if (webSocket) {
        return;
    }
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    _wsUrl = @"ws://172.16.9.214:6001/websocket/16000";
    
    _appDelegate.WSADDR = _wsUrl;
    
    NSString *str = [self model2JSON:nil];
    
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",_wsUrl,str];
    
    webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:url]];
//    webSocket.delegate=(SecondViewController *)_controller;
    webSocket.delegate = self;
    
    
    //  设置代理线程queue
    NSOperationQueue * queue=[[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount=1;
    [webSocket setDelegateOperationQueue:queue];
    
    //  连接
    [webSocket open];
}

-(void)reInitSocket{
    
    
    if (webSocket) {
        [webSocket close];
        webSocket = nil;
    }
    
       NSString *str;
    if([_loadInfos count ] > 0){
        
         KryptonEntity *kryptonEntity = [[KryptonEntity alloc]init];
        
        kryptonEntity.language = @"普通话";
        kryptonEntity.loadInfos = _loadInfos;
         str = [self model2JSON:kryptonEntity];
    }
    
    else {
         str = [self model2JSON:nil];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",_wsUrl,str];
    webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:url]];
//    webSocket.delegate=(SecondViewController *)_controller;
    
    NSOperationQueue * queue=[[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount=1;
    [webSocket setDelegateOperationQueue:queue];
    [webSocket open];
}

//   建立连接
-(void)connect
{
    [self initSocket];
}

//   断开连接
-(void)disConnect
{
    if (webSocket) {
        [webSocket close];
        webSocket=nil;
    }
}

//  重连机制
-(void)reConnect
{
    [self disConnect];
    
    //  超过一分钟就不再重连   之后重连5次  2^5=64
    if (reConnecTime>64) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnecTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        webSocket=nil;
        [self initSocket];
    });
    
    //   重连时间2的指数级增长
    if (reConnecTime == 0) {
        reConnecTime =2;
    }else{
        reConnecTime *=2;
    }
}


-(void)sendMsg:(NSString *)msg
{
    [webSocket send:msg];
}


-(void)sendAudio:(id)msg
{
    [webSocket send:msg];
}


- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"服务器返回的信息:%@",message);
}

-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"连接失败。。。。。%@",error);
    [self reConnect];
}

-(void)webSocketDidOpen:(SRWebSocket *)webSocket
{
//    NSLog(@"连接成功");
    //    [self initHearBeat];
}



- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    NSLog(@"didCloseWithCode");
}


//   初始化心跳
-(void)initHearBeat
{
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        
        __weak typeof (self) weakSelf=self;
        
        heartBeat=[NSTimer scheduledTimerWithTimeInterval:3*60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"heart");
            
            [weakSelf sendMsg:@"heartbeat"];
        }];
        [[NSRunLoop currentRunLoop] addTimer:heartBeat forMode:NSRunLoopCommonModes];
    })
}

//   取消心跳
-(void)destoryHeartBeat
{
    dispatch_main_async_safe(^{
        if (heartBeat) {
            [heartBeat invalidate];
            heartBeat=nil;
        }
    })
}


- (NSString *)model2JSON :(KryptonEntity *)kryptonEntity{
    
    if(kryptonEntity == nil){
        kryptonEntity = [[KryptonEntity alloc]init];
    }
    
    NSDictionary *kryptoDict = kryptonEntity.mj_keyValues;
    NSString *base64Encoded  = nil;
    
    if([NSJSONSerialization isValidJSONObject:kryptoDict]){
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:kryptoDict options:NSJSONWritingPrettyPrinted error:&error];
        
        base64Encoded = [jsonData base64EncodedStringWithOptions:0];
    }
    
    return base64Encoded;
}

-(void)changeWsUrl:(NSString *)url{
    
    _wsUrl = url;
    [self reInitSocket];
}

-(SRWebSocket *)getSocket {
    return webSocket;
}

-(void)changeModelSetting : (NSMutableArray *)loadInfos{
    
    _loadInfos = loadInfos;
    [self reInitSocket];
}

-(void) setController:(UIViewController *)controller {
    
    _controller = controller;
    
//    webSocket.delegate = (SecondViewController *)_controller;
    
}

@end

