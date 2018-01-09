//
//  Macros.h
//  VoiceDemo
//
//  Created by 寒影 on 29/06/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#define WBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

#define WIDTH_SCREEN        [UIScreen mainScreen].bounds.size.width
#define HEIGHT_SCREEN       [UIScreen mainScreen].bounds.size.height
#define HEIGHT_STATUSBAR    20
#define DEFAULT_BACKGROUND_COLOR         WBColor(245.0, 245.0, 245.0, 1.0)

#define MENU_BACKGROUND_COLOR         WBColor(48.0, 48.0, 48.0, 1.0)

#define BORDER_RED         WBColor(217.0, 70.0, 91.0, 1.0)

#define POPUP_RED         WBColor(219.0, 76.0, 97.0, 1.0)

#define POPUP_GRAY       WBColor(220.0, 220.0, 220.0, 1.0)

#define WHITE_COLOR         WBColor(255.0, 255.0, 255.0, 1.0)

#define TEST_BACKGROUND_COLOR         WBColor(0, 0, 155.0, 1.0)

#define POP_TEXT_COLOR         WBColor(99, 99, 99.0, 1.0)

#define HEIGHT_NAVBAR       44

#define HEIGHT_STATUSBAR    20
#define HEIGHT_TABBAR       49

#define HEIGHT_CHATBOXVIEW  215

#define LANG_SETTING  100
#define ADDR_SETTING  101
#define MODEL_SETTING  102
#define ARGU_SETTING  103
#define SIM_SWITCH  104
#define VOICE_SETTING  105
#define ADDR_SETTING_ASK  106

#define ARGU_SETTING_FORREC 107

#define PADDING 15.0

#define APP_KEY  @"QdkyupmTq42500upmTq"
#define APP_SECRET @"soB129d06crMEVDMg88v"
#define REC_ADDR  @"http://vcloud.xiaoi.com"
#define TTS_ADDR @"http://vcloud.xiaoi.com"
#define ASK_ADDR @"http://nlp.xiaoi.com"
#define SYNTH_ADDR @"http://vcloud.xiaoi.com"
#define PLAT_FORM  @"ioscloud"
#define USER_ID  @"123"

#define WS_URL @"ws://vcloudm.xiaoi.com/live-rec/recoglive"
//#define WS_URL @"ws://vcloud.xiaoi.com/recoglive"

//#define WS_URL @"ws://172.16.9.214:8080/recoglive"


#define REC_KEY @"xiaoirecdemo"
#define REC_SECRET @"xiaoirecdemo"

#endif /* Macros_h */
