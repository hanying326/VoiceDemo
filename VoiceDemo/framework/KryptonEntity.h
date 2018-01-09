//
//  KryptonEntity.h
//  VoiceDemo
//
//  Created by 寒影 on 04/07/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//
#ifndef KryptonEntity_h
#define KryptonEntity_h
#endif /* KryptonEntity_h */

#import "LoadInfo.h"

@interface KryptonEntity : NSObject
{
    NSString *language;
    NSMutableArray<LoadInfo *> *loadInfos;
}

@property(copy, nonatomic)  NSString *language;
@property(strong, nonatomic) NSMutableArray<LoadInfo *> *loadInfos;


@end









































