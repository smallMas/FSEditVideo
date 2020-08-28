//
//  RBVideoThumbnailModel.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/21.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "RBVideoThumbnailModel.h"
#import "FSThumbnailManager.h"

@implementation RBVideoThumbnailModel
@synthesize thumbnailImage = _thumbnailImage;

- (void)getThumbnailImageWithTimeLine:(FSTimeLine *)timeline block:(void (^)(UIImage *image))block {
    if (_thumbnailImage) {
        if (block) {
            block(_thumbnailImage);
        }
    }else {
        if (timeline) {
            DN_WEAK_SELF
            [[FSThumbnailManager shareInstance] requestThumbnailWithTime:self.time timeline:timeline block:^(UIImage * _Nonnull thumbnailImage) {
                DN_STRONG_SELF
                [self setThumbnailImg:thumbnailImage];
                if (block) {
                    block(thumbnailImage);
                }
            }];
        }else {
            if (block) {
                block(nil);
            }
        }
    }
}

- (void)setThumbnailImg:(UIImage *)image {
    _thumbnailImage = image;
}


#pragma mark - CHGCollectionViewCellModelProtocol
- (NSString*)cellClassNameInCollectionView:(UICollectionView*)collectionView atIndexPath:(NSIndexPath*)indexPath {
    return @"FSThumbnailCollectionCell";
}

- (CGSize)chg_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"self.size : %@",NSStringFromCGSize(self.size));
    return self.size;
}
@end
