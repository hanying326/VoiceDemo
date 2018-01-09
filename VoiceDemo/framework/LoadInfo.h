//
//  LoadInfo.h
//  VoiceDemo
//
//  Created by 寒影 on 04/07/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//
#ifndef LoadInfo_h
#define LoadInfo_h
#endif /* LoadInfo_h */

@interface LoadInfo : NSObject
{
    NSString *id;
    NSString *dlmUrl;
    NSString *loadType;
    NSString *dlmWeight;
    
     NSString *filename;
    
}

@property(copy, nonatomic)  NSString *id;
@property(copy, nonatomic)  NSString *dlmUrl;
@property(copy, nonatomic)  NSString *loadType;
@property(copy, nonatomic)  NSString *dlmWeight;

@property(copy, nonatomic)  NSString *filename;


@end







































