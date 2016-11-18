//
//  VideoController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/12.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "VideoController.h"

#import "VideoViewModel.h"
#import "VideoCell.h"
#import "ZHShortVideoManager.h"

@interface VideoController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    
    VideoViewModel *viewModel;
    NSMutableArray *dataArray;
    UITableView *myTableView;
    UIView *headerView;
    
    BOOL isFavType;
    
    BOOL isRandom;
}

@end

@implementation VideoController

-(void)dealloc
{
    ReleaseClass;
}

-(instancetype)initWithFavType
{
    if (self = [super init]) {
        isFavType = YES;
    }
    return self;
}

-(instancetype)initWithRandom:(BOOL)random
{
    if (self = [super init]) {
        isRandom = random;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
    
    self.view.dk_backgroundColorPicker  = Controller_Bg;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.zh_showCustomNav = NO;
    viewModel = [[VideoViewModel alloc] init];
    viewModel.isRandom = isRandom;
    viewModel.isFavType = isFavType;
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setTitle:@"\U0000e6b4" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = IconFont(20);
    [leftBtn addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.zh_customNav addSubview:leftBtn];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.scrollsToTop = NO;
    myTableView.showsVerticalScrollIndicator = YES;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.emptyDataSetDelegate= self;
    myTableView.emptyDataSetSource = self;
    [self.view addSubview:myTableView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.width/16.0*9)];
    headerView.clipsToBounds = YES;
    headerView.backgroundColor = [UIColor clearColor];
    headerView.hidden = YES;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, ScreenSize.width-10, ScreenSize.width/16.0*9-10)];
    imgView.backgroundColor =[ UIColor whiteColor];
    imgView.image = [CATCommon imageNamed:@"clound.jpg"];
    imgView.clipsToBounds = YES;
    [headerView addSubview:imgView];
    myTableView.tableHeaderView = headerView;
    
    myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mjRefreshData)];
    myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mjLoadMore)];
    [myTableView.header beginRefreshing];
    //没有数据不显示标题
    [((MJRefreshAutoNormalFooter*)myTableView.footer) setTitle:@"" forState:MJRefreshStateNoMoreData];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    myTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)mjRefreshData
{
    [myTableView.footer resetNoMoreData];
    __weak typeof(self) weakSelf = self;
    [viewModel fetchVideoList:^(NetReturnValue *returnValue) {
        [weakSelf deallRefreshWithValue:returnValue];
    }];
}

-(void)dealFavRefreshWithValue:(NSArray *)data
{
    dataArray = [NSMutableArray arrayWithArray:data];
    if (data.count < 25) {
        [myTableView.footer endRefreshingWithNoMoreData];
    }
    [myTableView.header endRefreshing];
    [myTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.11 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ZHScrollToTopNotification object:nil];
    });
    
    if (dataArray.count > 0) {
        headerView.hidden = NO;
    } else {
        //视频手动释放cell
        NSString *CellIdentifier = [self getCellIdentifier];
        VideoCell *cell = [myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        while (cell) {
            NSLog(@"cell.window = %@", cell.window);
            [cell removeFromSuperview];
            cell = nil;
            cell = [myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
    }
}

-(void)deallRefreshWithValue:(NetReturnValue *)returnValue
{
    if (returnValue.finishType == REQUEST_SUCESS) {
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray:returnValue.data];
        [myTableView.header endRefreshing];
    } else if (returnValue.finishType == REQUEST_NO_MORE_DATA) {
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray:returnValue.data];
        
        [myTableView.footer endRefreshingWithNoMoreData];
        [myTableView.header endRefreshing];
    } else {
        [myTableView.header endRefreshing];
    }
    [myTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.11 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ZHScrollToTopNotification object:nil];
    });
    
    if (dataArray.count > 0) {
        headerView.hidden = NO;
    } else {
        //视频手动释放cell
        NSString *CellIdentifier = [self getCellIdentifier];
        VideoCell *cell = [myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        while (cell) {
            NSLog(@"cell.window = %@", cell.window);
            [cell removeFromSuperview];
            cell = nil;
            cell = [myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
    }
}

-(void)mjLoadMore
{
    __weak typeof(self) weakSelf = self;
    [viewModel fetchNextVideoList:^(NetReturnValue *returnValue) {
        [weakSelf deallLoadModeWithValue:returnValue];
    }];
}

-(void)dealFavLoadMoreWithValue:(NSArray *)data
{
    if (data.count < 25) {
        [myTableView.footer endRefreshingWithNoMoreData];
    } else {
        [myTableView.footer endRefreshing];
    }
    
    [myTableView beginUpdates];
    NSMutableArray *indexpaths = [NSMutableArray array];
    for (int i = 0; i < data.count; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:dataArray.count+i inSection:0];
        [indexpaths addObject:path];
    }
    [dataArray addObjectsFromArray:data];
    [myTableView insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationBottom];
    [myTableView endUpdates];
}

-(void)deallLoadModeWithValue:(NetReturnValue *)returnValue
{
    if (returnValue.finishType == REQUEST_SUCESS) {
        [myTableView.footer endRefreshing];
        [myTableView beginUpdates];
        NSMutableArray *indexpaths = [NSMutableArray array];
        for (int i = 0; i < ((NSArray *)returnValue.data).count; i++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:dataArray.count+i inSection:0];
            [indexpaths addObject:path];
        }
        [dataArray addObjectsFromArray:returnValue.data];
        [myTableView insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationBottom];
        [myTableView endUpdates];
    } else if (returnValue.finishType == REQUEST_NO_MORE_DATA) {
        [myTableView.footer endRefreshingWithNoMoreData];
        [myTableView beginUpdates];
        NSMutableArray *indexpaths = [NSMutableArray array];
        for (int i = 0; i < ((NSArray *)returnValue.data).count; i++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:dataArray.count+i inSection:0];
            [indexpaths addObject:path];
        }
        [dataArray addObjectsFromArray:returnValue.data];
        [myTableView insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationBottom];
        [myTableView endUpdates];
    } else {
        [myTableView.footer endRefreshing];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self getCellIdentifier];
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //重要不同的tableView, identifier必须不同, 否则会混乱
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < dataArray.count) {
        VideoModel *model = [dataArray objectAtIndex:indexPath.row];
        [cell fillData:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [VideoCell heightForCell];
}

-(void)showLeftMenu
{
    [TheAppDelegate.deckController openLeftView];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if (myTableView.header.isRefreshing) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

-(NSString *)getCellIdentifier
{
    NSString *cellIdentifier = nil;
    if (isFavType) {
        cellIdentifier = [NSString stringWithFormat:@"VideoCell-Fav-%d-random-%d-VideoController", isFavType, isRandom];
    } else {
        cellIdentifier = [NSString stringWithFormat:@"VideoCell-Fav-%d-random-%d-VideoController", isFavType, isRandom];
    }
    return cellIdentifier;
}

@end
