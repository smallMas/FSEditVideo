//
//  FSLiveWindow.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/9/22.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "FSLiveWindow.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <CoreMotion/CoreMotion.h>

@interface FSLiveWindow () {
    dispatch_queue_t actionQueue;
}


//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, assign) AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic, strong) AVCaptureDeviceInput *input;

//音频轨道
@property (nonatomic, strong) AVCaptureDeviceInput *audioCaptureDeviceInput;

//照片输出流
@property (nonatomic, strong) AVCaptureStillImageOutput *ImageOutPut;

//视频输出流
@property (nonatomic, strong) AVCaptureMovieFileOutput *captureMovieFileOutput;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

//重力感应对象
@property (nonatomic, strong) CMMotionManager *cmmotionManager;
//记录设备方向
@property (nonatomic, assign) UIDeviceOrientation deviceOrientation;
//当前录制的时间定时器
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGFloat factor;
@property (nonatomic, assign) CGFloat tmpFactor;

@end

@implementation FSLiveWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewLayer.frame = self.bounds;
}

- (void)setup {
    self.factor = 1.0f;
    self.deviceOrientation = UIDeviceOrientationPortrait;
    actionQueue = dispatch_queue_create("com.dnaer.FSLiveWindow.action", DISPATCH_QUEUE_SERIAL);
    [self initNotification];
    [self customCamera];
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVCaptureSessionWasInterruptedNotification:) name:AVCaptureSessionWasInterruptedNotification object:self.session];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVCaptureSessionInterruptionEndedNotification:) name:AVCaptureSessionInterruptionEndedNotification object:self.session];
}

- (void)customCamera {
    [self addVideoInput];
    [self addAudioInput];
    [self addDNImageOutPut];
    [self addMovieFileOutput];
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    CGRect previewRect = self.bounds;
    self.previewLayer.frame = previewRect;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:self.previewLayer];
    
    //修改设备的属性，先加锁
    if ([self.device lockForConfiguration:nil]) {
        
        //闪光灯自动
        if ([self.device isFlashModeSupported:AVCaptureFlashModeOff]) {
            [self.device setFlashMode:AVCaptureFlashModeOff];
        }
        
        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        
        //解锁
        [self.device unlockForConfiguration];
    }
}

- (void)addVideoInput {
    if (!_input) {
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
}

- (void)addAudioInput {
    if (!_audioCaptureDeviceInput) {
        //添加一个音频输入设备
        AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
        //添加音频
        NSError *error = nil;
        AVCaptureDeviceInput *audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
        if (error) {
            NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
            return;
        }
        self.audioCaptureDeviceInput = audioCaptureDeviceInput;
    }
    
    if ([self.session canAddInput:self.audioCaptureDeviceInput]) {
        [self.session addInput:self.audioCaptureDeviceInput];
    }
}

- (void)removeAudioInput {
    [self.session removeInput:self.audioCaptureDeviceInput];
}

- (void)addDNImageOutPut {
    if (!_ImageOutPut) {
        _ImageOutPut = [[AVCaptureStillImageOutput alloc]init];
    }
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
}

- (void)addMovieFileOutput {
    if (!_captureMovieFileOutput) {
        _captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];//视频输出
    }
    
    //将输出设备添加到会话 (刚开始 是照片为输出对象)
    if ([self.session canAddOutput:self.captureMovieFileOutput]) {
        [self.session addOutput:self.captureMovieFileOutput];
        
        //设置视频防抖
        AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([connection isVideoStabilizationSupported]) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
        }
    }
}

#pragma mark - 懒加载
- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc]init];
    }
    return _session;
}

- (CMMotionManager *)cmmotionManager {
    if (!_cmmotionManager) {
        _cmmotionManager = [[CMMotionManager alloc] init];
    }
    return _cmmotionManager;
}

#pragma mark - SET GET
- (void)setSenseType:(FSDirectionSenseType)senseType {
    _senseType = senseType;
    
    if (self.senseType == FSDirectionSenseTypeMotion) {
        DN_WEAK_SELF
        if([self.cmmotionManager isDeviceMotionAvailable]) {
           [self.cmmotionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
               DN_STRONG_SELF
               double x = accelerometerData.acceleration.x;
               double y = accelerometerData.acceleration.y;
               if (fabs(y) >= fabs(x)) {
                   if (y >= 0) {
                       //Down
                       self.deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
                   } else {
                       //Portrait
                       self.deviceOrientation = UIDeviceOrientationPortrait;
                   }
               } else {
                   if (x >= 0) {
                       //Righ
                       self.deviceOrientation = UIDeviceOrientationLandscapeRight;
                   } else {
                       //Left
                       self.deviceOrientation = UIDeviceOrientationLandscapeLeft;
                   }
               }
           }];
        }
    }
}

