//
//  AudioAQEngineRecorder.h
//  iknowapp
//
//  Created by Peter Liu on 9/20/12.
//  Copyright (c) 2012 xiaoi. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import "AudioBaseEngineRecorder.h"
#import "SpeechEndPointDetector.h"
#import "RecorderInputBufferHandlerListener.h"

class AQRecorder;

class AudioAQEngineEndPointDetectiveListener : public SpeechEndPointDetectorListener
{
public:
    void onActiveSpeechEndPointBegin(void *param, int begin_length);
    void onActiveSpeechEndPointEnd(void *param, int end_length);
};

class AudioAQEngineInputBufferHandlerListener : public RecorderInputBufferHandlerListener
{
public:
    void OnInputBufferHandler(void *param, void *buffer, size_t bufferByteSize);
};

@class AudioBaseEngineRecorder;

@interface AudioAQEngineRecorder : AudioBaseEngineRecorder
{
@private
    AQRecorder                          *_AQRecorder;
    SpeechEndPointDetectorListener      *_Listener;
    RecorderInputBufferHandlerListener  *_inputBufferHandlerListenerCPlusPlus;
}

@property (nonatomic, readonly, assign) AudioQueueRef   AQ;

- (BOOL)prepareRecordToBuf:(NSDictionary *)format isSupportEndpointDetection:(BOOL)isSupport from:(NSInteger)from to:(NSInteger)to;
- (BOOL)prepareRecordToBuf:(NSDictionary *)format isSupportEndpointDetection:(BOOL)isSupport;
- (BOOL)prepareRecordToBuf:(NSDictionary *)format isSupportEndpointDetection:(BOOL)isSupport autoEndSec:(NSTimeInterval)sec;

- (BOOL)prepareRecordToFile:(NSString *)fileName format:(NSDictionary *)format;
- (BOOL)record;
- (BOOL)pause;
- (BOOL)stop;

@end
