//
//  RBPhotoPickerController.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/26.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "RBPhotoPickerController.h"
#import <objc/message.h>
#import "TZImageManager.h"
#import "TZAssetCell.h"

@interface RBPhotoPickerController ()

@end

@implementation RBPhotoPickerController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)fetchAssetModels {
    DN_WEAK_SELF
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        DN_STRONG_SELF
        [[TZImageManager manager] getAssetsFromFetchResult:self.model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
            DN_STRONG_SELF
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setValue:[NSMutableArray arrayWithArray:models] forKey:@"_models"];
                ((void (*)(id, SEL))objc_msgSend)(self, @selector(initSubviews));
            });
        }];
    });
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZAssetCell" forIndexPath:indexPath];
    cell.allowPickingMultipleVideo = NO;
    
    NSArray *_models = [self valueForKey:@"_models"];
    TZAssetModel *model = _models[indexPath.item];
    cell.allowPickingGif = NO;
    cell.model = model;
    
    DN_WEAK_SELF
    cell.didSelectPhotoBlock = ^(BOOL isSelected) {
        DN_STRONG_SELF
        [self selectedCallBack:model];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.item;
    NSArray *models = [self valueForKey:@"_models"];
    TZAssetModel *model = models[index];
    [self selectedCallBack:model];
}

- (void)selectedCallBack:(TZAssetModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoPickerController:didFinishPickingAssets:)]) {
        [self.delegate photoPickerController:self didFinishPickingAssets:model.asset?@[model.asset]:nil];
    }
}

@end
