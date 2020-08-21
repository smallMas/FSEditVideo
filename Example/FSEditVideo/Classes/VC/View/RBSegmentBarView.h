//
//  RBSegmentBarView.h
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/21.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ RBSegmentSelectedBlock) (NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface RBSegmentBarView : UIView
@property (nonatomic, copy) RBSegmentSelectedBlock selectedBlock;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
- (void)configTitles:(NSArray *)titles;
- (void)setSelectedIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
