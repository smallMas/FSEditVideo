//
//  FSItemView.h
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/12.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSItemView : UIControl
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *textLabel;
- (void)configIcon:(UIImage *)icon text:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
