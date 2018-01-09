//
//  AskSessionController.h
//  iknowapp
//
//  Created by Peter Liu on 8/27/12.
//  Copyright (c) 2012 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AskSessionResponseDomain.h"

@class AskSessionController;

@protocol AskSessionControllerDelegate<NSObject>

@optional
- (void)askSessionController:(AskSessionController *)ctrl didFinished:(AskSessionResponseDomain *)domain;
- (void)askSessionController:(AskSessionController *)ctrl failed:(NSError *)error;

- (void)askSessionController:(AskSessionController *)ctrl loginFinished:(AskSessionResponseDomain *)domain;
- (void)askSessionController:(AskSessionController *)ctrl loginFailed:(NSError *)error;

@end

@interface AskSessionParams : NSObject

@property (nonatomic, copy) NSString *sessionID;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *question;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, copy) NSString *ver;
@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, copy) NSString *iOSVersion;
@property (nonatomic, copy) NSString *clientAttrs;

@end

@interface AskSessionController : NSObject
{
@private
    AskSessionParams                    *_params;
    id<AskSessionControllerDelegate>     _delegate;
    NSString                            *_lastResponseString;
}

@property (nonatomic, strong, readonly) NSString    *lastResponseString;
@property (nonatomic, strong, readonly) AskSessionParams *params;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, strong) AskSessionResponseDomain *lastSuccessResponseDomain;

- (BOOL)login:(AskSessionParams *)params delegate:(id<AskSessionControllerDelegate>)delegate;

- (BOOL)login:(AskSessionParams *)params
      success:(void (^)(AskSessionController *ctrl, AskSessionResponseDomain *domain))success
       failed:(void (^)(AskSessionController *ctrl, NSError *error))failed;

- (BOOL)ask:(AskSessionParams *)params delegate:(id<AskSessionControllerDelegate>)delegate;

- (BOOL)ask:(AskSessionParams *)params
      success:(void (^)(AskSessionController *ctrl, AskSessionResponseDomain *domain))success
       failed:(void (^)(AskSessionController *ctrl, NSError *error))failed;

@end
