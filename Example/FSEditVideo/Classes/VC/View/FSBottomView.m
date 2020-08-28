//
//  FSBottomView.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/18.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "FSBottomView.h"
#import "RBIconButton.h"

@interface FSBottomView ()

@property (nonatomic, strong) RBIconButton *clipBtn;
@property (nonatomic, strong) RBIconButton *coverBtn;

@end

@implementation FSBottomView

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
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.clipBtn];
    [self addSubview:self.coverBtn];
}

- (void)layoutUI {
//    [self.clipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(60);
//        make.height.mas_equalTo(40);
//        make.centerY.mas_equalTo(self);
//        make.left.mas_equalTo(self).inset(10);
//    }];
//
//    [self.coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(60);
//        make.height.mas_equalTo(40);
//        make.centerY.mas_equalTo(self);
//        make.right.mas_equalTo(self).inset(10);
//    }];
    
    NSArray *array = @[self.clipBtn, self.coverBtn];
    [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(60);
    }];
}

#pragma mark - 懒加载
- (RBIconButton *)clipBtn {
    if (!_clipBtn) {
        _clipBtn = [RBIconButton new];
        [_clipBtn addTarget:self action:@selector(clipVideo:) forControlEvents:UIControlEventTouchUpInside];
        [_clipBtn setImage:[UIImage imageNamed:@"pb_video_icon"]];
        [_clipBtn setTitle:@"裁剪"];
    }
    return _clipBtn;
}

- (RBIconButton *)coverBtn {
    if (!_coverBtn) {
        _coverBtn = [RBIconButton new];
        [_coverBtn addTarget:self action:@selector(selectedCover:) forControlEvents:UIControlEventTouchUpInside];
        [_coverBtn setImage:[UIImage imageNamed:@"pb_cover_icon"]];
        [_coverBtn setTitle:@"封面"];
    }
    return _coverBtn;
}

#pragma mark - btn action
- (void)clipVideo:(id)sender {
    if (self.eventTransmissionBlock) {
        self.eventTransmissionBlock(self, nil, FSBottomActionTypeClip, nil);
    }
}

- (void)selectedCover:(id)sender {
    if (self.eventTransmissionBlock) {
        self.eventTransmissionBlock(self, nil, FSBottomActionTypeCover, nil);
    }
}

@end
