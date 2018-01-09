//
//  SpeechSessionResponseDomain.h
//  iknowapp
//
//  Created by Peter Liu on 8/28/12.
//  Copyright (c) 2012 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpeechSessionResponseDomain : NSObject

@property (nonatomic, strong) NSData    *audioData;
@property (nonatomic, assign) NSInteger audioBitsPerSample;
@property (nonatomic, assign) NSInteger audioRate;
@property (nonatomic, strong) NSString  *audioEncode;

@end
