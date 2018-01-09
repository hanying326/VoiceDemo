//
//  AudioPlayerController.h
//  iknowapp
//
//  Created by Peter Liu on 9/21/12.
//  Copyright (c) 2012 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioProtocol.h"

@class AudioBaseEnginePlayer;

typedef enum
{
    AudioPlayerEngine_Type_None,
    AudioPlayerEngine_Type_AQ,      //Using AudioQueueService to play audio
}AudioPlayerEngineType;

@interface AudioPlayerController : NSObject<AudioPlayerProtocol>
{
    AudioBaseEnginePlayer           *_engine;
    AudioPlayerEngineType           _curEngineType;
}

- (id)initWithEngineType:(AudioPlayerEngineType)engineType;

@property (nonatomic, assign, readonly) AudioPlayerEngineType   curEngineType;
@property (nonatomic, strong, readonly) AudioBaseEnginePlayer   *engine;

@property (nonatomic, readonly, strong) NSDictionary *format;
@property (nonatomic, readonly, strong) NSData *data;
@property (nonatomic, readonly, assign) BOOL isPlaying;

- (BOOL)preparePlay:(NSData *)pcmData format:(NSDictionary *)format from:(NSInteger)from to:(NSInteger)to;
- (BOOL)preparePlay:(NSData *)pcmData format:(NSDictionary *)format;
- (BOOL)preparePlay:(NSString *)fileName;
- (BOOL)play:(BOOL)isResume;
- (BOOL)play:(BOOL)isResume finished:(void(^)(id content))finished;
- (BOOL)stop;
- (BOOL)pause;

@end
