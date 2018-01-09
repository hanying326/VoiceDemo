//
//  AppDelegate.h
//  VoiceDemo
//
//  Created by 寒影 on 20/06/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *SYNTHADDR;
@property (strong, nonatomic) NSString *APPKEY;
@property (strong, nonatomic) NSString *APPSECRET;
@property (strong, nonatomic) NSString *PLATFORM;
@property (strong, nonatomic) NSString *USERID;
@property (strong, nonatomic) NSString *TTSADDR;
@property (strong, nonatomic) NSString *ASKADDR;
@property (strong, nonatomic) NSString *RECADDR;
@property (strong, nonatomic) NSString *TTSADDRF;
@property (strong, nonatomic) NSString *WSADDR;

@property (strong, nonatomic) NSString *VOICEFORTTS;
@property (strong, nonatomic) NSString *VOICE;

//@property (strong, nonatomic) NSMutableDictionary *allModelSetting;
//@property (strong, nonatomic) NSMutableDictionary *selectedModelSetting;

@property (strong, nonatomic) NSMutableDictionary *reviewModelSetting;

@property (strong, nonatomic) NSMutableDictionary *wordsetModelSetting;

@property (strong, nonatomic) NSMutableDictionary *sentenceModelSetting;

@property (strong, nonatomic) NSString *APPKEYREC;
@property (strong, nonatomic) NSString *APPSECRETREC;

@property (nonatomic , assign)bool firstLoadType;

@end

