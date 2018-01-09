//
//  TextToSpeech.h
//  VoiceDemo
//
//  Created by 寒影 on 12/09/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#ifndef TextToSpeech_h
#define TextToSpeech_h


#endif /* TextToSpeech_h */


@protocol TTSDelegate <NSObject>

-(void)onReceiveVoiceData:(NSData * )data;


@end

@interface TextToSpeech : NSObject<NSURLConnectionDataDelegate>


@property (nonatomic, weak) id <TTSDelegate> delegate;

-(void)testTTS:(NSString *)str ;


@end
