//
//  RBAlbumController.m
//  FSEditVideo_Example
//
//  Created by 燕来秋 on 2020/8/21.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//

#import "RBAlbumController.h"

@interface RBAlbumController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation RBAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if ( !_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableViewEmptyDataShow.titleColor = COLHEX(@"#969696");
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    [cell.textLabel setText:[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row]];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.eventTransmissionBlock) {
        self.eventTransmissionBlock(self, nil, RBAlbumActionTypeScrollUp, nil);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
