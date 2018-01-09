//
//  WebSocket.m
//  VoiceDemo
//
//  Created by 寒影 on 14/08/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebSocket.h"
#import <CommonCrypto/CommonDigest.h>
#import "GzipUtil.h"
#import "LoadInfo.h"
#import "AURecorder.h"

@interface WebSocket()<SRWebSocketDelegate>
{
    
    SRWebSocket * webSocket;
    
    NSString *modelStr;
    NSString *language;
    NSString *sessionId;
    GzipUtil *util;
    
    NSString * languageType;
    NSMutableArray *wordsetArray;
    NSMutableArray *sentenceArray;
    
    
    
    NSMutableDictionary *domainLmWeights;
    NSMutableArray *useWordSets;
    
    
}

@property (nonatomic,strong)NSMutableArray *loadInfos;

@property (nonatomic,strong)AURecorder *auRecorder;

@end

@implementation WebSocket

+(instancetype)share
{
    static dispatch_once_t onceToken;
    static WebSocket * instance=nil;
    
    dispatch_once(&onceToken,^{
        instance=[[self alloc]init];
        
    });
    return instance;
}


-(void)initSocket
{
    _auRecorder = [[AURecorder alloc] init];
    [webSocket close];
    
    NSString *wsUrl = [KryptonManager share].url;
    
    if ([self checkUrl:wsUrl]){
        
        webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:wsUrl]];
        webSocket.delegate = self;
        
        NSOperationQueue * queue=[[NSOperationQueue alloc]init];
        queue.maxConcurrentOperationCount=1;
        [webSocket setDelegateOperationQueue:queue];
        
        [webSocket open];
        util = [[GzipUtil alloc]init];
        _objects = [[NSMutableArray alloc]init];
        
    }
    
    else {
        [[[KryptonManager share] delegate] onError:@"URL格式错误"];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    
    [self extAuth];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    
    [[[KryptonManager share]  delegate]onError:error.domain];
}


-(void)extAuth{
    
    NSString *appkey = [KryptonManager share].appKey;
    NSString *appSecret = [KryptonManager share].appSecret;
    
    if (appkey == nil || appSecret == nil || appkey.length == 0 || appSecret.length == 0){
        
        [[[KryptonManager share]  delegate ]onError:@"appKey或appSecret需填写完整"];
        
    }
    
    else {
        
        NSString *auth = [self getXAuth:appkey withSecret:appSecret];
        
        NSInteger rate = 8000;
        id b = @(rate);
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"ExtAuth",            @"method",
                                    auth,                  @"X-Auth",
                                    b,                     @"samplingRate",
                                    //                         @"aac",                   @"binEncode",
                                    nil];
        
        
        if ([[KryptonManager share].languageType isEqualToString:@"wuu-CHN"]){
            
            [dic setObject:@"wuu-CHN" forKey:@"language"];
        }
        
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
        NSData *compressedData = [util gzippedData:jsonData];
        NSString *resultStr = [[NSString alloc] initWithData:compressedData  encoding:NSASCIIStringEncoding];
        [webSocket send:resultStr];
    }
}


- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    
    [[[KryptonManager share]  delegate ]onError:@"didCloseWithCode"];
}


-(void)sendMsg:(NSString *)msg
{
    [webSocket send:msg];
}


-(void)sendAudio:(id)msg
{
    [webSocket send:msg];
}


- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSString *result ;
    
    if ( [message isKindOfClass:[NSString class]] ) {
        result = message;
    }
    
    NSData* temp = [result dataUsingEncoding:NSISOLatin1StringEncoding];
    NSData *resultData = [util gunzippedData:temp];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resultData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    NSString *status = [dic objectForKey:@"status"];
    NSString *responseTo = [dic objectForKey:@"responseTo"];
    NSString *method = [dic objectForKey:@"method"];
    NSString *event = [dic objectForKey:@"event"];
    
    wordsetArray = [[NSMutableArray alloc]init];
    sentenceArray = [[NSMutableArray alloc]init];
    
    if([responseTo isEqualToString:@"ExtAuth"]){
        
        if([status isEqualToString:@"success"]){
            
            NSMutableArray *object = [dic valueForKey:@"objects"];
            
            if (object != nil){
                
                for (int i = 0 ; i< [object count];i++){
                    
                    NSDictionary *dic = [object objectAtIndex:i];
                    NSString *filename = [dic valueForKey:@"filename"];
                    NSString *type = [dic valueForKey:@"type"];
                    
                    LoadInfo *info = [[LoadInfo alloc ]init];
                    info.loadType = type;
                    info.id = [dic valueForKey:@"id"];;
                    info.filename = filename;
                    
                    
                    if ([type containsString:@"wordset"]){
                        [wordsetArray addObject:info];
                    }
                    
                    else {
                        
                        [sentenceArray addObject:info];
                        
                        
                    }
                }
            }
            
            if (_onlyForGetObjects){
                _onlyForGetObjects = false;
                
                [webSocket close];
                
                NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             
                                             wordsetArray,      @"wordSet",
                                             sentenceArray,     @"sentence",
                                             nil];
                
                [[[KryptonManager share]delegate]onReceiveLanguageModel:temp];
                
                //                [self endOfInput];
                //                [self stop];
                
            }
            else {
                [self createSession];
            }
        }
        
        else{
            
            NSString *reason = [dic objectForKey:@"reason"];
            [[[KryptonManager share]delegate]onError:reason];
            
        }
    }
    
    else if([responseTo isEqualToString:@"CreateSession"]){
        
        if([status isEqualToString:@"complete"]){
            
            [self load];
        }
    }
    
    else  if([responseTo isEqualToString:@"Load"]){
        
        if([status isEqualToString:@"complete"]){
            
            [self recognize];
        }
    }
    
    else if([responseTo isEqualToString:@"Recognize"]){
        
        if([status isEqualToString:@"in-progress"]){
            [_auRecorder startRecorder];
        }
    }
    
    
    else if ([method isEqualToString:@"Event"]){
        
        
          if ([event isEqualToString:@"PartialResult"]){
            
            NSDictionary *data = [dic objectForKey:@"data"];
            id utterance_complete = [data objectForKey:@"utterance_complete"];
            NSArray *nBest = [data objectForKey:@"nBest"];
            
            if ([nBest count ]> 0){
                
                NSString *formattedText =[[nBest objectAtIndex:0]objectForKey:@"formattedText"];
                
                id yes = [NSNumber numberWithBool:true];
                
                if ([utterance_complete isEqual: yes]){
                    
                    [[[KryptonManager share]  delegate]onReceiveFinalResult:formattedText];
                }
                
                else {
                    [[[KryptonManager share]  delegate]onReceivePartialResult:formattedText];
                }
            }
        }
    }
    
    
    else if([responseTo isEqualToString:@"Stop"]){
        
        if ([status isEqualToString:@"complete"]){
            [self endSession];
        }
    }
    
    else if ([responseTo isEqualToString:@"EndSession"]){
        [webSocket close];
    }
}

-(NSString *)uuidString
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

-(NSString *)getXAuth:(NSString *)key withSecret:(NSString *)secret{
    
    NSMutableArray *sign = [self getSHA1Encode:@"recoglive" withKey:key withSecret:secret];
    NSMutableString *auth = [[NSMutableString alloc]init];
    NSInteger count = [sign count];
    if(sign != nil && count ==2){
        
        [auth appendString:[NSString stringWithFormat:@"app_key=\"%@\"",key]];
        [auth appendString:[NSString stringWithFormat:@",nonce=\"%@\"",[sign objectAtIndex:0]]];
        [auth appendString:[NSString stringWithFormat:@",signature=\"%@\"",[sign objectAtIndex:1]]];
    }
    return auth;
}


