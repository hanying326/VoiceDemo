//
//  ChatMessage.m
//  VoiceDemo
//
//  Created by 寒影 on 29/06/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessage.h"
#import "Macros.h"

static UILabel *label = nil;

@implementation ChatMessage

- (id) init
{
    if (self = [super init]) {
        if (label == nil) {
            label = [[UILabel alloc] init];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:16.0f]];
        }
    }
    return self;
}

- (CGSize) messageSize
{
    [label setText:_text];
    _messageSize = [label sizeThatFits:CGSizeMake(WIDTH_SCREEN * 0.46, MAXFLOAT)];
    
//      _messageSize = [label sizeThatFits:CGSizeMake(WIDTH_SCREEN * 0.55, MAXFLOAT)];
    
    return _messageSize;
}

- (CGFloat) cellHeight
{
    
    return self.messageSize.height + 40 > 60 ? self.messageSize.height + 40 : 60;
//    return self.messageSize.height + 40 ;
    
}

@end
