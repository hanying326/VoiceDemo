//
//  XiaoiKrypton.h
//  VoiceDemo
//
//  Created by 寒影 on 23/08/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#ifndef XiaoiKrypton_h
#define XiaoiKrypton_h

#endif /* XiaoiKrypton_h */

@protocol KryptonDelegate <NSObject>

@optional

-(void)onReceiveObject:(NSDictionary *)result;
-(void)onReceivePartialResult:(NSString *)result;
-(void)onReceiveFinalResult:(NSString *)result;

@end

@interface XiaoiKrypton : NSObject

@property (nonatomic ,strong) NSString *appKey;
@property (nonatomic ,strong) NSString *appSecret;
@property (nonatomic ,strong) NSString *wsUrl;
@property (nonatomic, weak) id <KryptonDelegate> delegate;



-(void)getLanguageModel;
-(void)startRecord;
-(void)stopRecord;


@end
