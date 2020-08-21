//
//  RBCoverContainView.h
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/19.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBSegmentBarView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RBEndPositionType) {
    RBEndPositionTypeTop,
    RBEndPositionTypeBottom,
};

@protocol RBCoverContainViewDelegate <NSObject>

- (void)movePositionPointY:(CGFloat)y;
- (void)endMoveType:(RBEndPositionType)type;

@end

@interface RBCoverContainView : UIView
@property (nonatomic, copy) RBSegmentSelectedBlock selectedBlock;
@property (nonatomic, weak) id <RBCoverContainViewDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
- (void)configTitles:(NSArray *)titles;
- (void)setSelectedIndex:(NSInteger)index;
- (void)setCoverImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
