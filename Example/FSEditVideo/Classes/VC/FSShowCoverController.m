//
//  FSShowCoverController.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/28.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "FSShowCoverController.h"

@interface FSShowCoverController ()
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation FSShowCoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGSize size = [self getSize];
    [self.view addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
        make.center.mas_equalTo(self.view);
    }];
    [self.imgView setImage:self.coverImage];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(nextAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (CGSize)getSize {
    CGSize videoSize = self.coverImage.size;
    
    CGFloat height = self.view.bounds.size.height - App_SafeTop_H - 44;
    CGFloat width = self.view.bounds.size.width - 40;

    CGFloat r1 = width/(CGFloat)videoSize.width;
    CGFloat r2 = height/(CGFloat)videoSize.height;

    CGFloat w = width;
    CGFloat h = height;
    if (r1 > r2) {
        h = height;
        w = videoSize.width/(CGFloat)videoSize.height*h;
    }else {
        w = width;
        h = videoSize.height/(CGFloat)videoSize.width*w;
    }
    return CGSizeMake(w, h);
}

- (void)nextAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
