//
//  FSBottomView.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/18.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "FSBottomView.h"

@interface FSBottomView ()

@property (nonatomic, strong) UIButton *clipBtn;
@property (nonatomic, strong) UIButton *coverBtn;

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
    [self.clipBtn fsj_setRoundRadius:3.0 borderColor:[UIColor clearColor]];
    [self.coverBtn fsj_setRoundRadius:3.0 borderColor:[UIColor clearColor]];
    [self.clipBtn setBackgroundColor:[UIColor fsj_randomColor]];
    [self.coverBtn setBackgroundColor:[UIColor fsj_randomColor]];
    [self addSubview:self.clipBtn];
    [self addSubview:self.coverBtn];
}

- (void)layoutUI {
    [self.clipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).inset(10);
    }];
    
    [self.coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).inset(10);
    }];
}

#pragma mark - 懒加载
- (UIButton *)clipBtn {
    if (!_clipBtn) {
        _clipBtn = [UIButton fsj_createWithType:UIButtonTypeCustom target:self action:@selector(clipVideo:)];
        [_clipBtn setTitle:@"裁剪" forState:UIControlStateNormal];
    }
    return _clipBtn;
}

- (UIButton *)coverBtn {
    if (!_coverBtn) {
        _coverBtn = [UIButton fsj_createWithType:UIButtonTypeCustom target:self action:@selector(selectedCover:)];
        [_coverBtn setTitle:@"封面" forState:UIControlStateNormal];
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
