//
//  RBCoverChildView.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/21.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "RBCoverChildView.h"
#import "FSThumbnailSequenceView.h"

@interface RBCoverChildView () {
    CGFloat marginLR;
}

@property (nonatomic, strong) FSThumbnailSequenceView *sequnceView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) CGFloat duration;

@end

@implementation RBCoverChildView
- (void)dealloc
{
    [self.sequnceView removeScrollViewDelegate:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setup];
        [self layoutUI];
    }
    return self;
}

- (void)initData {
    marginLR = SCREENWIDTH*0.5;
}

- (void)setup {
    NSLog(@"%s",__FUNCTION__);
    self.sequnceView.startPadding = marginLR;
    self.sequnceView.endPadding = marginLR;
    [self addSubview:self.sequnceView];
    
    [self.lineView fsj_setRoundRadius:1 borderColor:[UIColor clearColor]];
    [self addSubview:self.lineView];
}

- (void)layoutUI {
    NSLog(@"%s",__FUNCTION__);
    [self.sequnceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(70);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(2);
        make.center.mas_equalTo(self);
    }];
}

#pragma mark - 懒加载
- (FSThumbnailSequenceView *)sequnceView {
    if (!_sequnceView) {
        _sequnceView = [FSThumbnailSequenceView new];
        [_sequnceView setShowsScrollIndicator:NO];
        [_sequnceView addScrollViewDelegate:(id <CHGScrollViewDelegate>)self];
    }
    return _sequnceView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:COLHEX(@"#FF6A1B")];
    }
    return _lineView;
}

#pragma mark - 外部调用
- (void)configTimeline:(FSTimeLine *)timeline {
    if (timeline) {
        // 计算
        _duration = timeline.duration;
//        CGFloat length = SCREENWIDTH-marginLR*2;
//        if (self.duration > maxSecond) {
//            length = (self.duration/maxSecond)*length;
//        }
//
//        everyLength = length/(self.duration/FS_TIME_BASE);
        
        [self.sequnceView configDivideTimeline:timeline block:^{
            
        }];
    }
}

#pragma mark - CHGScrollViewDelegate
- (void)chg_scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)chg_scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat w = scrollView.contentSize.width-marginLR-marginLR;
    CGFloat contentX = scrollView.contentOffset.x;
    CGFloat ratio = contentX/w;
    int64_t time = ratio*self.duration;
    if (time > self.duration ) {
        time = self.duration;
    }
    if (time < 0) {
        time = 0;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectCoverWithTime:)]) {
        [self.delegate selectCoverWithTime:time];
    }
}

- (void)chg_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)chg_scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

@end
