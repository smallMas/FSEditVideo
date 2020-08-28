//
//  FSPlayWindow.h
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/27.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSPlayWindow : UIView
@property (nonatomic, strong, readonly) UIView *playerView;

- (void)reloadPlaySize:(CGSize)videoSize;

@end

NS_ASSUME_NONNULL_END
