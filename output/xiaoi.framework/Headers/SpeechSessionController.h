//
//  SpeechSessionController.h
//  iknowapp
//
//  Created by Peter Liu on 8/28/12.
//  Copyright (c) 2012 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpeechSessionResponseDomain.h"

enum SpeechType
{
    ST_FEMALE = 0,
    ST_MALE
};

@class SpeechSessionController;

@protocol SpeechSessionControllerDelegate<NSObject>

@optional
- (void)speechSessionController:(SpeechSessionController *)ctrl didFinished:(SpeechSessionResponseDomain *)domain;
- (void)speechSessionController:(SpeechSessionController *)ctrl failed:(NSError *)error;

@end

@interface SpeechSessionParams : NSObject

@property (nonatomic, strong) NSString          *audioEncode;
@property (nonatomic, assign) NSInteger         audioBitsPerSample;
@property (nonatomic, assign) NSInteger         audioRate;
@property (nonatomic, strong) NSString          *content;
@property (nonatomic, strong) NSString          *textEncode;
@property (nonatomic, strong) NSString          *baseURL;
@property (nonatomic, assign) enum SpeechType   speechType;
@property (nonatomic, strong) NSString          *userID;
@property (nonatomic, strong) NSString          *platform;

@end

@interface SpeechSessionController : NSObject
{
@private
    //__weak id<SpeechSessionControllerDelegate>                _delegate;
    SpeechSessionParams                                       *_params;
    SpeechSessionResponseDomain                               *_domain;
}

@property (nonatomic, assign) id<SpeechSessionControllerDelegate>   delegate;
@property (nonatomic, strong, readonly) SpeechSessionParams *params;
@property (nonatomic, assign) NSTimeInterval timeout;

- (BOOL)begin:(SpeechSessionParams *)params delegate:(id<SpeechSessionControllerDelegate>)delegate;
- (BOOL)begin:(SpeechSessionParams *)params
      success:(void(^)(SpeechSessionController *ctrl, SpeechSessionResponseDomain *domain))success
       failed:(void(^)(SpeechSessionController *ctrl, NSError *error))failed;

@end
