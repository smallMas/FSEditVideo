//
//  FSViewController.m
//  FSEditVideo
//
//  Created by fanshij@163.com on 08/04/2020.
//  Copyright (c) 2020 fanshij@163.com. All rights reserved.
//

#import "FSViewController.h"
#import "FSClipVideoController.h"
#import "TZImagePickerController.h"
#import "FSPlayerViewController.h"
#import "FSPreviewController.h"
#import "FSShowCoverController.h"
#import "FSCameraViewController.h"

@interface FSViewController () <UIVideoEditorControllerDelegate>

@property (nonatomic, strong) UIButton *albumBtn;

@end

@implementation FSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.albumBtn];
    
    [self.albumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
        make.center.mas_equalTo(self.view);
    }];
}

- (UIButton *)albumBtn {
    if (!_albumBtn) {
        _albumBtn = [UIButton fsj_createWithType:UIButtonTypeCustom target:self action:@selector(albumAction:)];
        [_albumBtn setBackgroundColor:[UIColor redColor]];
        [_albumBtn setTitle:@"相册" forState:UIControlStateNormal];
        [_albumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _albumBtn;
}

- (void)albumAction:(id)sender {
//    TZImagePickerController *_imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
//    // 2. Set the appearance
//    // 2. 在这里设置imagePickerVc的外观
//
//    // 3. 设置是否可以选择视频/图片/原图
//    _imagePickerVc.allowPickingVideo = YES; // 是否允许选择视频
//    _imagePickerVc.allowPickingImage = NO; //是否允许选择图片
//    _imagePickerVc.allowPickingOriginalPhoto = NO;// 是否允许选择原片
//    _imagePickerVc.allowPickingGif = NO;  //是否允许选择GIF
//    _imagePickerVc.allowCrop = YES;
//    _imagePickerVc.timeout = 2;
//    _imagePickerVc.cropRect = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH);
//    _imagePickerVc.cropRectPortrait = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH);
//    // 4. 照片排列按修改时间升序
//    _imagePickerVc.sortAscendingByModificationDate = YES;
//    _imagePickerVc.showSelectBtn = NO;
//    _imagePickerVc.needCircleCrop = NO;
////    _imagePickerVc.photoWidth = SCREENWIDTH*2;
//    _imagePickerVc.circleCropRadius = SCREENWIDTH/2;
//    _imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
////    _imagePickerVc.barItemTextColor = DSColorFromHex(0x323232);
////    _imagePickerVc.naviTitleColor = DSColorFromHex(0x323232);
//    _imagePickerVc.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
//
//    _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
////           _imagePickerVc.navigationBar.tintColor = DSColorFromHex(0x323232);
//           UIBarButtonItem *tzBarItem, *BarItem;
//               tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
//               BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
//    //设置返回图片，防止图片被渲染变蓝，以原图显示
//    _imagePickerVc.navigationBar.backIndicatorTransitionMaskImage = [[UIImage imageNamed:@"public_icon_white_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    _imagePickerVc.navigationBar.backIndicatorImage = [[UIImage imageNamed:@"public_icon_white_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//           NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
//           [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
//    _imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:_imagePickerVc animated:YES completion:nil];
    
    
    
    FSCameraViewController *vc = [FSCameraViewController new];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)gotoClipVideoURL:(NSURL *)URL {
    NSLog(@"URL >>>> %@",URL);
    FSRecordingInfo *info = [FSRecordingInfo new];
    info.recordingURL = URL;
    
    FSClipVideoController *vc = [FSClipVideoController new];
    vc.recordingInfo = info;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    NSLog(@"asset >>> %@",asset);
    NSLog(@"localIdentifier : %@",asset.localIdentifier);
    
//    [self playerAsset:asset];
    
//    [FSAlertUtil showLoading];
//    DN_WEAK_SELF
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        DN_STRONG_SELF
//        [FSVideoImageTool getVideoURL:asset block:^(NSURL * _Nonnull URL) {
//            DN_STRONG_SELF
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [FSAlertUtil hiddenLoading];
//                if (URL) {
////                    [self gotoClipVideoURL:URL];
////                    [self complete:URL];
////                    [self playerURL:URL];
////                    [self rotateVideoAssetWithFileURL:URL dstFileURL:[NSURL fileURLWithPath:[FSPathTool folderVideoPathWithName:DNRecordCompoundFolder fileName:nil]]];
//                    [self gotoPreview:URL];
//                }
//            });
//        }];
//    });
    
    NSLog(@"-------1");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionCurrent;
    options.networkAccessAllowed = YES;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        NSLog(@"-------2");
        if (asset && [asset isKindOfClass:[AVURLAsset class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self gotoPreviewAsset:asset];
                
                AVURLAsset *URLAsset = (AVURLAsset *)asset;
//                [self gotoSystemVideoEdit:URLAsset.URL];
                [self getThumbailURL:URLAsset.URL];
            });
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    NSLog(@"-------3");
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"-------4");
}

// 系统编辑controller
- (void)gotoSystemVideoEdit:(NSURL *)URL {
    UIVideoEditorController *vc = [[UIVideoEditorController alloc] init];
    vc.delegate = self;
    vc.videoPath = URL.path;
    vc.title = @"视频编辑";
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)getThumbailURL:(NSURL *)URL {
    NSLog(@"%s",__func__);
    //初始化asset对象
    AVURLAsset *videoAsset = [[AVURLAsset alloc]initWithURL:URL options:nil];
    
    //获取总视频的长度 = 总帧数 / 每秒的帧数
    long videoSumTime = videoAsset.duration.value / videoAsset.duration.timescale;
    
    //创建AVAssetImageGenerator对象
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc]initWithAsset:videoAsset];
    generator.maximumSize = CGSizeMake(200, 0);
    generator.appliesPreferredTrackTransform = YES;
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    
    // 添加需要帧数的时间集合
    NSMutableArray *framesArray = [NSMutableArray array];
    for (int i = 0; i < videoSumTime; i++) {
        CMTime time = CMTimeMake(i *videoAsset.duration.timescale , videoAsset.duration.timescale);
        NSValue *value = [NSValue valueWithCMTime:time];
        [framesArray addObject:value];
    }
    
    NSMutableArray *imgArray = [NSMutableArray array];
    
    NSMutableArray *thumArray = [[NSMutableArray alloc] init];
    __block long count = 0;
    [generator generateCGImagesAsynchronouslyForTimes:framesArray completionHandler:^(CMTime requestedTime, CGImageRef img, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        
        if (result == AVAssetImageGeneratorSucceeded) {
            
            NSLog(@"%ld",count);
//            UIImageView *thumImgView = [[UIImageView alloc] initWithFrame:CGRectMake(50+count*self.IMG_Width, 0, self.IMG_Width, 70)];
//            thumImgView.image = ;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [editScrollView addSubview:thumImgView];
//                editScrollView.contentSize = CGSizeMake(100+count*self.IMG_Width, 0);
//            });
            UIImage *image = [UIImage imageWithCGImage:img];
            [thumArray addObject:image];
            NSLog(@"thumArray : %lld",thumArray.count);
            count++;
        }
        
        if (result == AVAssetImageGeneratorFailed) {
            NSLog(@"Failed with error: %@", [error localizedDescription]);
        }
        
        if (result == AVAssetImageGeneratorCancelled) {
            NSLog(@"AVAssetImageGeneratorCancelled");
        }
    }];
    NSLog(@"-------------1");
}

