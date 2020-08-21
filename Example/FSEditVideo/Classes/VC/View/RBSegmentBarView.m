//
//  RBSegmentBarView.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/21.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "RBSegmentBarView.h"

@interface RBSegmentBarView ()

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation RBSegmentBarView

- (void)configTitles:(NSArray *)titles {
    [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.titleArray = titles;
    [self.buttonArray removeAllObjects];
    [self.bottomLineView removeFromSuperview];
    
    for (NSString *string in self.titleArray) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = [self.titleArray indexOfObject:string];
        [btn setTitle:string forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.buttonArray addObject:btn];
    }
    [self addSubview:self.bottomLineView];
    [self setSelectedIndex:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.bounds.size.width/(CGFloat)self.buttonArray.count;
    for (NSInteger i = 0; i < self.buttonArray.count; i++) {
        CGFloat x = i*w;
        UIButton *btn = self.buttonArray[i];
        [btn setFrame:CGRectMake(x, 0, w, self.bounds.size.height)];
    }
    
    if (self.currentIndex < self.buttonArray.count) {
        UIButton *btn = self.buttonArray[self.currentIndex];
        [self updateLineWithBtn:btn];
    }
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}

- (void)tapAction:(UIButton *)btn {
    NSInteger index = btn.tag;
    [self setSelectedIndex:index];
    if (self.selectedBlock) {
        self.selectedBlock(index);
    }
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 3)];
        [_bottomLineView setBackgroundColor:[UIColor redColor]];
        [_bottomLineView fsj_setRoundRadius:1.5 borderColor:[UIColor clearColor]];
    }
    return _bottomLineView;
}

- (void)setSelectedIndex:(NSInteger)index {
    _currentIndex = index;
    DN_WEAK_SELF
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DN_STRONG_SELF
        obj.selected = index == idx;
        if (index == idx) {
            [self updateLineWithBtn:obj];
        }
    }];
}

- (void)updateLineWithBtn:(UIButton *)obj {
    CGRect btnRect = obj.frame;
    CGRect lineRect = self.bottomLineView.frame;
    lineRect.origin.x = btnRect.origin.x + (btnRect.size.width-lineRect.size.width)*0.5;
    lineRect.origin.y = btnRect.origin.y + (btnRect.size.height-lineRect.size.height);
    [self.bottomLineView setFrame:lineRect];
}

@end
