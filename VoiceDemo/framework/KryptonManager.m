//
//  KryptonManager.m
//  VoiceDemo
//
//  Created by 寒影 on 19/09/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KryptonManager.h"

#import "WebSocket.h"

@interface KryptonManager()
{
    WebSocket *socket;
    
}


@end

@implementation KryptonManager


+(instancetype)share
{
    static dispatch_once_t onceToken;
    static KryptonManager * instance=nil;
    
    dispatch_once(&onceToken,^{
        instance=[[self alloc]init];
        
    });
    return instance;
}



-(void) getLanguageModel{
    
    [WebSocket share].onlyForGetObjects = true;
    [[WebSocket share]initSocket];
    
}

-(void)startRecordWithWordset :(NSMutableArray *)wordsets  withSentence :(NSMutableArray *)sentences{
    
    [WebSocket share].onlyForGetObjects = false;
    [WebSocket share].choosenWordSets = wordsets;
    
    [WebSocket share].choosenSentences = sentences;
    
    [[WebSocket share]initSocket];
    
}

-(void)stopRecord{
    
    [[WebSocket share]stopSendAudio];
    
}

@end






























