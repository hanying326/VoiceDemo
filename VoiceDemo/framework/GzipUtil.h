//
//  GzipUtil.h
//  VoiceDemo
//
//  Created by 寒影 on 16/08/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#ifndef GzipUtil_h
#define GzipUtil_h

#endif /* GzipUtil_h */

@interface GzipUtil : NSObject

- (nullable NSData *)gzippedDataWithCompressionLevel:(float)level data:(NSData *)data;
- (nullable NSData *)gzippedData:(NSData *)data;
- (NSData *)gunzippedData :(NSData *)data;

@end
