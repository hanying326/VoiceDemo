//
//  AQMeterLevelController.h
//  iknowapp
//
//  Created by Peter Liu on 9/19/12.
//  Copyright (c) 2012 xiaoi. All rights reserved.MeterTable.h
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AudioToolbox/AudioToolbox.h>

struct MeterTable;

@class AQMeterLevelController;


@protocol AQMeterLevelControllerDelegate<NSObject>

- (void)AQMeterLevelController:(AQMeterLevelController *)ctrl updateLevels:(NSArray *)updateLevels peakLevels:(NSArray *)peakLevels;

@end

@interface AQMeterLevelController : NSObject
{
@private
    AudioQueueRef               _AQ;
    AudioQueueLevelMeterState   *_levelMeterState;
    NSTimer                     *_updateTimer;
    CGFloat                     _refreshHz;
    struct MeterTable           *_meterTable;
    NSArray                     *_channelNumbers;
    NSMutableArray              *_levels;
    NSMutableArray              *_peakLevels;
}

@property (nonatomic, assign) AudioQueueRef AQ;
@property (nonatomic, assign) CGFloat refreshHz;
@property (nonatomic, assign) id<AQMeterLevelControllerDelegate> delegate;

- (id)init;

@end
