//
//  RBCoverContainView.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/19.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "RBCoverContainView.h"

@interface RBCoverContainView ()

@property (nonatomic, strong) UIView *headerView;
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
    [self.headerView setBackgroundColor:[UIColor fsj_randomColor]];
    [self.headerView addSubview:self.imgView];
    [self.barView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.headerView];
    [self addSubview:self.barView];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognize:)];//初始化平移手势识别器(Pan)
    panGestureRecognizer.delegate = (id <UIGestureRecognizerDelegate>) self;
    [self.barView addGestureRecognizer:panGestureRecognizer];
}

- (void)layoutUI {
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.barView.mas_top);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.headerView).inset(20);
    }];
}

#pragma mark - 懒加载
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
    }
    return _headerView;
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

#pragma mark - 外部调用
- (void)configTitles:(NSArray *)titles {
    [self.barView configTitles:titles];
}

- (void)setSelectedIndex:(NSInteger)index {
    [self.barView setSelectedIndex:index];
}

- (void)setCoverImage:(UIImage *)image {
    [self.imgView setImage:image];
}

@end
