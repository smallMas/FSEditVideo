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
#import "FSTimeLine.h"

@interface RBCoverController ()
@property (nonatomic, strong) RBCoverContainView *headerView;
@property (nonatomic, strong) FSJTabContainView *containView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, strong) FSTimeLine *timeline;
@end

@implementation RBCoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initStreaming];
    [self initData];
    [self setupView];
    [self layoutUI];
}

- (void)initData {
    self.headerHeight = self.view.bounds.size.height * 0.6;
}

- (void)setupView {
    [self.containView setBackgroundColor:[UIColor fsj_randomColor]];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.containView];
    
    [self.headerView configTitles:self.titleArray];
    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.titleArray.count; i++) {
        if (i == 0) {
            RBCoverChildController *vc = [RBCoverChildController new];
            vc.timeline = self.timeline;
            [vcs addObject:vc];
        }else {
            RBAlbumController *vc = [RBAlbumController new];
//            vc.eventTransmissionBlock = ^id(id target, id params, NSInteger tag, CHGCallBack callBack) {
//                if (tag == RBAlbumActionTypeScrollUp) {
//
//                }
//                return nil;
//            };
            [vcs addObject:vc];
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
    
    // 连接
//    [self.streamingContext connectionTimeLine:self.timeline playerView:self.playerView];
}

#pragma mark - 懒加载
- (RBCoverContainView *)headerView {
    if (!_headerView) {
        _headerView = [RBCoverContainView new];
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

@end
