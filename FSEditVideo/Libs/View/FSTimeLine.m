//
//  FSTimeLine.m
//  FSGPUImage
//
//  Created by 燕来秋 on 2020/7/15.
//  Copyright © 2020 燕来秋. All rights reserved.
//

#import "FSTimeLine.h"
#import "FSVideoThumbnailModel.h"
#import "FSCompoundTool.h"

@interface FSTimeLine ()

@property (nonatomic, strong) AVMutableComposition *mixComposition;
@property (nonatomic, strong) AVURLAsset* videoAsset;

@end

@implementation FSTimeLine

#pragma mark - 懒加载
- (AVMutableComposition *)mixComposition {
    if (!_mixComposition) {
        _mixComposition = [AVMutableComposition composition];
    }
    return _mixComposition;
}

#pragma mark - 内部方法
- (void)calculateDuration {
    CMTime time = self.mixComposition.duration;
    CGFloat second = (CGFloat)time.value / (CGFloat)time.timescale;
    int64_t duration = second*FS_TIME_BASE;
    _duration = duration;
}

#pragma mark - 外部调用
- (void)appendVideoClip:(NSString *)path trimIn:(int64_t)trimIn trimOut:(int64_t)trimOut {
    NSLog(@"video trimIn:%lld trimOut : %lld",trimIn,trimOut);
    if (!path) {
        NSAssert(NO, @"添加的视频文件不能为空");
        return;
    }
    NSURL *videoUrl = [NSURL fileURLWithPath:path];
    if (videoUrl) {
        AVURLAsset* videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
        self.videoAsset = videoAsset;
        
        //开始位置startTime
        CMTime startTime = CMTimeMake(trimIn, FS_TIME_BASE);//CMTimeMakeWithSeconds(trimIn, videoAsset.duration.timescale);
        //截取长度videoDuration
        CMTime videoDuration = CMTimeMake(trimOut-trimIn, FS_TIME_BASE);//CMTimeMakeWithSeconds(trimOut, videoAsset.duration.timescale);
        CMTimeRange videoTimeRange = CMTimeRangeMake(startTime, videoDuration);
        
        AVAssetTrack *videoTrack = [videoAsset tracksWithMediaType:AVMediaTypeVideo].firstObject;
        CGSize videoSize = CGSizeApplyAffineTransform(videoTrack.naturalSize, videoTrack.preferredTransform);
        videoSize = CGSizeMake(fabs(videoSize.width), fabs(videoSize.height));
        _videoSize = videoSize;
        
        NSError *error = nil;
        
        // 方法一 : 分别加视频轨道和声音轨道（这种方法暂时有问题，导出新的视频后，不能再编辑了）
//        //视频采集compositionVideoTrack
//        AVMutableCompositionTrack *compositionVideoTrack = [self.mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//        //TimeRange截取的范围长度
//        //ofTrack来源
//        //atTime插放在视频的时间位置
//        NSArray *videoTracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
//        AVAssetTrack *videoTrack = videoTracks.count > 0 ? videoTracks.firstObject : nil;
//        BOOL is = [compositionVideoTrack insertTimeRange:videoTimeRange
//                                                 ofTrack:videoTrack
//                                                  atTime:kCMTimeZero
//                                                   error:&error];
//        if (!is) {
//            NSLog(@"video insert error : %@",error);
//        }
//
//        // 添加原视频的声音
//        //视频声音采集(也可不执行这段代码不采集视频音轨，合并后的视频文件将没有视频原来的声音)
//        AVMutableCompositionTrack *compositionVoiceTrack = [self.mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//        NSArray *voiceTracks = [videoAsset tracksWithMediaType:AVMediaTypeAudio];
//        AVAssetTrack *voiceTrack = voiceTracks.count > 0 ? voiceTracks.firstObject : nil;
//        BOOL isVoice = [compositionVoiceTrack insertTimeRange:videoTimeRange
//                                       ofTrack:voiceTrack
//                                        atTime:kCMTimeZero error:&error];
//        if (!isVoice) {
//            NSLog(@"voice insert error : %@",error);
//        }
        
        // 方法二：直接加视频asset
        [self.mixComposition insertTimeRange:videoTimeRange ofAsset:videoAsset atTime:kCMTimeZero error:&error];
        
        // 计算时长
        [self calculateDuration];
    }
}

