//
//  FSThumbnailManager.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/26.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "FSThumbnailManager.h"

@interface FSThumbnailManager () {
    dispatch_queue_t fetchQueue;
}

@end

@implementation FSThumbnailManager

+ (instancetype)shareInstance {
    static FSThumbnailManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [FSThumbnailManager new];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        fetchQueue = dispatch_queue_create("com.thumbnail.request", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)requestThumbnailWithTime:(CMTime)time timeline:(FSTimeLine *)timeline block:(FSThumbnailImageBlock)block {
    if (timeline) {
        dispatch_async(fetchQueue, ^{
            UIImage *image = [timeline getThumbnailImageWithTime:time];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(image);
                }
            });
        });
    }else {
        if (block) {
            block(nil);
        }
    }
}

@end
