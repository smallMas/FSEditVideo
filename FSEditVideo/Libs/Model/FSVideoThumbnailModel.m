//
//  FSVideoThumbnailModel.m
//  FSGPUImage
//
//  Created by 燕来秋 on 2020/7/16.
//  Copyright © 2020 燕来秋. All rights reserved.
//

#import "FSVideoThumbnailModel.h"
#import "FSTimeLine.h"

@implementation FSVideoThumbnailModel

- (void)getThumbnailImageWithTimeLine:(FSTimeLine *)timeline block:(void (^)(UIImage *image))block {
    if (_thumbnailImage) {
        if (block) {
            block(_thumbnailImage);
        }
    }else {
        if (timeline) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *image = [timeline getThumbnailImageWithTime:self.time];
                _thumbnailImage = image;
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
}

@end
