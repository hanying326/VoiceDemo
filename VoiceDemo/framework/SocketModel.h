//
//  SocketModel.h
//  VoiceDemo
//
//  Created by 寒影 on 04/07/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//
#ifndef SocketModel_h
#define SocketModel_h
#endif /* SocketModel_h */



#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
#import "SecondViewController.h"
#import "KryptonEntity.h"

@interface SocketModel : NSObject


@property (nonatomic,strong)NSString *wsUrl;



+ (instancetype)share;
- (void)connect;
- (void)disConnect;
- (void)sendMsg:(NSString *)msg;
- (void)sendAudio:(id )msg;

- (NSString *)model2JSON:(KryptonEntity *)kryptonEntity;


-(void)changeWsUrl:(NSString *)url;
-(void)changeModelSetting : (NSMutableArray *)loadInfos;
-(void) setController:(UIViewController *)controller;

@end










































