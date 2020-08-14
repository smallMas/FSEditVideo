//
//  FSItemView.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/12.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "FSItemView.h"

@implementation FSItemView

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
    [self addSubview:self.iconBtn];
    [self addSubview:self.textLabel];
}

- (void)layoutUI {
    CGFloat iconWH = 24.0f;
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(iconWH);
        make.height.mas_equalTo(iconWH);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconBtn.mas_bottom).inset(6);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self);
    }];
}

#pragma mark - 懒加载
- (UIButton *)iconBtn {
    if (!_iconBtn) {
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _iconBtn;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel fsj_createFont:[UIFont systemFontOfSize:10] color:COLHEX(@"#FFFFFF") alignment:NSTextAlignmentCenter];
    }
    return _textLabel;
}

#pragma mark - 外部调用
- (void)configIcon:(UIImage *)icon text:(NSString *)text {
    [self.iconBtn setImage:icon forState:UIControlStateNormal];
    [self.textLabel setText:text];
    
    [self.iconBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(icon.size.width);
        make.height.mas_equalTo(icon.size.height);
    }];
}

@end
