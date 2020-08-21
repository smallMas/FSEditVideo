//
//  UIViewController+FSEVENT.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/18.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "UIViewController+FSEVENT.h"
#import <objc/message.h>

static const void * eventTransmissionBlockKey = &eventTransmissionBlockKey;
@implementation UIViewController (FSEVENT)
- (void)setEventTransmissionBlock:(CHGEventTransmissionBlock)eventTransmissionBlock {
    objc_setAssociatedObject(self, eventTransmissionBlockKey, eventTransmissionBlock, OBJC_ASSOCIATION_COPY);
}

- (CHGEventTransmissionBlock)eventTransmissionBlock {
    return objc_getAssociatedObject(self, eventTransmissionBlockKey);
}
@end
