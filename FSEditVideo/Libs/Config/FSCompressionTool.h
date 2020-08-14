//
//  FSCompressionTool.h
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/14.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSCompressionTool : NSObject
+ (void)compressVideoWithVideoUrl:(NSURL *)videoUrl withBiteRate:(NSNumber * _Nullable)outputBiteRate withFrameRate:(NSNumber * _Nullable)outputFrameRate withVideoWidth:(NSNumber * _Nullable)outputWidth withVideoHeight:(NSNumber * _Nullable)outputHeight compressComplete:(void(^)(id responseObjc))compressComplete;
@end

NS_ASSUME_NONNULL_END
