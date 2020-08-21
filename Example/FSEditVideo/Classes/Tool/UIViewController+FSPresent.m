//
//  UIViewController+FSPresent.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/18.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "UIViewController+FSPresent.h"
#import <objc/runtime.h>

@implementation UIViewController (FSPresent)
+(void)load
{
    Method present = class_getInstanceMethod(self, @selector(presentViewController:animated:completion:));
    Method swizzNewPresent = class_getInstanceMethod(self, @selector(DJPresentViewController:Animated:completion:));
    method_exchangeImplementations(present, swizzNewPresent);
}
-(void)DJPresentViewController:(UIViewController *)viewcontroller Animated:(BOOL)animated completion:(void (^)(void))completion{
    if (@available(iOS 13.0, *)) {
        if (viewcontroller.modalPresentationStyle != UIModalPresentationOverCurrentContext) {
            viewcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        [self DJPresentViewController:viewcontroller Animated:animated completion:completion];
    }else{
        [self DJPresentViewController:viewcontroller Animated:animated completion:completion];
    }
}
@end
