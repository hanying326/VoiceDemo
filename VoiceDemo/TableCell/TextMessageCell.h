//
//  TextMessageCell.h
//  VoiceDemo
//
//  Created by 寒影 on 29/06/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#ifndef TextMessageCell_h
#define TextMessageCell_h
#endif /* TextMessageCell_h */

#import <UIKit/UIKit.h>
#import "ChatMessage.h"

@interface TextMessageCell :  UITableViewCell

@property (nonatomic, strong) UIImageView  *messageBackgroundImageView;
@property (nonatomic, strong) UILabel      *messageTextLabel;
@property (nonatomic, strong) ChatMessage  *message;

@end
