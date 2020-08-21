//
//  FSThumbnailCollectionCell.m
//  FSGPUImage
//
//  Created by 燕来秋 on 2020/7/16.
//  Copyright © 2020 燕来秋. All rights reserved.
//

#import "FSThumbnailCollectionCell.h"
#import "FSVideoThumbnailModel.h"
#import "FSTimeLine.h"

@interface FSThumbnailCollectionCell()

@property (nonatomic, strong) UIImageView *thumbnailView;

@end

@implementation FSThumbnailCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self layoutUI];
    }
    return self;
}

- (void)setup {
    [self.contentView addSubview:self.thumbnailView];
}

- (void)layoutUI {
    [self.thumbnailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - 懒加载
- (UIImageView *)thumbnailView {
    if (!_thumbnailView) {
        _thumbnailView = [[UIImageView alloc] init];
    }
    return _thumbnailView;
}

#pragma mark - 外部调用
- (void)configData:(id)data {
    if ([data isKindOfClass:[FSVideoThumbnailModel class]]) {
        FSVideoThumbnailModel *model = data;
        FSTimeLine *timeline = self.customData;
        if (model.isThumbnail) {
            FSJ_WEAK_SELF
            [model getThumbnailImageWithTimeLine:timeline block:^(UIImage * _Nonnull image) {
                FSJ_STRONG_SELF
                [self.thumbnailView setImage:image];
            }];
        }else {
            [self.thumbnailView setImage:nil];
        }
    }
}

#pragma mark - 重写
- (void)cellForRowAtIndexPath:(NSIndexPath *)indexPath targetView:(UIView*)targetView model:(id)model eventTransmissionBlock:(CHGEventTransmissionBlock)eventTransmissionBlock {
    [super cellForRowAtIndexPath:indexPath targetView:targetView model:model eventTransmissionBlock:eventTransmissionBlock];
    [self configData:model];
}

@end
