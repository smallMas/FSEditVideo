//
//  UIViewController+FSEVENT.h
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/18.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (FSEVENT)

@property(nonatomic,copy)CHGEventTransmissionBlock eventTransmissionBlock;

@end

NS_ASSUME_NONNULL_END
