//
//  RBCoverController.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/19.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "RBCoverController.h"
#import "RBCoverContainView.h"
#import "RBCoverChildController.h"
#import "RBAlbumController.h"
#import "RBPhotoPickerController.h"
#import "FSTimeLine.h"
#import "FSStreamingContext.h"

@interface RBCoverController () <RBPhotoPickerControllerDelegate>
@property (nonatomic, strong) RBCoverContainView *headerView;
@property (nonatomic, strong) FSJTabContainView *containView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, strong) FSTimeLine *timeline;
@property (nonatomic, strong) FSStreamingContext *streamingContext;
@property (nonatomic, assign) BOOL isFirst;
@end

@implementation RBCoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initStreaming];
    [self setupView];
    [self layoutUI];
    
    self.isFirst = YES;
    [self.headerView configTimeline:self.timeline context:self.streamingContext];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.streamingContext playStartTime:0 endTime:self.timeline.duration];
}

- (void)initData {
    self.headerHeight = self.view.bounds.size.height * 0.6;
}

- (void)setupView {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.headerView setBackgroundColor:[UIColor blackColor]];
    [self.containView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.containView];
    
    [self.headerView configTitles:self.titleArray];
    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.titleArray.count; i++) {
        if (i == 0) {
            RBCoverChildController *vc = [RBCoverChildController new];
            vc.timeline = self.timeline;
            vc.delegate = (id <RBCoverChildViewDelegate>)self;
            [vcs addObject:vc];
        }else {
//            RBAlbumController *vc = [RBAlbumController new];
//            [vcs addObject:vc];
            
            RBPhotoPickerController *vc = [RBPhotoPickerController new];
            vc.isFirstAppear = YES;
            vc.columnNumber = 4;
            vc.delegate = (id <RBPhotoPickerControllerDelegate>)self;
            
            DN_WEAK_SELF
            [[TZImageManager manager] getCameraRollAlbum:YES
                                           allowPickingImage:YES
                                             needFetchAssets:NO
                                                  completion:^(TZAlbumModel *model) {
                    NSLog(@"model count >>> %ld",model.count);
                    DN_STRONG_SELF
                    vc.model = model;
                    [vcs addObject:vc];
            }];
        }
    }
    [self.containView configControllers:vcs parentController:self];
    [self.containView setScrollEnabled:NO];
    
    DN_WEAK_SELF
    [self.containView setSwitchBlock:^(NSInteger index) {
        DN_STRONG_SELF
        [self.headerView setSelectedIndex:index];
    }];
    
    [self.headerView setSelectedBlock:^(NSInteger index) {
        DN_STRONG_SELF
        [self.containView setTabIndex:index];
    }];
}

- (void)layoutUI {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(self.headerHeight);
    }];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headerView.mas_bottom);
    }];
}

- (void)initStreaming {
    int64_t duration = [FSCompoundTool getMediaDurationWithMediaURL:self.videoURL];
    [self.timeline appendVideoClip:self.videoURL.path trimIn:0 trimOut:duration];
    NSLog(@"duration >>>>> %lld",duration);
    AVAsset *asset = [AVAsset assetWithURL:self.videoURL];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = tracks[0];
    CGSize videoSize = CGSizeApplyAffineTransform(videoTrack.naturalSize, videoTrack.preferredTransform);
    videoSize = CGSizeMake(fabs(videoSize.width), fabs(videoSize.height));
    
    [self.headerView configVideoSize:videoSize];
}

#pragma mark - 懒加载
- (RBCoverContainView *)headerView {
    if (!_headerView) {
        _headerView = [[RBCoverContainView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.headerHeight)];
        _headerView.delegate = (id <RBCoverContainViewDelegate>)self;
    }
    return _headerView;
}

- (FSJTabContainView *)containView {
    if (!_containView) {
        _containView = [[FSJTabContainView alloc] init];
    }
    return _containView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"视频选取",@"本地上传"];
    }
    return _titleArray;
}

- (FSTimeLine *)timeline {
    if (!_timeline) {
        _timeline = [[FSTimeLine alloc] init];
    }
    return _timeline;
}

- (FSStreamingContext *)streamingContext {
    if (!_streamingContext) {
        _streamingContext = [[FSStreamingContext alloc] init];
        _streamingContext.delegate = (id <FSStreamingContextDelegate>) self;
    }
    return _streamingContext;
}

#pragma mark - 内部方法
- (void)getCoverImageBlock:(void (^)(UIImage *image))block {
    UIImage *img = [self.headerView getCoverImage];
    if (img) {
        // 相册封面
    }else {
        // 视频帧封面
        img = [self.timeline getImageWithTime:[self.streamingContext getCurrentTime]];
    }
    if (block) {
        block(img);
    }
}

#pragma mark - RBCoverContainViewDelegate
- (void)movePositionPointY:(CGFloat)y {
    if (self.headerView.currentIndex == 1) {
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).inset(y);
        }];
    }
}

- (void)endMoveType:(RBEndPositionType)type {
    if (self.headerView.currentIndex == 1) {
        [self updateType:type];
    }
}

- (void)updateType:(RBEndPositionType)type {
    FSJ_WEAK_SELF
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25 animations:^{
        FSJ_STRONG_SELF
        if (type == RBEndPositionTypeTop) {
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view).inset(-self.headerHeight+App_SafeTop_H+60);
            }];
        }else {
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view);
            }];
        }
        [self.headerView.superview layoutIfNeeded];
    }];
}

- (void)didTapCloseAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTapNextAction {
    DN_WEAK_SELF
    NSLog(@"------------1");
    [self getCoverImageBlock:^(UIImage *image) {
        NSLog(@"------------2");
        DN_STRONG_SELF
        if (self.eventTransmissionBlock) {
            self.eventTransmissionBlock(self, image, 0, nil);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - RBCoverChildViewDelegate
- (void)selectCoverWithTime:(int64_t)time {
    [self.headerView setCoverImage:nil];
    [self.streamingContext seekToTime:time];
}

#pragma mark - RBPhotoPickerControllerDelegate
- (void)photoPickerController:(RBPhotoPickerController *)picker didFinishPickingAssets:(NSArray <PHAsset *>*)assets {
    PHAsset *asset = assets.firstObject;
    if (asset) {
        DN_WEAK_SELF
        [FSAlertUtil showLoading];
        [FSVideoImageTool getImageWithAsset:asset block:^(UIImage * _Nonnull image) {
            DN_STRONG_SELF
            [FSAlertUtil hiddenLoading];
            [self.headerView setCoverImage:image];
        }];
    }
}

@end
