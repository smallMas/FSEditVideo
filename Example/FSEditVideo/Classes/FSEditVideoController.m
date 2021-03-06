//
//  FSEditVideoController.m
//  FSGPUImage
//
//  Created by 燕来秋 on 2020/7/14.
//  Copyright © 2020 燕来秋. All rights reserved.
//

#import "FSEditVideoController.h"
#import "FSStreamingContext.h"
#import "FSTimeLine.h"
#import "FSItemView.h"

@interface FSEditVideoController () <FSStreamingContextDelegate>
// 关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIView *playerView;

@property (nonatomic, strong) FSStreamingContext *streamingContext;
@property (nonatomic, strong) FSTimeLine *timeline;

@property (nonatomic, strong) FSItemView *coverView;

@end

@implementation FSEditVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"edit start >>> %lld  end >>> %lld",self.recordingInfo.trimIn,self.recordingInfo.trimOut);
    [self setupView];
    [self layoutUI];
    [self initStreaming];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self replay];
}

- (void)setupView {
    [self.playerView setBackgroundColor:[UIColor fsj_randomColor]];
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.closeBtn];
    
    [self.view addSubview:self.coverView];
    [self.coverView configIcon:[UIImage imageNamed:@"pb_icon_cover"] text:@"封面"];
}

- (void)layoutUI {
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(45);
        make.width.height.mas_equalTo(44);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).inset(20);
        make.centerY.mas_equalTo(self.closeBtn);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(self.view).inset(30);
        make.bottom.mas_equalTo(self.view).inset(30+App_SafeBottom_H);
    }];
}

- (void)initStreaming {
    [self.timeline appendVideoClip:self.recordingInfo.recordingURL.path trimIn:self.recordingInfo.trimIn trimOut:self.recordingInfo.trimOut];
    
//    NSURL *musicURL = [[NSBundle mainBundle] URLForResource:@"百花香.mp3" withExtension:nil];
//    if (musicURL) {
//        [self.timeline appendAudioClip:musicURL.path trimIn:self.recordingInfo.trimIn trimOut:self.recordingInfo.trimOut];
//    }
    
    // 连接
    [self.streamingContext connectionTimeLine:self.timeline playerView:self.playerView];
}

#pragma mark - 懒加载
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton fsj_createWithType:UIButtonTypeCustom target:self action:@selector(closeAction:)];
        [_closeBtn setImage:[UIImage imageNamed:@"pb_icon_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton fsj_createWithType:UIButtonTypeCustom target:self action:@selector(nextAction:)];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn setBackgroundColor:COLHEX(@"#FF5757")];
        [_nextBtn fsj_setRoundRadius:3 borderColor:[UIColor clearColor]];
    }
    return _nextBtn;
}

- (UIView *)playerView {
    if (!_playerView) {
        _playerView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _playerView;
}

- (FSStreamingContext *)streamingContext {
    if (!_streamingContext) {
        _streamingContext = [[FSStreamingContext alloc] init];
        _streamingContext.delegate = (id <FSStreamingContextDelegate>) self;
    }
    return _streamingContext;
}

- (FSTimeLine *)timeline {
    if (!_timeline) {
        _timeline = [[FSTimeLine alloc] init];
    }
    return _timeline;
}

- (FSItemView *)coverView {
    if (!_coverView) {
        _coverView = [[FSItemView alloc] init];
    }
    return _coverView;
}

#pragma mark - btn action
- (void)closeAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextAction:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    [self stop];
    [FSAlertUtil showLoading];
    NSString *outPut = [FSPathTool folderVideoPathWithName:DNRecordCompoundFolder fileName:nil];
    [self.streamingContext compileVideoOutPutPath:outPut block:^(BOOL isSuccess, NSString *path) {
        [FSAlertUtil hiddenLoading];
        NSLog(@"path >>> %@",path);
        if (isSuccess) {
            NSLog(@"合成成功 : %@",path);
            // 保存到相册
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = error ? @"保存视频失败" : @"保存视频成功";
    [FSAlertUtil showPromptInfo:msg];
    if (!error) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    NSLog(@"%@",msg);
}

#pragma mark - 内部方法
- (void)replay {
//    [self.streamingContext playStartTime:self.recordingInfo.trimIn endTime:self.recordingInfo.trimOut];
    [self.streamingContext playStartTime:0 endTime:self.recordingInfo.trimOut-self.recordingInfo.trimIn];
}

- (void)stop {
    [self.streamingContext stop];
}

#pragma mark - FSStreamingContextDelegate
- (void)didPlaybackTimelinePosition:(FSTimeLine *)timeline position:(int64_t)positio {
    
}

- (void)didPlaybackStopped:(FSTimeLine *)timeline {
    
}

- (void)didPlaybackEOF:(FSTimeLine *)timeline {
    [self replay];
}

@end
