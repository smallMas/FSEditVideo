//
//  FSPreviewController.h
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/18.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSPreviewController : UIViewController

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) AVAsset *asset;

@end

NS_ASSUME_NONNULL_END
