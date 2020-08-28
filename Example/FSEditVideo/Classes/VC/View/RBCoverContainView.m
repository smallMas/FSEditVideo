//
//  RBCoverContainView.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/19.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "RBCoverContainView.h"
#import "FSCoverTopBarView.h"

@interface RBCoverContainView ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) FSCoverTopBarView *topView;
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) RBSegmentBarView *barView;
@property (nonatomic, assign) CGFloat startY;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation RBCoverContainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self layoutUI];
    }
    return self;
}

- (void)setup {
    [self addSubview:self.topView];
    [self.headerView setBackgroundColor:[UIColor whiteColor]];
    [self.headerView addSubview:self.imgView];
    [self.headerView addSubview:self.playerView];
    [self.barView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.headerView];
    [self addSubview:self.barView];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognize:)];//初始化平移手势识别器(Pan)
    panGestureRecognizer.delegate = (id <UIGestureRecognizerDelegate>) self;
    [self.barView addGestureRecognizer:panGestureRecognizer];
    
    [self setCoverImage:nil];
}

- (void)layoutUI {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).inset(App_SafeTop_H);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.barView.mas_top);
    }];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(0);
        make.center.mas_equalTo(self.headerView);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(0);
        make.center.mas_equalTo(self.headerView);
    }];
}

#pragma mark - 懒加载
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
    }
    return _headerView;
}

- (FSCoverTopBarView *)topView {
    if (!_topView) {
        _topView = [FSCoverTopBarView new];
        [_topView.closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topView.nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}

- (UIView *)playerView {
    if (!_playerView) {
        _playerView = [[UIView alloc] init];
    }
    return _playerView;
}

- (RBSegmentBarView *)barView {
    if (!_barView) {
        _barView = [[RBSegmentBarView alloc] init];
    }
    return _barView;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

#pragma mark - set
- (void)setSelectedBlock:(RBSegmentSelectedBlock)selectedBlock {
    [self.barView setSelectedBlock:selectedBlock];
}

- (NSInteger)currentIndex {
    return self.barView.currentIndex;
}

#pragma mark - EVENT
- (void)panGestureRecognize:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        // 开始
        self.startY = self.frame.origin.y;
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint currentPoint = [sender translationInView:self.superview];
        CGFloat y = self.startY + currentPoint.y;
        
        if (y > 0) {
            y = 0;
        }

        [self updatePositionY:y];
    }else {
        [self endDrag];
    }
}

- (void)updatePositionY:(CGFloat)y {
    if (self.delegate && [self.delegate respondsToSelector:@selector(movePositionPointY:)]) {
        [self.delegate movePositionPointY:y];
    }
}

- (void)endDrag {
    CGFloat currentY = self.frame.origin.y;
    BOOL isUp = currentY < self.startY;
    
    CGFloat standard = 30;
    
    RBEndPositionType type = RBEndPositionTypeTop;
    if (isUp) {
        // 向上滑动
        CGFloat space = self.startY - currentY;
        if (space >= standard) {
            type = RBEndPositionTypeTop;
        }else {
            type = RBEndPositionTypeBottom;
        }
    }else {
        // 向下滑动
        CGFloat space = currentY - self.startY;
        if (space >= standard) {
            type = RBEndPositionTypeBottom;
        }else {
            type = RBEndPositionTypeTop;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(endMoveType:)]) {
        [self.delegate endMoveType:type];
    }
}

- (void)closeAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapCloseAction)]) {
        [self.delegate didTapCloseAction];
    }
}

- (void)nextAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapNextAction)]) {
        [self.delegate didTapNextAction];
    }
}

#pragma mark - 外部调用
- (void)configTitles:(NSArray *)titles {
    [self.barView configTitles:titles];
}

- (void)setSelectedIndex:(NSInteger)index {
    [self.barView setSelectedIndex:index];
}

- (void)setCoverImage:(UIImage *)image {
    if (image) {
        self.playerView.hidden = YES;
        self.imgView.hidden = NO;
        
        [self calculeCoverSize:image.size];
    }else {
        self.playerView.hidden = NO;
        self.imgView.hidden = YES;
    }
    
    [self.imgView setImage:image];
}

- (void)calculeCoverSize:(CGSize)size {
    CGFloat height = self.bounds.size.height - 60 - 40*2 - App_SafeTop_H;
    CGFloat width = self.bounds.size.width - 40*2;

    CGFloat r1 = width/(CGFloat)size.width;
    CGFloat r2 = height/(CGFloat)size.height;

    CGFloat w = width;
    CGFloat h = height;
    if (r1 > r2) {
        h = height;
        w = size.width/(CGFloat)size.height*h;
    }else {
        w = width;
        h = size.height/(CGFloat)size.width*w;
    }
    [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(w);
        make.height.mas_equalTo(h);
    }];
    [self.imgView layoutIfNeeded];
}

- (void)configVideoSize:(CGSize)videoSize {
    CGFloat height = self.bounds.size.height - 60 - 40*2 - App_SafeTop_H;
    CGFloat width = self.bounds.size.width - 40*2;

    CGFloat r1 = width/(CGFloat)videoSize.width;
    CGFloat r2 = height/(CGFloat)videoSize.height;

    CGFloat w = width;
    CGFloat h = height;
    if (r1 > r2) {
        h = height;
        w = videoSize.width/(CGFloat)videoSize.height*h;
    }else {
        w = width;
        h = videoSize.height/(CGFloat)videoSize.width*w;
    }
    [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(w);
        make.height.mas_equalTo(h);
    }];
    [self.playerView layoutIfNeeded];
}

- (void)configTimeline:(FSTimeLine *)timeline context:(FSStreamingContext *)context {
    [context connectionTimeLine:timeline playerView:self.playerView];
}

- (UIImage *)getCoverImage {
    UIImage *image = nil;
    if (!self.imgView.hidden) {
        image = self.imgView.image;
    }
    return image;
}

@end
