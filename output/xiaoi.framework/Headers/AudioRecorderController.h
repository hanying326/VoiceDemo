//
//  AudioPlayerController.h
//  iknowapp
//
//  Created by Peter Liu on 8/21/12.
//  Copyright (c) 2012 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioProtocol.h"

typedef enum
{
    AudioRecordEngine_Type_None,
    AudioRecordEngine_Type_AQ           //Using AudioQueueService;
    
}AudioRecordEngineType;

@class AudioBaseEngineRecorder;

@interface AudioRecorderController : NSObject<AudioRecorderProtocol>
{
@private
    AudioRecordEngineType           _curEngineType;
    AudioBaseEngineRecorder         *_engine;
}

- (id)initWithEngineType:(AudioRecordEngineType)engineType;

@property (nonatomic, assign, readonly) AudioRecordEngineType curEngineType;
@property (nonatomic, strong, readonly) AudioBaseEngineRecorder *engine;
@property (nonatomic, strong, readonly) NSData *data;
@property (nonatomic, assign, readonly) BOOL isRecording;
@property (nonatomic, assign, readonly) NSDictionary *format;

- (BOOL)prepareRecordToBuf:(NSDictionary *)format isSupportEndpointDetection:(BOOL)isSupport from:(NSInteger)from to:(NSInteger)to;
- (BOOL)prepareRecordToBuf:(NSDictionary *)format isSupportEndpointDetection:(BOOL)isSupport;
- (BOOL)prepareRecordToBuf:(NSDictionary *)format isSupportEndpointDetection:(BOOL)isSupport autoEndSec:(NSTimeInterval)sec;
- (BOOL)prepareRecordToFile:(NSString *)fileName format:(NSDictionary *)format;
- (BOOL)record;
- (BOOL)pause;
- (BOOL)stop;

@end
