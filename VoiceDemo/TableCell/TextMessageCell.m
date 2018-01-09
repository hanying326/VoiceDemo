//
//  TextMessageCell.m
//  VoiceDemo
//
//  Created by 寒影 on 29/06/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextMessageCell.h"
#import "ChatMessage.h"
#import "Macros.h"
#import "ZMChineseConvert.h"

@interface TextMessageCell()
@end

@implementation TextMessageCell

- (void) setMessage:(ChatMessage *)message
{
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    _message = message;
     CGRect rec = [_message.text boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    self.messageTextLabel = [[UILabel alloc] init];
    
    if (_message.isRight) {
         [_messageTextLabel setTextColor : WHITE_COLOR ];
        
        CGFloat originX = WIDTH_SCREEN - rec.size.width -30;
        
        CGRect bubbleFrame = CGRectMake(originX, 10, rec.size.width + 20, rec.size.height + 20);
        
         self.messageBackgroundImageView = [[UIImageView alloc] initWithFrame:bubbleFrame];
        
        [self.messageBackgroundImageView setHidden:NO];
        
      [self.messageBackgroundImageView setImage : [[UIImage imageNamed:@"voice_font_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch]];
    }
    else {
        
         [_messageTextLabel setTextColor : POP_TEXT_COLOR ];
    CGRect bubbleFrame = CGRectMake(10, 10, rec.size.width + 20, rec.size.height + 20);
        
         self.messageBackgroundImageView = [[UIImageView alloc] initWithFrame:bubbleFrame];
        
        [self.messageBackgroundImageView setHidden:NO];
        
        [self.messageBackgroundImageView setImage:[[UIImage imageNamed:@"voice_font_bg_white.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch]];
    }
    
   _messageTextLabel.frame = CGRectMake(10, 10, rec.size.width, rec.size.height);
    
    _messageTextLabel.numberOfLines  = 0;
    
    [_messageTextLabel setText:_message.text];
    
    [self addSubview:self.messageBackgroundImageView];
    [self.messageBackgroundImageView addSubview:self.messageTextLabel];
    
    [self setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    
}

@end
