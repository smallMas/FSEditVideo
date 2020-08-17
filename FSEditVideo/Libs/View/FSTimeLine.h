//
//  FSTimeLine.h
//  FSGPUImage
//
//  Created by 燕来秋 on 2020/7/15.
//  Copyright © 2020 燕来秋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "FSFrameMacro.h"

#define FS_TIME_BASE 1000000 //1秒 == 100w微妙

NS_ASSUME_NONNULL_BEGIN

@interface FSTimeLine : NSObject

@property (nonatomic, assign, readonly) int64_t duration; // 时间线时长 (单位微妙)

- (AVAsset *)getTimeAsset;
- (AVMutableVideoComposition *)videoComposition;

- (void)appendVideoClip:(NSString *)path trimIn:(int64_t)trimIn trimOut:(int64_t)trimOut;
- (void)appendAudioClip:(NSString *)path trimIn:(int64_t)trimIn trimOut:(int64_t)trimOut;

// 获取某个时间点的视频帧缩略图
- (UIImage *)getThumbnailImageWithTime:(CMTime)time;
- (void)getThumbnailArrayMaxDuration:(int64_t)maxDuration width:(CGFloat)width block:(FSArrayBlock)block;

@end

NS_ASSUME_NONNULL_END