- (void)gotoPreview:(NSURL *)URL {
    FSPreviewController *vc = [FSPreviewController new];
    vc.videoURL = URL;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoPreviewAsset:(AVAsset *)asset {
    FSPreviewController *vc = [FSPreviewController new];
    vc.asset = asset;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)complete:(NSURL *)outputFileURL {
    [FSAlertUtil showLoading];
    NSString *outPutPath = [FSPathTool folderVideoPathWithName:DNRecordCompoundFolder fileName:nil];
    
//    1.将素材拖入到素材库中
    AVAsset *asset = [AVAsset assetWithURL:outputFileURL];
    //素材的视频轨
    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0];
    //素材的音频轨
    AVAssetTrack *audioAssertTrack = [[asset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];



    //这是工程文件
    AVMutableComposition *composition = [AVMutableComposition composition];
     //视频轨道
    AVMutableCompositionTrack *videoCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
     //在视频轨道插入一个时间段的视频
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
    //音频轨道
    AVMutableCompositionTrack *audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
     //插入音频数据，否则没有声音
    [audioCompositionTrack insertTimeRange: CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration) ofTrack:audioAssertTrack atTime:kCMTimeZero error:nil];


    AVMutableVideoCompositionLayerInstruction *videoCompositionLayerIns = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoAssetTrack];
    [videoCompositionLayerIns setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    //得到视频素材（这个例子中只有一个视频）
    AVMutableVideoCompositionInstruction *videoCompositionIns = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    [videoCompositionIns setTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration)];
    //得到视频轨道（这个例子中只有一个轨道）
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoCompositionIns.layerInstructions = @[videoCompositionLayerIns];
    videoComposition.instructions = @[videoCompositionIns];
    videoComposition.renderSize = videoAssetTrack.naturalSize;//CGSizeMake(100,100);
    //裁剪出对应的大小
    videoComposition.frameDuration = CMTimeMake(1, 30);

    //混合后的视频输出路径
    NSURL *outPutUrl = [NSURL fileURLWithPath:outPutPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outPutPath error:nil];
    }
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = videoComposition;
    exporter.outputURL = outPutUrl;//[NSURL fileURLWithPath:outPutPath isDirectory:YES];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;//AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [FSAlertUtil hiddenLoading];
            NSLog(@"exporter.error >> %@",exporter.error);
            
            switch ([exporter status]) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[exporter error] localizedDescription]);
                    break;
                    
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    break;
                    
                case AVAssetExportSessionStatusCompleted:{
                    NSLog(@"Export completed");
                    
                    // 保存到相册
                    UISaveVideoAtPathToSavedPhotosAlbum(outPutPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
                    break;
                    
                default:
                    NSLog(@"Export other");

                    break;
            }
        });
     }];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = error ? @"保存视频失败" : @"保存视频成功";
    [FSAlertUtil showPromptInfo:msg];
    if (!error) {
        [self playerURL:[NSURL fileURLWithPath:videoPath]];
    }
    NSLog(@"%@",msg);
}

