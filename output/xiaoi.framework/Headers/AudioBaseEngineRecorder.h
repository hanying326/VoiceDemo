//
//  AudioBaseEngineRecorder.h
//  iknowapp
//
//  Created by Peter Liu on 9/20/12.
//  Copyright (c) 2012 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioProtocol.h"

@interface AudioBaseEngineRecorder : NSObject<AudioRecorderProtocol>
{
@protected
    NSDictionary            *_format;
    NSData                  *_data;
    NSString                *_fileName;
    BOOL                    _isSupportSpeechEndPointDetective;
    

    enum RecordOutputType
    {
        RECORD_TYPE_NONE = 0,
        RECORD_TYPE_BUF,
        RECORD_TYPE_FILE,
        RECORD_TYPE_BUF_RANGE
    };
    
    enum RecordOutputType _recordOT;
}

@property (nonatomic, readonly, assign) NSInteger curBeginLength;
@property (nonatomic, readonly, assign) NSInteger curEndLength;

@property (nonatomic, readonly, assign) enum RecordOutputType recordOT;
@property (nonatomic, readonly, assign) BOOL isRecording;
@property (nonatomic, readonly, strong) NSDictionary *format;
@property (nonatomic, readonly, assign) BOOL isSupportSpeechEndPointDetective;
@property (nonatomic, readonly, strong) NSData *data;
@property (nonatomic, assign) id<SpeechEndPointListener> speechEndPointListener;
@property (nonatomic, assign) id<RecordInputBufferHandlerListener> inputBufferHandlerListener;

- (BOOL)prepareRecordToBuf:(NSDictionary *)format isSupportEndpointDetection:(BOOL)isSupport from:(NSInteger)from to:(NSInteger)to;
- (BOOL)prepareRecordToBuf:(NSDictionary *)format isSupportEndpointDetection:(BOOL)isSupport;
- (BOOL)prepareRecordToFile:(NSString *)fileName format:(NSDictionary *)format;
- (BOOL)record;
- (BOOL)pause;
- (BOOL)stop;




@end
