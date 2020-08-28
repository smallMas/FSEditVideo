//
//  RBIconButton.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/28.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "RBIconButton.h"

@interface RBIconButton ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation RBIconButton

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
    [self addSubview:self.iconView];
    [self addSubview:self.titleLabel];
}

- (void)layoutUI {
    CGFloat iconWH = 30.0;
    CGFloat spaceH = 5.0f;
    CGFloat titleH = 21.0f;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(iconWH);
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(-(spaceH+titleH)*0.5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(titleH);
        make.centerY.mas_equalTo(self).offset((spaceH+iconWH)*0.5);
    }];
}

#pragma mark - 懒加载
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [UIImageView new];
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:COLHEX(@"#333333")];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

#pragma mark - 外部调用
- (void)setImage:(UIImage *)image {
    [self.iconView setImage:image];
    if (image) {
        [self.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(image.size.width);
            make.height.mas_equalTo(image.size.height);
        }];
    }
}

- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}

@end
