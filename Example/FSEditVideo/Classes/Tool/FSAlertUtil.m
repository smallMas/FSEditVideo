//
//  FSAlertUtil.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/4.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "FSAlertUtil.h"
#import "MBProgressHUD.h"

@implementation FSAlertUtil

// 显示提示语，一闪而逝
+ (void)showPromptInfo:(NSString *)info {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = nil;
    hud.detailsLabel.text = info;
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabel.textColor = COLHEX(@"#FFFFFF");
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    hud.bezelView.layer.cornerRadius = 8;
//    hud.bezelView.layer.opacity = 0.5;
    hud.minSize = CGSizeMake(160, 45);
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = COLHEXA(@"#000000", 0.8);
    
    CGFloat y = SCREENHEIGHT/2.0-App_SafeBottom_H-80-60;
    [hud setOffset:CGPointMake(0, y)];
    [hud setMargin:15];
    
    [[UIApplication sharedApplication].delegate.window addSubview:hud];
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:hud];
    
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:2];
}

+ (void)showLoading {
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
}

+ (void)hiddenLoading {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
}

@end
