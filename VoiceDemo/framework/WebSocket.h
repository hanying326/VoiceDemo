//
//  WebSocket.h
//  VoiceDemo
//
//  Created by 寒影 on 14/08/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#ifndef WebSocket_h
#define WebSocket_h

#endif /* WebSocket_h */
#import "SRWebSocket.h"
#import "KryptonManager.h"


@interface WebSocket :NSObject

@property (nonatomic,strong)NSMutableArray *objects;
//@property (nonatomic, weak) id <KryptonDelegate> delegate;
@property (nonatomic,strong)KryptonManager *manager;

@property (nonatomic,assign)bool onlyForGetObjects;

//@property (nonatomic,strong)NSMutableDictionary *choosenLanguageModel;

@property (nonatomic,strong)NSMutableArray *choosenWordSets;
@property (nonatomic,strong)NSMutableArray *choosenSentences;


+ (instancetype)share;

-(void)initSocket;
-(void)sendMsg:(NSString *)msg;
-(void)changeModelSetting : (NSMutableArray *)loadInfos;
-(void)sendAudio:(id)audio;
-(void)closeSocket;
-(void)startSendAudio;
-(void)stopSendAudio;

@end















