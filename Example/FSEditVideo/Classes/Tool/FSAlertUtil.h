//
//  FSAlertUtil.h
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/4.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSAlertUtil : NSObject

/*! 显示提示语，一闪而逝 */
+ (void)showPromptInfo:(NSString *)info;

/*! 显示loading */
+ (void)showLoading;
/*! 隐藏loading */
+ (void)hiddenLoading;
@end

NS_ASSUME_NONNULL_END
