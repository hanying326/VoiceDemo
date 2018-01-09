//
//  FirstViewController.h
//  VoiceDemo
//
//  Created by 寒影 on 20/06/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#ifndef FirstViewController_h
#define FirstViewController_h

#endif /* FirstViewController_h */
#import <UIKit/UIKit.h>
#import "ChatMessage.h"

@interface FirstViewController : UIViewController

@property (nonatomic,assign)bool isSimple;
@property (nonatomic, strong) NSString *voice;

- (void) addNewMessage:(ChatMessage *)message;
- (void) scrollToBottom;
-(NSString *)returnFormatString:(NSString *)str;

@end

