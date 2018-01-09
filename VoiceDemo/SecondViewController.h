//
//  SecondViewController.h
//  VoiceDemo
//
//  Created by 寒影 on 28/06/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#ifndef SecondViewController_h
#define SecondViewController_h


#endif /* SecondViewController_h */

#import <UIKit/UIKit.h>

#import "WebSocket.h"
#import "KryptonManager.h"


@interface SecondViewController : UIViewController <KryptonDelegate>

@property (nonatomic, strong)NSMutableArray *modelSettingDic;


@end
