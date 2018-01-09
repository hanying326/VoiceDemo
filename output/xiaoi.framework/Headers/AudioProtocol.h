//
//  AudioPlayerControllerProtocol.h
//  iknowapp
//
//  Created by Peter Liu on 9/20/12.
//  Copyright (c) 2012 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AudioPlayerProtocol <NSObject>

@required
- (BOOL)preparePlay:(NSData *)pcmData format:(NSDictionary *)format from:(NSInteger)from to:(NSInteger)to;
- (BOOL)preparePlay:(NSData *)pcmData format:(NSDictionary *)format;
- (BOOL)preparePlay:(NSString *)fileName;
- (BOOL)play:(BOOL)isResume;
- (BOOL)play:(BOOL)isResume finished:(void(^)(id content))finished;
- (BOOL)stop;
- (BOOL)pause;

@end

@protocol AudioRecorderProtocol<NSObject>

@required
- (BOOL)prepareRecordToBuf:(NSDictionary *)format isSupportEndpointDetection:(BOOL)isSupport from:(NSInteger)from to:(NSInteger)to;
- (BOOL)prepareRecordToBuf:(NSDictionary *)format isSupportEndpointDetection:(BOOL)isSupport;
- (BOOL)prepareRecordToBuf:(NSDictionary *)format isSupportEndpointDetection:(BOOL)isSupport autoEndSec:(NSTimeInterval)sec;
- (BOOL)prepareRecordToFile:(NSString *)fileName format:(NSDictionary *)format;
- (BOOL)record;
- (BOOL)pause;
- (BOOL)stop;

@end

@protocol SpeechEndPointListener<NSObject>

@optional
- (BOOL)onSpeechEndPointActiveBegin:(NSInteger)beginLength;
- (BOOL)onSpeechEndPointActiveEnd:(NSInteger)endLength;

@end

@protocol RecordInputBufferHandlerListener<NSObject>

@optional
- (void)onRecordInputBufferHandler:(void *)buf length:(NSUInteger)length;

@end
