//
//  RBVideoThumbnailModel.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/21.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "RBVideoThumbnailModel.h"

@implementation RBVideoThumbnailModel
#pragma mark - CHGCollectionViewCellModelProtocol
- (NSString*)cellClassNameInCollectionView:(UICollectionView*)collectionView atIndexPath:(NSIndexPath*)indexPath {
    return @"FSThumbnailCollectionCell";
}

- (CGSize)chg_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"self.size : %@",NSStringFromCGSize(self.size));
    return self.size;
}
@end