- (void)playerURL:(NSURL *)url {
//    FSPlayerViewController *vc = [FSPlayerViewController new];
//    vc.URL = url;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    int64_t duration = [FSCompoundTool getMediaDurationWithMediaURL:url];
    AVURLAsset* videoAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:videoAsset];
//    imageGenerator.videoComposition = [self videoComposition];
    CMTime actualTime;//获取到图片确切的时间
    CMTime time = CMTimeMakeWithSeconds(duration/(CGFloat)FS_TIME_BASE, videoAsset.duration.timescale);
    NSError *error = nil;
    CGImageRef CGImage = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *image = nil;
    if (!error) {
        
        image = [UIImage imageWithCGImage:CGImage];
        CMTimeShow(actualTime);
        CMTimeShow(time);
    }
    FSShowCoverController *vc = [FSShowCoverController new];
    vc.coverImage = image;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)playerAsset:(PHAsset *)asset {
    DN_WEAK_SELF
    [self handleAsset:asset block:^(AVMutableComposition *URL) {
        DN_STRONG_SELF
        FSPlayerViewController *vc = [FSPlayerViewController new];
        vc.asset = URL;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)handleAsset:(PHAsset *)asset block:(void (^)(AVMutableComposition *URL))block {
    PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    options.networkAccessAllowed = YES;
    __block NSURL *url = nil;
    __weak typeof(self) wself = self;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
//        AVURLAsset *videoAsset = (AVURLAsset*)asset;
//        // 时间起点
//        CMTime nextClistartTime = kCMTimeZero;
//        // 视频时间范围
//        CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
//        // 创建可变的音视频组合
//        AVMutableComposition *comosition = [AVMutableComposition composition];
//
//        NSError *error = nil;
//        [comosition insertTimeRange:videoTimeRange ofAsset:videoAsset atTime:kCMTimeZero error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(asset);
            }
        });
    }];
    
