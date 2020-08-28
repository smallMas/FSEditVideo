//
//  RBCoverChildView.h
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/21.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTimeLine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RBCoverChildViewDelegate <NSObject>

@optional
- (void)selectCoverWithTime:(int64_t)time;

@end

@interface RBCoverChildView : UIView

@property (nonatomic, weak) id <RBCoverChildViewDelegate> delegate;

- (void)configTimeline:(FSTimeLine *)timeline;

@end

NS_ASSUME_NONNULL_END
