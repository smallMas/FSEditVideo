//
//  FSPlayerViewController.h
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/5.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSPlayerViewController : UIViewController
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) AVAsset *asset;
@end

NS_ASSUME_NONNULL_END
