//
//  RBPhotoPickerController.h
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/26.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "TZPhotoPickerController.h"
#import "TZAssetModel.h"
#import "TZImageManager.h"

NS_ASSUME_NONNULL_BEGIN

@class RBPhotoPickerController;
@protocol RBPhotoPickerControllerDelegate <NSObject>

- (void)photoPickerController:(RBPhotoPickerController *)picker didFinishPickingAssets:(NSArray <PHAsset *>*)assets;

@end

@interface RBPhotoPickerController : UIViewController
@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, weak) id <RBPhotoPickerControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
