//
//  FSCameraViewController.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/9/22.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "FSCameraViewController.h"
#import "FSLiveWindow.h"

@interface FSCameraViewController ()
@property (nonatomic, strong) FSLiveWindow *liveWindow;
@end

@implementation FSCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.liveWindow];
    
    [self.liveWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.liveWindow startRunning];
}

- (FSLiveWindow *)liveWindow {
    if (!_liveWindow) {
        _liveWindow = [[FSLiveWindow alloc] init];
        _liveWindow.isCanZoom = YES;
    }
    return _liveWindow;
}

@end
