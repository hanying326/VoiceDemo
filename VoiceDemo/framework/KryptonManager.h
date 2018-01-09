//
//  KryptonManager.h
//  VoiceDemo
//
//  Created by 寒影 on 19/09/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#ifndef KryptonManager_h
#define KryptonManager_h

#endif /* KryptonManager_h */


@protocol KryptonDelegate <NSObject>

@optional
-(void)onReceiveLanguageModel:(NSMutableDictionary *)array;

-(void)onReceivePartialResult:(NSString *)result;

-(void)onReceiveFinalResult:(NSString *)result;

-(void)onError:(NSString *)error;

-(void)onAudioData :(NSMutableData *)data;

@end

@interface KryptonManager:NSObject

@property (nonatomic ,strong) NSString * appKey;
@property (nonatomic ,strong) NSString * appSecret;
@property (nonatomic ,strong) NSString * url;
@property (nonatomic ,strong) NSString * languageType;

@property (nonatomic, weak) id <KryptonDelegate> delegate;

+ (instancetype)share;

-(void) getLanguageModel;

-(void)startRecordWithWordset :(NSMutableArray *)wordsets  withSentence :(NSMutableArray *)sentences;

-(void)stopRecord;


@end


