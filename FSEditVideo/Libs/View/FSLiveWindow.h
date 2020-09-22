//
//  FSLiveWindow.h
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/9/22.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, FSDirectionSenseType) {
    // 不识别方向
    FSDirectionSenseTypeNone,
    // 根据系统方向开关识别方向
    FSDirectionSenseTypeSystem,
    // 根据重力感应识别方向
    FSDirectionSenseTypeMotion
};

@protocol FSLiveWindowDelegate <NSObject>

@optional
// 拍照回调
- (void)live_didTakeImage:(UIImage *)image;
// 录制视频回调
- (void)live_didFinishRecordOutPutFileURL:(NSURL *)outputFileURL error:(NSError *)error;
// 录制进度回调
- (void)live_recordProgressValue:(CGFloat)progress;
// 点击的point回调
- (void)live_focusPoint:(CGPoint)point;
@end

@interface FSLiveWindow : UIView

@property (nonatomic, weak) id <FSLiveWindowDelegate> delegate;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) CGFloat maxSeconds; // 录制最大时间
@property (nonatomic, assign) FSDirectionSenseType senseType; // 识别方向
@property (nonatomic, assign) BOOL isCanTapFocus; // 是否可以点击聚焦
@property (nonatomic, assign) BOOL isCanZoom; // 是否可以缩放

// 开始捕捉画面
- (void)startRunning;
// 停止捕捉画面
- (void)stopRunning;
// 拍照
- (void)takePicture;
// 录制视频
- (void)startRecordFileURL:(NSURL *)URL;
// 停止录制
- (void)endRecord;
// 切换摄像头
- (void)changeCamera;
// 切换闪光灯
- (void)switchFlash;

@end

NS_ASSUME_NONNULL_END
