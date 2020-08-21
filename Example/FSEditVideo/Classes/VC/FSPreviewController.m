//
//  FSPreviewController.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/18.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "FSPreviewController.h"
#import "FSStreamingContext.h"
#import "FSTimeLine.h"
#import "FSBottomView.h"
#import "RBClipVideoController.h"
#import "RBCoverController.h"

@interface FSPreviewController ()

@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) FSBottomView *bottomView;

@property (nonatomic, strong) FSStreamingContext *streamingContext;
@property (nonatomic, strong) FSTimeLine *timeline;

@property (nonatomic, strong) NSString *clipPath;

@end

@implementation FSPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    [self layoutUI];
    [self initStreaming];
}

- (void)setupView {
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.bottomView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(nextAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    FSJ_WEAK_SELF
    self.bottomView.eventTransmissionBlock = ^id(id target, id params, NSInteger tag, CHGCallBack callBack) {
        FSJ_STRONG_SELF
        if (tag == FSBottomActionTypeClip) {
            [self gotoClip];
        }else if (tag == FSBottomActionTypeCover) {
            [self gotoCover];
        }
        return nil;
    };
}

- (void)layoutUI {
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(App_SafeBottom_H+50);
    }];
}

- (void)initStreaming {
    int64_t duration = [FSCompoundTool getMediaDurationWithMediaURL:self.videoURL];
    NSLog(@"duration >>>> %lld",duration);
    [self.timeline appendVideoClip:self.videoURL.path trimIn:0 trimOut:duration];
    
    // 连接
    [self.streamingContext connectionTimeLine:self.timeline playerView:self.playerView];
}

#pragma mark - 懒加载
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

- (FSBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [FSBottomView new];
    }
    return _bottomView;
}

#pragma mark - btn action
- (void)closeAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextAction:(id)sender {
    
}

- (void)gotoClip {
    FSJ_WEAK_SELF
    RBClipVideoController *vc = [RBClipVideoController new];
    vc.videoURL = self.videoURL;
    vc.eventTransmissionBlock = ^id(id target, id params, NSInteger tag, CHGCallBack callBack) {
        FSJ_STRONG_SELF
        if (tag == 0) {
            // 裁剪返回的字段
            self.clipPath = params;
        }
        return nil;
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)gotoCover {
    FSJ_WEAK_SELF
    RBCoverController *vc = [RBCoverController new];
    vc.videoURL = self.videoURL;
    vc.eventTransmissionBlock = ^id(id target, id params, NSInteger tag, CHGCallBack callBack) {
        FSJ_STRONG_SELF
        if (tag == 0) {
            // 封面image
        }
        return nil;
    };
    [self presentViewController:vc animated:YES completion:nil];
}

@end
