//
//  FSThumbnailManager.h
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/26.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSTimeLine.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ FSThumbnailImageBlock) (UIImage * __nullable thumbnailImage);

@interface FSThumbnailManager : NSObject

+ (instancetype)shareInstance;

- (void)requestThumbnailWithTime:(CMTime)time timeline:(FSTimeLine *)timeline block:(FSThumbnailImageBlock)block;

@end

NS_ASSUME_NONNULL_END