- (void)appendAudioClip:(NSString *)path trimIn:(int64_t)trimIn trimOut:(int64_t)trimOut {
    if (!path) {
        NSAssert(NO, @"音乐文件不能为空");
        return;
    }
//    CGFloat duration = [FSCompoundTool getMediaDurationWithMediaURL:[NSURL fileURLWithPath:path]];
//    NSLog(@"duration >> %f",duration);
//    if (trimIn > duration) {
//        NSLog(@"加入音频轨道失败 : 开始时间超过音频的时间");
//        return;
//    }
//    if (trimIn > trimOut) {
//        NSLog(@"加入音频轨道失败 : 开始时间超过了结束时间");
//    }
    
    int64_t audioIn = trimIn;
    int64_t audioOut = trimOut;
//    if (trimOut > duration) {
//        audioOut = duration;
//        return;
//    }
    
    NSURL *audioUrl = [NSURL fileURLWithPath:path];
    if (audioUrl) {
        AVURLAsset* audioAsset = [[AVURLAsset alloc] initWithURL:audioUrl options:nil];
        NSLog(@"audioIn >>>> %lld audioOut >>>> %lld",audioIn,audioOut);
        //开始位置startTime
        CMTime startTime = CMTimeMake(audioIn, FS_TIME_BASE);//CMTimeMakeWithSeconds(audioIn, audioAsset.duration.timescale);
        //截取长度videoDuration
        CMTime videoDuration = CMTimeMake(audioOut-audioIn, FS_TIME_BASE);//CMTimeMakeWithSeconds(audioOut, audioAsset.duration.timescale);
        
        CMTimeRange audioTimeRange = CMTimeRangeMake(startTime, videoDuration);
        
        //音频采集compositionCommentaryTrack
        AVMutableCompositionTrack *compositionAudioTrack = [self.mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        NSError *error = nil;
        NSArray *audioTracks = [audioAsset tracksWithMediaType:AVMediaTypeAudio];
        AVAssetTrack *audioTrack = audioTracks.count > 0 ? audioTracks.firstObject : nil;
        BOOL is = [compositionAudioTrack insertTimeRange:audioTimeRange ofTrack:audioTrack atTime:kCMTimeZero error:&error];
        if (!is) {
            NSLog(@"audio insert error : %@",error);
        }
    }
}

- (AVAsset *)getTimeAsset {
    return self.mixComposition;
}

- (AVMutableVideoComposition *)videoComposition {
    AVMutableVideoComposition *composition = [FSCompoundTool fixedCompositionWithAsset:self.videoAsset];
    return composition;
}

- (UIImage *)getImageWithTime:(CMTime)time {
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.mixComposition];
    imageGenerator.videoComposition = [self videoComposition];
    CMTime actualTime;//获取到图片确切的时间
    NSError *error = nil;
    CGImageRef CGImage = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if (!error) {
        
        UIImage *image = [UIImage imageWithCGImage:CGImage];
        CMTimeShow(actualTime);   //{111600/90000 = 1.240}
        CMTimeShow(time); // {1/1 = 1.000}
        
        return image;
    }
    return nil;
}

// 获取某个时间点的视频帧缩略图
- (UIImage *)getThumbnailImageWithTime:(CMTime)time {
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.mixComposition];
    imageGenerator.videoComposition = [self videoComposition];
    imageGenerator.maximumSize = CGSizeMake(200, 0);//按比例生成， 不指定会默认视频原来的格式大小
    CMTime actualTime;//获取到图片确切的时间
    NSError *error = nil;
    CGImageRef CGImage = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if (!error) {
        
        UIImage *image = [UIImage imageWithCGImage:CGImage];
        CMTimeShow(actualTime);   //{111600/90000 = 1.240}
        CMTimeShow(time); // {1/1 = 1.000}
        
        return image;
    }
    return nil;
}

- (void)getThumbnailArrayMaxDuration:(int64_t)maxDuration width:(CGFloat)width block:(FSArrayBlock)block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        int64_t tmpDuration = self.duration;
        if (self.duration > maxDuration) {
            tmpDuration = maxDuration;
        }
        // 每微妙多大UI宽
        CGFloat usecWidth = width/(CGFloat)tmpDuration;
        // 整个视频的UI宽
        CGFloat allWidth = self.duration*usecWidth;
        // 每一帧50的宽度
        CGFloat frameWidth = 50.0f;
        // 总图片数
        CGFloat imageCount = ceil(allWidth/frameWidth);
        // 每帧的微妙数
        int64_t frameUsec = self.duration/imageCount;
        int64_t usec = 0;//frameUsec;
        CGFloat x = 0;
        while (x<allWidth/*usec < self.duration*/) {
            CMTime time = CMTimeMake((int64_t)(usec), FS_TIME_BASE);
//            UIImage *image = [self getThumbnailImageWithTime:time];
//            if (image) {
                FSVideoThumbnailModel *model = [FSVideoThumbnailModel new];
//                model.thumbnailImage = image;
                model.time = time;
                model.isThumbnail = YES;
                if (x+frameWidth <= allWidth) {
                    model.size = CGSizeMake(frameWidth, 0);
                }else {
                    model.size = CGSizeMake(allWidth-x, 0);
                }
                if (model.size.width >= 0) {
                    [array addObject:model];
                }
//                if (array.count == 15) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if (block) {
//                            block(array);
//                        }
//                    });
//                }
//            }
            x += frameWidth;
            usec += frameUsec;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(array);
            }
        });
    });
}

- (void)getThumbnailArrayBlock:(FSArrayBlock)block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        // 每一帧50的宽度
        CGFloat frameWidth = 50.0f;
        // 总图片数
        CGFloat imageCount = self.duration/FS_TIME_BASE;
        if (self.duration < 15 * FS_TIME_BASE) {
            imageCount = 15;
        }
        CGFloat allWidth = imageCount * frameWidth;
        
        // 每帧的微妙数
        int64_t frameUsec = self.duration/imageCount;
        int64_t usec = 0;//frameUsec;
        CGFloat x = 0;
        while (usec < self.duration) {
            CMTime time = CMTimeMake((int64_t)(usec), FS_TIME_BASE);
            FSVideoThumbnailModel *model = [FSVideoThumbnailModel new];
            model.time = time;
            model.isThumbnail = YES;
            if (x+frameWidth <= allWidth) {
                model.size = CGSizeMake(frameWidth, 0);
            }else {
                model.size = CGSizeMake(allWidth-x, 0);
            }
            NSLog(@"model.size >>> %@",NSStringFromCGSize(model.size));
            if (model.size.width > 0) {
                [array addObject:model];
            }
            x += frameWidth;
            usec += frameUsec;
        }
        
        NSLog(@"imagecount : %f array count :%lu",imageCount,(unsigned long)array.count);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(array);
            }
        });
    });
}

@end
