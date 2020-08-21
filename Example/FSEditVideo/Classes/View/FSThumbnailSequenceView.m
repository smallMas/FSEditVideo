//
//  FSThumbnailSequenceView.m
//  FSGPUImage
//
//  Created by 燕来秋 on 2020/7/16.
//  Copyright © 2020 燕来秋. All rights reserved.
//

#import "FSThumbnailSequenceView.h"
#import "RBVideoThumbnailModel.h"

@interface FSThumbnailSequenceView ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) RBVideoThumbnailModel *leftModel;
@property (nonatomic, strong) RBVideoThumbnailModel *rightModel;

@property (nonatomic, assign) int64_t duration;
@property (nonatomic, assign) CGFloat thumbnailWidth; // 默认50

@end

@implementation FSThumbnailSequenceView

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setup];
        [self layoutUI];
    }
    return self;
}

- (void)initData {
    self.thumbnailWidth = 50.0f;
}

- (void)setup {
    [self addSubview:self.collectionView];
}

- (void)layoutUI {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)reloadData {
    self.leftModel.size = CGSizeMake(self.startPadding, self.frame.size.height);
    self.rightModel.size = CGSizeMake(self.endPadding, self.frame.size.height);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:self.leftModel];
    [array addObjectsFromArray:self.dataArray];
    [array addObject:self.rightModel];
    self.collectionView.cellDatas = @[array];
    [self.collectionView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (FSVideoThumbnailModel *model in self.dataArray) {
        CGSize size = model.size;
        size.height = self.frame.size.height;
        model.size = size;
    }
    [self reloadData];
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];

        [_collectionView setBackgroundColor:[UIColor clearColor]];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        // cell的行边距[ = ](上下边距)
        _layout.minimumLineSpacing = 0.0f;
        // cell的纵边距[ || ](左右边距)
        _layout.minimumInteritemSpacing = 0.0f;
        [_layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    }
    return _layout;
}

- (RBVideoThumbnailModel *)createThumbnailModelWidth:(CGFloat)width {
    RBVideoThumbnailModel *model = [RBVideoThumbnailModel new];
    model.size = CGSizeMake(width, self.collectionView.bounds.size.height);
    return model;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (RBVideoThumbnailModel *)leftModel {
    if (!_leftModel) {
        _leftModel = [self createThumbnailModelWidth:self.startPadding];
    }
    return _leftModel;
}

- (RBVideoThumbnailModel *)rightModel {
    if (!_rightModel) {
        _rightModel = [self createThumbnailModelWidth:self.endPadding];
    }
    return _rightModel;
}

#pragma mark - 外部调用
- (void)setShowsScrollIndicator:(BOOL)is {
    self.collectionView.showsVerticalScrollIndicator = is;
    self.collectionView.showsHorizontalScrollIndicator = is;
}

- (void)configTimeline:(FSTimeLine *)timeline maxDuration:(int64_t)max block:(FSComplete)block {
    if (timeline) {
        self.collectionView.customData = timeline;
        _duration = timeline.duration;
        DN_WEAK_SELF
        [timeline getThumbnailArrayMaxDuration:max width:(SCREENWIDTH-self.startPadding-self.endPadding) block:^(NSArray *array) {
            DN_STRONG_SELF
            [self.dataArray removeAllObjects];
            NSMutableArray *rbArray = [NSMutableArray array];
            for (FSVideoThumbnailModel *model in array) {
                RBVideoThumbnailModel *rbModel = [self modelChangeFromModel:model];
                CGSize size = rbModel.size;
                size.height = self.frame.size.height;
                rbModel.size = size;
                [rbArray addObject:rbModel];
            }
            [self.dataArray addObjectsFromArray:rbArray];
            [self reloadData];
            
            if (block) {
                block();
            }
        }];
    }
}

- (void)configDivideTimeline:(FSTimeLine *)timeline block:(FSComplete)block {
    if (timeline) {
        self.collectionView.customData = timeline;
        _duration = timeline.duration;
        DN_WEAK_SELF
        [timeline getThumbnailArrayBlock:^(NSArray *array) {
            DN_STRONG_SELF
            [self.dataArray removeAllObjects];
            NSMutableArray *rbArray = [NSMutableArray array];
            for (FSVideoThumbnailModel *model in array) {
                RBVideoThumbnailModel *rbModel = [self modelChangeFromModel:model];
                CGSize size = rbModel.size;
                size.height = self.frame.size.height;
                rbModel.size = size;
                [rbArray addObject:rbModel];
            }
            [self.dataArray addObjectsFromArray:rbArray];
            [self reloadData];
            
            if (block) {
                block();
            }
        }];
    }
}

- (RBVideoThumbnailModel *)modelChangeFromModel:(FSVideoThumbnailModel *)model {
    RBVideoThumbnailModel *rbModel = [RBVideoThumbnailModel new];
    rbModel.size = model.size;
    rbModel.time = model.time;
    rbModel.isThumbnail = model.isThumbnail;
    return rbModel;
}

- (int64_t)mapTimelinePosFromX:(CGFloat)x {
    CGFloat w = self.collectionView.contentSize.width-self.startPadding-self.endPadding;
    CGFloat contentX = self.collectionView.contentOffset.x+x-self.startPadding;
    CGFloat ratio = contentX/w;
    int64_t time = ratio*self.duration;
    if (time > self.duration ) {
        time = self.duration;
    }
    if (time < 0) {
        time = 0;
    }
    return time;
}

- (void)addScrollViewDelegate:(id)delegate {
    [self.collectionView addCHGScrollViewDelegate:(id <CHGScrollViewDelegate>)delegate];
}

- (void)removeScrollViewDelegate:(id)delegate {
    [self.collectionView removeCHGScrollViewDelegate:(id <CHGScrollViewDelegate>)delegate];
}

@end
