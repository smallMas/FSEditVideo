//
//  FSVideoThumbnailModel.h
//  FSGPUImage
//
//  Created by 燕来秋 on 2020/7/16.
//  Copyright © 2020 燕来秋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSVideoThumbnailModel : NSObject 
@property (nonatomic, strong, readonly) UIImage *thumbnailImage;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CMTime time;
@property (nonatomic, assign) BOOL isThumbnail;
- (void)getThumbnailImageWithTimeLine:(FSTimeLine *)timeline block:(void (^)(UIImage *image))block;
@end

NS_ASSUME_NONNULL_END