//    // 路径
//   NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//   // 声音来源
//   NSURL *audioInputUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"五环之歌" ofType:@"mp3"]];
//   // 视频来源
//   NSURL *videoInputUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"myPlayer" ofType:@"mp4"]];
//
//   // 最终合成输出路径
//   NSString *outPutFilePath = [documents stringByAppendingPathComponent:@"merge.mp4"];
//   // 添加合成路径
//   NSURL *outputFileUrl = [NSURL fileURLWithPath:outPutFilePath];
//   // 时间起点
//   CMTime nextClistartTime = kCMTimeZero;
//   // 创建可变的音视频组合
//   AVMutableComposition *comosition = [AVMutableComposition composition];
//
//
//   // 视频采集
//   AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoInputUrl options:nil];
//   // 视频时间范围
//   CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
//   // 视频通道 枚举 kCMPersistentTrackID_Invalid = 0
//   AVMutableCompositionTrack *videoTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//   // 视频采集通道
//   AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
//   //  把采集轨道数据加入到可变轨道之中
//   [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:nextClistartTime error:nil];
//
//
//
//   // 声音采集
//   AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:audioInputUrl options:nil];
//   // 因为视频短这里就直接用视频长度了,如果自动化需要自己写判断
//   CMTimeRange audioTimeRange = videoTimeRange;
//   // 音频通道
//   AVMutableCompositionTrack *audioTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//   // 音频采集通道
//   AVAssetTrack *audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
//   // 加入合成轨道之中
//   [audioTrack insertTimeRange:audioTimeRange ofTrack:audioAssetTrack atTime:nextClistartTime error:nil];
}

/// -----------------------------------------------------------2
- (void)rotateVideoAssetWithFileURL:(NSURL *)fileURL dstFileURL:(NSURL *)dstFileURL{
    [FSAlertUtil showLoading];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], AVURLAssetPreferPreciseDurationAndTimingKey, nil];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:options];
    
    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVAssetTrack *audioAssetTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    if (videoAssetTrack == nil || audioAssetTrack == nil) {
        NSLog(@"error is %@", @"video or audio assetTrack is nil");
        return;
    }
    
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = videoAssetTrack.minFrameDuration;
    CGSize renderSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    videoComposition.renderSize = renderSize;
    
    //create a video instruction
    AVMutableVideoCompositionInstruction *videoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    videoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    
    AVMutableVideoCompositionLayerInstruction *videoCompositionLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoAssetTrack];
    
    //仿射变换的坐标为iOS的屏幕坐标x向右为正y向下为正
    CGAffineTransform transform = [self videoAssetTrackTransform:videoAssetTrack];
    [videoCompositionLayerInstruction setTransform:transform atTime:kCMTimeZero];
    
    //add the transformer layer instructions, then add to video composition
    videoCompositionInstruction.layerInstructions = [NSArray arrayWithObject:videoCompositionLayerInstruction];
    videoComposition.instructions = [NSArray arrayWithObject: videoCompositionInstruction];
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
#warning when use (not AVAssetExportPresetPassthrough) AVAssetExportSession export video which is contain video and audio must add video track first,
#warning when add audio track frist error is -11841.
    AVMutableCompositionTrack *videoCompositionTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    NSError *error = nil;
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:&error];
    if (error) {
        NSLog(@"error is %@", error);
        return;
    }
    error = nil;
    AVMutableCompositionTrack *audioCompositionTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:audioAssetTrack atTime:kCMTimeZero error:&error];
    if (error) {
        NSLog(@"error is %@", error);
        return;
    }
    NSLog(@"the assetDuration is %lld", asset.duration.value/asset.duration.timescale);
    
    AVAssetExportSession *assetExportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality] ;
    assetExportSession.shouldOptimizeForNetworkUse = YES;
    assetExportSession.videoComposition = videoComposition;
    assetExportSession.outputURL = dstFileURL;
    assetExportSession.outputFileType = AVFileTypeMPEG4;
    
//    __weak AVAssetExportSession *weakAssetExportSession = assetExportSession;
//    __weak typeof(self)weakSelf = self;
    [assetExportSession exportAsynchronouslyWithCompletionHandler:^
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [FSAlertUtil hiddenLoading];
             NSLog(@"exporter.error >> %@",assetExportSession.error);
             
             switch ([assetExportSession status]) {
                 case AVAssetExportSessionStatusFailed:
                     NSLog(@"Export failed: %@", [[assetExportSession error] localizedDescription]);
                     break;
                     
                 case AVAssetExportSessionStatusCancelled:
                     NSLog(@"Export canceled");
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:{
                     NSLog(@"Export completed");
                     
                     // 保存到相册
                     UISaveVideoAtPathToSavedPhotosAlbum(dstFileURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                 }
                     break;
                     
                 default:
                     NSLog(@"Export other");

                     break;
             }
         });
     }];
}
 
