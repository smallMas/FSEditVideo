//
//  FSPlayWindow.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/27.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "FSPlayWindow.h"

@interface FSPlayWindow ()

@property (nonatomic, assign) CGSize videoSize;

@end

@implementation FSPlayWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        _playerView = [[UIView alloc] init];
        [self addSubview:self.playerView];
    }
    return self;
}

- (void)reloadPlaySize:(CGSize)videoSize {
    _videoSize = videoSize;
    [self resetSize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self resetSize];
}

- (void)resetSize {
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;

    CGSize videoSize = self.videoSize;
    
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
    
    CGFloat x = (width-w)*0.5;
    CGFloat y = (height-h)*0.5;
    [self.playerView setFrame:CGRectMake(x, y, w, h)];
}

@end
