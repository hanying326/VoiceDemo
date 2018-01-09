//
//  AppInfo.h
//  xiaoi
//
//  Created by Peter Liu on 11/11/14.
//  Copyright (c) 2014 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, assign) BOOL isActive;

+ (AppInfo *)shareInstance;

@end
