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
#import "UIView+Layout.h"

static CGFloat itemMargin = 5;

@interface RBPhotoPickerController () <UICollectionViewDataSource,UICollectionViewDelegate> {
    NSMutableArray *_models;
}
@property (nonatomic, strong) TZAlbumModel *model;
@property (nonatomic, strong) TZCollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@end

@implementation RBPhotoPickerController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.collectionView setFrame:self.view.bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.columnNumber == 0) {
        self.columnNumber = 4;
    }
    DN_WEAK_SELF
    [[TZImageManager manager] getCameraRollAlbum:YES
                                   allowPickingImage:YES
                                     needFetchAssets:NO
                                          completion:^(TZAlbumModel *model) {
        DN_STRONG_SELF
        self.model = model;
        [self configCollectionView];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchAssetModels];
}

- (void)configCollectionView {
    if (!_collectionView) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[TZCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(itemMargin, itemMargin, itemMargin, itemMargin);
        [self.view addSubview:_collectionView];
        [_collectionView registerClass:[TZAssetCell class] forCellWithReuseIdentifier:@"TZAssetCell"];
        [_collectionView registerClass:[TZAssetCameraCell class] forCellWithReuseIdentifier:@"TZAssetCameraCell"];
    }
    
    _collectionView.contentSize = CGSizeMake(self.view.tz_width, ((_model.count + self.columnNumber - 1) / self.columnNumber) * self.view.tz_width);
    
    CGFloat itemWH = (self.view.tz_width - (self.columnNumber + 1) * itemMargin) / self.columnNumber;
    _layout.itemSize = CGSizeMake(itemWH, itemWH);
    _layout.minimumInteritemSpacing = itemMargin;
    _layout.minimumLineSpacing = itemMargin;
}

- (void)fetchAssetModels {
    DN_WEAK_SELF
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        DN_STRONG_SELF
        [[TZImageManager manager] getAssetsFromFetchResult:self.model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
            DN_STRONG_SELF
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_models = [NSMutableArray arrayWithArray:models];
                [self.collectionView reloadData];
            });
        }];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
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