-(NSMutableArray *)getSHA1Encode:(NSString *)requestType withKey:(NSString *)key withSecret:(NSString *)secret {
    
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSString *nonce = [self getRandomString:40];
    
    NSString *ha1 = [[self SHA1EncodeToHex:[NSString stringWithFormat:@"%@:xiaoi.com:%@",key,secret]] lowercaseString];
    NSString *ha2 = [[self SHA1EncodeToHex:[NSString stringWithFormat:@"POST:/%@",requestType]] lowercaseString];
    NSString *signature = [[self SHA1EncodeToHex:[NSString stringWithFormat:@"%@:%@:%@",ha1,nonce,ha2]] lowercaseString];
    
    [result addObject:nonce];
    [result addObject:signature];
    return result;
    
}


-(NSString *)getRandomString :(NSInteger)lenth{
    
    NSString *base = @"abcdefghijklmnopqrstuvwxyxABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *result = [[NSMutableString alloc]init];
    
    for (int i = 0; i< lenth; ++i){
        
        int x = arc4random() % base.length;
        
        UniChar ch = [base characterAtIndex:x];
        
        [result appendString:[NSString stringWithFormat:@"%C",ch]];
        
    }
    return result;
}


-(NSString *)SHA1EncodeToHex:(NSString *)origin{
    
    return [self sha1:origin];
}

- (NSString*) sha1:(NSString *)str
{
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}



-(void)createSession{
    
    sessionId = [self uuidString];
    NSString *requestId = [self uuidString];
    NSMutableDictionary *languagePack = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         @"cmn-CHN",      @"language",
                                         @"topic",       @"travel",
                                         nil];
    
    if ([[KryptonManager share].languageType isEqualToString:@"wuu-CHN"]){
        [languagePack setValue:@"wuu-CHN" forKey:@"language"];
    }
    
    NSDictionary *clientData = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"COMPANY",        @"companyName",
                                @"APPLICATION",    @"applicationName",
                                @"d.e.f",          @"applicationVersion",
                                nil];
    
    NSDictionary *sessionParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"1s",                        @"detachedTimeout",
                                       @"3600s",                     @"idleTimeout",
                                       @"audio/L16;rate=8000",       @"audioFormat",
                                       nil];
    
    id boolNumber = [NSNumber numberWithBool:false];
    NSDictionary *recognitionParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                           boolNumber,      @"startRecognitionTimers",
                                           nil];
    boolNumber = [NSNumber numberWithBool:true];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"CreateSession",           @"method",
                         @"1.0",                     @"version",
                         sessionId,                  @"sessionId",
                         requestId,                  @"requestId",
                         boolNumber,                 @"attach",
                         languagePack,               @"languagePack",
                         clientData,                 @"clientData",
                         sessionParameters,          @"sessionParameters",
                         recognitionParameters,      @"recognitionParameters",
                         nil];
    
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSData *compressedData = [util gzippedData:jsonData];
    NSString *resultStr = [[NSString alloc] initWithData:compressedData  encoding:NSASCIIStringEncoding];
    [webSocket send:resultStr];
}

-(void)load{
    
    
    [_objects removeAllObjects];
    
     domainLmWeights =[[NSMutableDictionary alloc]init];
     useWordSets = [[NSMutableArray alloc]init];
    
    
    if (_choosenWordSets != nil && [_choosenWordSets count]> 0){
        
        for (LoadInfo *cinfo in _choosenWordSets){
            
            for (LoadInfo *oinfo in wordsetArray){
                
                if ([cinfo.id isEqualToString:oinfo.id]){
                    
                    NSDictionary *tempDic =[NSDictionary dictionaryWithObjectsAndKeys:
                                            oinfo.id,             @"id",
                                            oinfo.loadType,       @"type",
                                            nil];
                    
                    [_objects addObject:tempDic];
                    
                    [useWordSets addObject:oinfo.id];
                    
                    
                    break;
                }
            }
        }
    }
    
    
    if (_choosenSentences != nil && [_choosenSentences count]> 0){
        for (LoadInfo *cinfo in _choosenSentences){
            for (LoadInfo *oinfo in sentenceArray){
                if ([cinfo.id isEqualToString:oinfo.id]){
                    
                    NSDictionary *tempDic =[NSDictionary dictionaryWithObjectsAndKeys:
                                            oinfo.id,             @"id",
                                            oinfo.loadType,       @"type",
                                            nil];
                     [_objects addObject:tempDic];
                    
                    
                    
                    
                    NSString *weight = cinfo.dlmWeight;
                    
                    
                    if (weight == nil || weight.length == 0){
                        
                        weight = @"medium";
                        
                    }
                    
                    
                    [domainLmWeights setObject:weight forKey:oinfo.id];
                    
                    
                      break;
                }
            }
        }
    }
    
    if (_objects != nil && [_objects count] > 0){
        
        NSString *requestId = [self uuidString];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Load",      @"method",
                             @"1.0",       @"version",
                             sessionId,    @"sessionId",
                             requestId,    @"requestId",
                             _objects,     @"objects",
                             nil];
        
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
        NSData *compressedData = [util gzippedData:jsonData];
        NSString *resultStr = [[NSString alloc] initWithData:compressedData  encoding:NSASCIIStringEncoding];
        [webSocket send:resultStr];
    }
    
    else {
        [self recognize];
        
    }
    
}

