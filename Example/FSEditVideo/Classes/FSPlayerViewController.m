//
//  FSPlayerViewController.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/5.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "FSPlayerViewController.h"
#import "DNPlayerView.h"

@interface FSPlayerViewController ()
@property (nonatomic, strong) DNPlayerView *playerView;
@end

@implementation FSPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _playerView = [[DNPlayerView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.playerView];
    
    if (self.URL) {
       [self.playerView playWithUrl:self.URL];
    }else {
        [self.playerView playWithAsset:self.asset];
    }
}

@end
