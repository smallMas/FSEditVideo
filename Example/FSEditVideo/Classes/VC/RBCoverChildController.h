//
//  RBCoverChildController.h
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/21.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTimeLine.h"
#import "RBCoverChildView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBCoverChildController : UIViewController

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) FSTimeLine *timeline;

@end

NS_ASSUME_NONNULL_END
