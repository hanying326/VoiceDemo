//
//  AudioSessionHelper.h
//  iknowapp
//
//  Created by Peter Liu on 9/20/12.
//  Copyright (c) 2012 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioSessionHelper : NSObject

+ (void)setupWhenWillBeginRecord;
+ (void)teardownWhenFinishedRecord;

@end
