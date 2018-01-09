//
//  TextToSpeech.m
//  VoiceDemo
//
//  Created by 寒影 on 12/09/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextToSpeech.h"
#import "Macros.h"
#import "AppDelegate.h"

@interface TextToSpeech()


@property (nonatomic,strong)NSMutableData *voiceData;

@property (nonatomic , strong) NSInputStream *in;

@property (nonatomic , strong) AppDelegate *appDelegate;
@end



@implementation TextToSpeech



-(void)testTTS:(NSString *)str {
    
      _appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *speaker = _appDelegate.VOICEFORTTS;
    
    
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
    [request addValue:speaker forHTTPHeaderField:@"X-AUT"];
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
    //
    //        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    //
    //            NSLog(@"返回数据-%@",data);
    //        }];
    
}



-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
//    NSLog(@"didReceiveData------%d",data.length);
    
    [_voiceData appendData:data];
    
    
   [[self delegate] onReceiveVoiceData:data];
    
    
    //    if(data != nil && [data length] > 0 )
    //    {
    //
    //        isPlaying = true;
    //        [_btn setBackgroundImage:[UIImage imageNamed:@"tts_button_pre"] forState:UIControlStateNormal];
    //
    //        NSDictionary *dic = @{@"sample_rate" : @8000, @"num_channels" : @1};
    //
    //        [AudioSessionHelper setupWhenWillBeginRecord];
    //        [AudioSessionHelper teardownWhenFinishedRecord];
    //
    //        XISpeexCodec *speexCodec = [[XISpeexCodec alloc] initWithMode:0];
    //        NSData *rawDate = [speexCodec decode:data];
    //        [_audioPlayer preparePlay:rawDate format:dic];
    //        //        [_audioPlayer play:NO];
    //
    //        [_audioPlayer play:NO finished:^(id content) {
    //
    //            [self  performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
    //        }];
    //    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    
    
    
    NSLog(@"didReceiveResponse");
}



@end