- (CGAffineTransform)videoAssetTrackTransform:(AVAssetTrack *)videoAssetTrack {
    int degrees = [self degressFromVideoFileWithVideoAssetTrack:videoAssetTrack];
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (degrees != 0) {
        CGAffineTransform translateToCenter = CGAffineTransformIdentity;
        if (degrees == 90) {
            // 顺时针旋转90°
            translateToCenter = CGAffineTransformMakeTranslation(videoAssetTrack.naturalSize.height, 0.0);
            transform = CGAffineTransformRotate(translateToCenter, M_PI_2);
        } else if(degrees == 180){
            // 顺时针旋转180°
            translateToCenter = CGAffineTransformMakeTranslation(videoAssetTrack.naturalSize.width, videoAssetTrack.naturalSize.height);
            transform = CGAffineTransformRotate(translateToCenter, M_PI);
        } else if(degrees == 270){
            // 顺时针旋转270°
            translateToCenter = CGAffineTransformMakeTranslation(0.0, videoAssetTrack.naturalSize.width);
            transform = CGAffineTransformRotate(translateToCenter, M_PI_2 + M_PI);
        }else if(degrees == -180){
            // 绕x轴旋转180度
            //仿射变换的坐标为iOS的屏幕坐标x向右为正y向下为正
#if 1
            //transform = CGAffineTransformTranslate(transform, videoAssetTrack.naturalSize.width, videoAssetTrack.naturalSize.height);
            //transform = CGAffineTransformRotate(transform, 90/180.0f*M_PI); // 旋转90度
            //transform = CGAffineTransformScale(transform, 1.0, -1.0); // 上下颠倒视频
            //transform = CGAffineTransformScale(transform, -1.0, 1.0);  // 左右颠倒视频
            //transform = CGAffineTransformScale(transform, 1.0, 1.0); // 使用原始大小
            
            //原始视频
            //         ___
            //        |   |
            //        |   |
            //     -------------------- +x
            //    |
            //    |
            //    |
            //    |
            //    |
            //    |
            //    |
            //    +y
            
            //transform = CGAffineTransformScale(transform, 1.0, -1.0); // 上下颠倒视频
            
            //     -------------------- +x
            //    |   |   |
            //    |   |___|
            //    |
            //    |
            //    |
            //    |
            //    |
            //    +y
            
            //transform = CGAffineTransformTranslate(transform, 0, -videoAssetTrack.naturalSize.height);// 将视频平移到原始位置
            
            //         ___
            //        |   |
            //        |   |
            //     -------------------- +x
            //    |
            //    |
            //    |
            //    |
            //    |
            //    |
            //    |
            //    +y
            
            transform = CGAffineTransformScale(transform, 1.0, -1.0); // 上下颠倒视频
            transform = CGAffineTransformTranslate(transform, 0, -videoAssetTrack.naturalSize.height);
#else
            transform = videoAssetTrack.preferredTransform;
            transform = CGAffineTransformTranslate(transform, 0, -videoAssetTrack.naturalSize.height);
#endif
        }
    }
    
#if 0 - cropVideo
    //Here we shift the viewing square up to the TOP of the video so we only see the top
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(videoAssetTrack.naturalSize.height, 0 );
    
    //Use this code if you want the viewing square to be in the middle of the video
    //CGAffineTransform t1 = CGAffineTransformMakeTranslation(videoAssetTrack.naturalSize.height, -(videoAssetTrack.naturalSize.width - videoAssetTrack.naturalSize.height) /2 );
    
    //Make sure the square is portrait
    transform = CGAffineTransformRotate(t1, M_PI_2);
#endif
    
    return transform;
}
 
- (int)degressFromVideoFileWithVideoAssetTrack:(AVAssetTrack *)videoAssetTrack {
    int degress = 0;
    CGAffineTransform t = videoAssetTrack.preferredTransform;
    if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
        // Portrait
        degress = 90;
    } else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
        // PortraitUpsideDown
        degress = 270;
    } else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
        // LandscapeRight
        degress = 0;
    } else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
        // LandscapeLeft
        degress = 180;
    } else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
        // LandscapeLeft
        degress = 180;
    } else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
        // x-axis
        degress = -180;
    }
    
    return degress;
}

#pragma mark - UIVideoEditorControllerDelegate
- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath {
    NSLog(@"%s editedVideoPath : %@",__func__,editedVideoPath);
}

- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error {
    NSLog(@"%s",__func__);
}

- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor {
    NSLog(@"%s",__func__);
    [editor dismissViewControllerAnimated:YES completion:nil];
}

@end