-(void)endSession {
    
    NSString *requestId = [self uuidString];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"EndSession",      @"method",
                         @"1.0",             @"version",
                         sessionId,          @"sessionId",
                         requestId,          @"requestId",
                         nil];
    
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSData *compressedData = [util gzippedData:jsonData];
    NSString *resultStr = [[NSString alloc] initWithData:compressedData  encoding:NSASCIIStringEncoding];
    [webSocket send:resultStr];
}

-(void)changeModelSetting : (NSMutableArray *)loadInfos{
    
    _loadInfos = loadInfos;
}

-(void)recognize{
    
    NSString *requestId = [self uuidString];
    
    
    
    id boolNumber = [NSNumber numberWithBool:false];
    
    NSDictionary *recognitionParameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                           boolNumber,      @"autoEnd",
                                           nil];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"Recognize",                   @"method",
                         @"1.0",                         @"version",
                         sessionId,                      @"sessionId",
                         requestId,                      @"requestId",
                         domainLmWeights,                @"domainLmWeights",
                         useWordSets,                    @"useWordSets",
                         recognitionParameters,          @"recognitionParameters",
                         nil];
    
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSData *compressedData = [util gzippedData:jsonData];
    NSString *resultStr = [[NSString alloc] initWithData:compressedData  encoding:NSASCIIStringEncoding];
    [webSocket send:resultStr];
    
}


-(void)startSendAudio{
    
    [self initSocket];
    
}

-(void)stopSendAudio{
    
    [_auRecorder stopRecorder];
    [self endOfInput];
    [self stop];
    
}

-(void)endOfInput{
    
    NSString *requestId = [self uuidString];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"EndOfInput",                   @"method",
                         @"1.0",                         @"version",
                         sessionId,                      @"sessionId",
                         requestId,                      @"requestId",
                         nil];
    
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSData *compressedData = [util gzippedData:jsonData];
    NSString *resultStr = [[NSString alloc] initWithData:compressedData  encoding:NSASCIIStringEncoding];
    [webSocket send:resultStr];
    
}


-(void) stop {
    
    NSString *requestId = [self uuidString];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"Stop",                        @"method",
                         @"1.0",                         @"version",
                         sessionId,                      @"sessionId",
                         requestId,                      @"requestId",
                         nil];
    
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSData *compressedData = [util gzippedData:jsonData];
    NSString *resultStr = [[NSString alloc] initWithData:compressedData  encoding:NSASCIIStringEncoding];
    [webSocket send:resultStr];
}


-(void)closeSocket{
    
    [webSocket close];
    [_auRecorder stopRecorder];
    _auRecorder = nil;
}



-(bool) checkUrl:(NSString *)url{
    
    
    if (url != nil && url.length >1){
        
        NSURL *temp = [NSURL URLWithString:url];
        NSString *scheme = temp.scheme.lowercaseString;
        
        if (temp != nil){
            
            if ([scheme isEqualToString:@"wss"] || [scheme isEqualToString:@"ws"]) {
                
                return true;
                
            }
            
            
        }
    }
    
    
    return false;
    
}




@end



































