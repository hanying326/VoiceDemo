//
//  ChatMessage.h
//  VoiceDemo
//
//  Created by 寒影 on 29/06/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#ifndef ChatMessage_h
#define ChatMessage_h


#endif /* ChatMessage_h */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface ChatMessage : NSObject


@property (nonatomic, strong) NSString *text;

@property (nonatomic, assign) BOOL  isRight;

@property (nonatomic, assign) CGSize messageSize;

@property (nonatomic, assign) CGFloat cellHeight;


@end