- (void)setIsCanTapFocus:(BOOL)isCanTapFocus {
    if (isCanTapFocus) {
        // 点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
        tapGesture.delegate = (id <UIGestureRecognizerDelegate>)self;
        [self addGestureRecognizer:tapGesture];
    }
}

- (void)setIsCanZoom:(BOOL)isCanZoom {
    if (isCanZoom) {
        // 缩放手势
        UIPinchGestureRecognizer *zoomGesture =[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(zoomAction:)];
        [self addGestureRecognizer:zoomGesture];
    }
}

#pragma mark - 事件
- (void)tapScreen:(UITapGestureRecognizer*)gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}

- (void)zoomAction:(UIPinchGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.tmpFactor = gesture.scale;
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat between = gesture.scale - self.tmpFactor;
        
        self.factor += between;
        if (self.factor < 1) {
            self.factor = 1;
        }else if (self.factor > self.device.activeFormat.videoMaxZoomFactor) {
            self.factor = self.device.activeFormat.videoMaxZoomFactor-1;
        }
        [self setFactorValue:self.factor];
        
        self.tmpFactor = gesture.scale;
    }
}

#pragma mark - 内部方法
- (void)setFactorValue:(CGFloat)factor {
    if (self.device.activeFormat.videoMaxZoomFactor > factor && factor >= 1.0) {
        if ([self.device lockForConfiguration:NULL]) {
//            [self.device rampToVideoZoomFactor:factor withRate:1.0];//rate越大，动画越慢
            self.device.videoZoomFactor = factor;
            [self.device unlockForConfiguration];
        }
    }
}

- (void)focusAtPoint:(CGPoint)point {
    CGSize size = self.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        [self.device unlockForConfiguration];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(live_focusPoint:)]) {
        [self.delegate live_focusPoint:point];
    }
}

#pragma mark - 通知
- (void)AVCaptureSessionWasInterruptedNotification:(NSNotification *)notification {
    AVCaptureSessionInterruptionReason reason = [notification.userInfo[AVCaptureSessionInterruptionReasonKey] integerValue];
    NSLog(@"fanshijian 中断 : %d reason : %ld",self.session.interrupted,(long)reason);
    if (reason == AVCaptureSessionInterruptionReasonAudioDeviceInUseByAnotherClient) {
        [self removeAudioInput];
    }
}

- (void)AVCaptureSessionInterruptionEndedNotification:(NSNotification *)notification {
    NSLog(@"fanshijian 中断结束 : %d",self.session.interrupted);
    if (![FSCameraConfig shareInstance].isSystemCall) {
        [self addAudioInput];
    }
}

#pragma mark - 外部调用
- (void)startRunning {
    dispatch_async(actionQueue, ^{
        if (!self.session.isRunning) {
            //开始启动
            [self.session startRunning];
        }
    });
}

- (void)stopRunning {
    dispatch_async(actionQueue, ^{
        if (self.session.isRunning) {
            //结束
            [self.session stopRunning];
        }
    });
}

// 切换摄像头
- (void)changeCamera {
    //获取摄像头的数量
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    //摄像头小于等于1的时候直接返回
    if (cameraCount <= 1) return;
    
    AVCaptureDevice *newCamera = nil;
    AVCaptureDeviceInput *newInput = nil;
    //获取当前相机的方向(前还是后)
    AVCaptureDevicePosition position = [[self.input device] position];
    
    //为摄像头的转换加转场动画
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.5;
    animation.type = @"oglFlip";
    
    if (position == AVCaptureDevicePositionFront) {
        //获取后置摄像头
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        animation.subtype = kCATransitionFromLeft;
    }else{
        //获取前置摄像头
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        animation.subtype = kCATransitionFromRight;
    }
    
    [self.previewLayer addAnimation:animation forKey:nil];
    //输入流
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    
    
    if (newInput != nil) {
        
        [self.session beginConfiguration];
        //先移除原来的input
        [self.session removeInput:self.input];
        
        if ([self.session canAddInput:newInput]) {
            [self.session addInput:newInput];
            self.input = newInput;
            
        } else {
            //如果不能加现在的input，就加原来的input
            [self.session addInput:self.input];
        }
        
        [self.session commitConfiguration];
    }
}

- (void)switchFlash {
//    NSError *error;
//    if (self.device.hasTorch) {  // 判断设备是否有闪光灯
//        BOOL b = [self.device lockForConfiguration:&error];
//        if (!b) {
//            if (error) {
//                NSLog(@"lock torch configuration error:%@", error.localizedDescription);
//            }
//            return;
//        }
//        self.device.torchMode = (self.device.torchMode == AVCaptureTorchModeOff ? AVCaptureTorchModeOn : AVCaptureTorchModeOff);
//        [self.device unlockForConfiguration];
//    }
    
    NSError *error;
    BOOL b = [self.device lockForConfiguration:&error];
    if (!b) {
        if (error) {
            NSLog(@"lock torch configuration error:%@", error.localizedDescription);
        }
        return;
    }
    AVCaptureFlashMode mode = self.device.flashMode;
    if (mode == AVCaptureFlashModeOff) {
        mode = AVCaptureFlashModeOn;
    }else {
        mode = AVCaptureFlashModeOff;
    }
    //闪光灯自动
    if ([self.device isFlashModeSupported:mode]) {
        [self.device setFlashMode:mode];
    }
    [self.device unlockForConfiguration];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}

