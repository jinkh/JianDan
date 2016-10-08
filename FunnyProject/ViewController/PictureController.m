//
//  PictureController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/11.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "PictureController.h"

#import "PictureViewModel.h"
#import "PictureCell.h"
#import "PictureDetailController.h"

@interface PictureController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    
    PictureViewModel *viewModel;
    NSMutableArray *dataArray;
    UITableView *myTableView;
    NSString *urlString;
    
    BOOL isFetchingData;
    BOOL isRandom;
    
    BOOL isFavType;
}

@end

@implementation PictureController

-(void)dealloc
{
    ReleaseClass;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithUrl:(NSString *)urlStr isRandom:(BOOL)random
{
    if (self = [super init]) {
        urlString = urlStr;
        isRandom = random;
    }
    return self;
}

-(instancetype)initWithFavTypeAndUrl:(NSString *)urlStr
{
    if (self = [super init]) {
        isFavType = YES;
        urlString = urlStr;
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    myTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
    isFetchingData = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO; 
    self.view.dk_backgroundColorPicker  = Controller_Bg;
    self.zh_showCustomNav = NO;
    
    viewModel = [[PictureViewModel alloc] initWithUrl:urlString];
    viewModel.isRandom = isRandom;
    
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
    
    myTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mjRefreshData)];
    myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mjLoadMore)];
    [myTableView.header beginRefreshing];
    //没有数据不显示标题
    [((MJRefreshAutoNormalFooter*)myTableView.footer) setTitle:@"" forState:MJRefreshStateNoMoreData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchMoreForPictureDetailController:) name:Fetch_More_Pictures_notify object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restTablePositionForPictureDetailController:) name:Rest_Table_Position_Pictures_Notify object:nil];
    
}

-(void)restTablePositionForPictureDetailController:(NSNotification *)notify
{
    if ([dataArray containsObject:notify.object]) {
        NSInteger index = [dataArray indexOfObject:notify.object];
        for (NSIndexPath *path in myTableView.indexPathsForVisibleRows) {
            if (path.row == index) {
                return;
            }
        }
        [myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

-(void)fetchMoreForPictureDetailController:(NSNotification *)notify
{
    if (notify.object == dataArray.lastObject) {
        //滚动到底部自动加载
        if (isFetchingData) {
            return;
        }
        if (myTableView.footer.state == MJRefreshStateNoMoreData) {
            return;
        }
        [self mjLoadMore];

    }
}

-(void)mjRefreshData
{
    if (isFetchingData) {
        [myTableView.header endRefreshing];
        return;
    }
    
    isFetchingData = YES;
    [myTableView.footer resetNoMoreData];
    __weak typeof(self) weakSelf = self;

    if (isFavType) {
        [weakSelf dealFavRefreshWithValue:[PictureViewModel fetchFavListWithPage:1 withSize:25 withType:urlString]];
    } else {
        [viewModel fetchPictureList:^(NetReturnValue *returnValue) {
            [weakSelf deallRefreshWithValue:returnValue];
        }];
    }
}

-(void)dealFavRefreshWithValue:(NSArray *)data
{
    isFetchingData = NO;
    dataArray = [NSMutableArray arrayWithArray:data];
    if (data.count < 25) {
        [myTableView.footer endRefreshingWithNoMoreData];
    }
    [myTableView.header endRefreshing];
    [myTableView reloadData];
}

-(void)deallRefreshWithValue:(NetReturnValue *)returnValue
{
    isFetchingData = NO;
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
}




-(void)mjLoadMore
{
    if (isFetchingData) {
        [myTableView.footer endRefreshing];
        return;
    }
    
     NSLog(@"--------开始加载更多");
    isFetchingData = YES;
    __weak typeof(self) weakSelf = self;
    
    if (isFavType) {
        [weakSelf dealFavLoadMoreWithValue: [PictureViewModel fetchFavListWithPage:1+dataArray.count/25 withSize:25 withType:urlString]];
    } else {
        [viewModel fetchNextPictureList:^(NetReturnValue *returnValue) {
            [weakSelf deallLoadModeWithValue:returnValue];
        }];
    }
}

-(void)dealFavLoadMoreWithValue:(NSArray *)data
{
    isFetchingData = NO;
    [dataArray addObjectsFromArray:data];
    if (data.count < 25) {
        [myTableView.footer endRefreshingWithNoMoreData];
    } else {
        [myTableView.footer endRefreshing];
    }
    [myTableView reloadData];
}

-(void)deallLoadModeWithValue:(NetReturnValue *)returnValue
{
    isFetchingData = NO;
    NSLog(@"--------结束加载更多");
    if (returnValue.finishType == REQUEST_SUCESS) {
        [dataArray addObjectsFromArray:returnValue.data];
        [myTableView.footer endRefreshing];
    } else if (returnValue.finishType == REQUEST_NO_MORE_DATA) {
        [dataArray addObjectsFromArray:returnValue.data];
        [myTableView.footer endRefreshingWithNoMoreData];
    } else {
        [myTableView.footer endRefreshing];
    }
    [myTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PictureCell";
    PictureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row < dataArray.count) {
        PictureModel *model = [dataArray objectAtIndex:indexPath.row];
        model.comment_type = urlString;
        [cell fillData:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [viewModel pictureDetailWithData:dataArray withIndex:indexPath.row withType:urlString];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PictureCell heightForCellWithData:[dataArray objectAtIndex:indexPath.row]];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
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

@end

