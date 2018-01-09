//
//  ThirdViewController.h
//  VoiceDemo
//
//  Created by 寒影 on 23/06/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#ifndef ThirdViewController_h
#define ThirdViewController_h
#endif /* ThirdViewController_h */

#import <UIKit/UIKit.h>

@interface ThirdViewController : UIViewController


@property (nonatomic, strong) NSString *inputContent;
//@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, strong) NSString *voice;
-(void)changeVoice:(NSString *)name;


@end

