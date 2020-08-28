//
//  RBCoverChildController.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/21.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "RBCoverChildController.h"

@interface RBCoverChildController ()
@property (nonatomic, strong) RBCoverChildView *coverView;
@end

@implementation RBCoverChildController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self layoutUI];
}

- (void)setupView {
    [self.view addSubview:self.coverView];
    [self.coverView configTimeline:self.timeline];
}

- (void)layoutUI {
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(100);
        make.left.right.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view);
    }];
}

- (void)setDelegate:(id)delegate {
    self.coverView.delegate = delegate;
}

#pragma mark - 懒加载
- (RBCoverChildView *)coverView {
    if (!_coverView) {
        _coverView = [[RBCoverChildView alloc] init];
    }
    return _coverView;
}

@end