- (AVCaptureVideoOrientation)getCaptureVideoOrientation:(UIDeviceOrientation)deviceOrientation {
    AVCaptureVideoOrientation result;
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            result = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            //如果这里设置成AVCaptureVideoOrientationPortraitUpsideDown，则视频方向和拍摄时的方向是相反的。
            result = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIDeviceOrientationLandscapeLeft:
            result = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            result = AVCaptureVideoOrientationLandscapeLeft;
            break;
        default:
            result = AVCaptureVideoOrientationPortrait;
            break;
    }
    return result;
}

- (void)takePicture {
    AVCaptureConnection *myVideoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if ([myVideoConnection isVideoOrientationSupported]) {
        if (self.senseType == FSDirectionSenseTypeSystem) {
            myVideoConnection.videoOrientation = [self getCaptureVideoOrientation:[UIDevice currentDevice].orientation];
        }else {
            myVideoConnection.videoOrientation = [self getCaptureVideoOrientation:self.deviceOrientation];
        }
    }
    
    //撷取影像（包含拍照音效）
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:myVideoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSLog(@"拍照 Error : %@",error);
        //完成撷取时的处理程序(Block)
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            //取得的静态影像
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            
            UIImageOrientation imgOrientation; //拍摄后获取的的图像方向
            if ([self.input device].position == AVCaptureDevicePositionFront) {
                NSLog(@"前置摄像头");
                // 前置摄像头图像方向 UIImageOrientationLeftMirrored
                // IOS前置摄像头左右成像
                imgOrientation = UIImageOrientationLeftMirrored;
                image = [[UIImage alloc]initWithCGImage:image.CGImage scale:1.0f orientation:imgOrientation];
            }
            
            // 矫正方向
            image = [image fsj_fixOrientation];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(live_didTakeImage:)]) {
                [self.delegate live_didTakeImage:image];
            }
        }
    }];
}

- (void)startRecordFileURL:(NSURL *)URL {
    NSLog(@"%s",__FUNCTION__);
    if (URL) {
        AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        //根据连接取得设备输出的数据
        if (![self.captureMovieFileOutput isRecording]) {
            //如果支持多任务则开始多任务
            
            //视频方向
            if ([connection isVideoOrientationSupported]) {
                if (self.senseType == FSDirectionSenseTypeSystem) {
                    connection.videoOrientation = [self getCaptureVideoOrientation:[UIDevice currentDevice].orientation];
                }else {
                    connection.videoOrientation = [self getCaptureVideoOrientation:self.deviceOrientation];
                }
            }
            
            NSURL *fileUrl = URL;
            [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:(id <AVCaptureFileOutputRecordingDelegate>)self];
        }
    }else {
        NSLog(@"录制视频 路径为空");
    }
}

- (void)endRecord {
    NSLog(@"%s",__FUNCTION__);
    [self.captureMovieFileOutput stopRecording];//停止录制
}

- (BOOL)isRecording {
    return [self.captureMovieFileOutput isRecording];
}

- (void)setMaxSeconds:(CGFloat)maxSeconds {
    _maxSeconds = maxSeconds;
    if (maxSeconds > 0) {
        if (self.captureMovieFileOutput) {
            self.captureMovieFileOutput.maxRecordedDuration = CMTimeMakeWithSeconds(maxSeconds, 30);
        }
    }
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"开始录制");
    [self clearTimer];
    DN_WEAK_SELF
    self.timer = [NSTimer fsj_scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer * _Nonnull timer) {
        DN_STRONG_SELF
        [self updateProgress];
    }];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    NSLog(@"录制结束 error : %@",error);
    [self clearTimer];
    if (self.delegate && [self.delegate respondsToSelector:@selector(live_didFinishRecordOutPutFileURL:error:)]) {
        [self.delegate live_didFinishRecordOutPutFileURL:outputFileURL error:error];
    }
}

- (void)clearTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)updateProgress {
    CGFloat second = self.captureMovieFileOutput.recordedDuration.value/(CGFloat)self.captureMovieFileOutput.recordedDuration.timescale;
    
    CGFloat progress = second/(CGFloat)self.maxSeconds;
    if (progress > 1) {
        progress = 1;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(live_recordProgressValue:)]) {
        [self.delegate live_recordProgressValue:progress];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 手势的触击方法是否在按钮区域，如果是，则返回NO，禁用手势。
    if([touch.view isKindOfClass:[UIButton class]] ||
       [touch.view isKindOfClass:[UIControl class]]){
        
        return NO;
    }
    
    return YES;
}


@end
