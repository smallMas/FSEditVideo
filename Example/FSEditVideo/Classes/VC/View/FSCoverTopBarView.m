//
//  FSCoverTopBarView.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/25.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "FSCoverTopBarView.h"

@implementation FSCoverTopBarView

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
    [self addSubview:self.closeBtn];
    [self addSubview:self.nextBtn];
}

- (void)layoutUI {
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.width.height.mas_equalTo(44);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).inset(20);
        make.centerY.mas_equalTo(self.closeBtn);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"pb_icon_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn setBackgroundColor:COLHEX(@"#FF5757")];
        [_nextBtn fsj_setRoundRadius:3 borderColor:[UIColor clearColor]];
    }
    return _nextBtn;
}

@end
