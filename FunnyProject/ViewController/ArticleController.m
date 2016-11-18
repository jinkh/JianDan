//
//  ArticleController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/8.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ArticleController.h"
#import "ArticleCell.h"
#import "ArticleDetailController.h"

@interface ArticleController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{

    ArticleViewModel *viewModel;
    NSMutableArray *dataArray;
    UITableView *myTableView;
    BOOL isFetchingData;
    
    BOOL isRandom;
    
    BOOL isFavType;
}

@end

@implementation ArticleController

-(instancetype)initWithRandom:(BOOL)random
{
    if (self = [super init]) {
        isRandom = random;
    }
    return self;
}

-(instancetype)initWithFavType
{
    if (self = [super init]) {
        isFavType = YES;
    }
    return self;
}

-(void)dealloc
{
    ReleaseClass;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    myTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [myTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.zh_showCustomNav = NO;
    self.automaticallyAdjustsScrollViewInsets = NO; 
    
    isFetchingData = NO;
    viewModel = [[ArticleViewModel alloc] init];
    viewModel.isRandom = isRandom;
    viewModel.isFavType = isFavType;
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchMoreForArticleDetailController:) name:Fetch_More_Article_Notify object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restTablePositionForArticleDetailController:) name:Rest_Table_Position_Article_Notify object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favDataChanged:) name:Article_Fav_Data_Change_Notify object:nil];
    
}

-(void)favDataChanged:(NSNotification *)notify
{
    if (isFavType) {
        id object = notify.object;
        if ([dataArray containsObject:object]) {
            [dataArray removeObject:object];
        } else {
            [dataArray insertObject:object atIndex:0];
        }
        viewModel.favOffset = dataArray.count;
        [myTableView reloadData];
    }
}

-(void)restTablePositionForArticleDetailController:(NSNotification *)notify
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

-(void)fetchMoreForArticleDetailController:(NSNotification *)notify
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
        return;
    }
    isFetchingData = YES;
    [myTableView.footer resetNoMoreData];
    __weak typeof(self) weakSelf = self;
    [viewModel fetchNewArticleList:^(NetReturnValue *returnValue) {
        [weakSelf deallRefreshWithValue:returnValue];
    }];
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
        [myTableView reloadData];
        [myTableView.header endRefreshing];
    } else if (returnValue.finishType == REQUEST_NO_MORE_DATA) {
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray:returnValue.data];
        [myTableView reloadData];
        [myTableView.footer endRefreshingWithNoMoreData];
        [myTableView.header endRefreshing];
    } else {
        [myTableView.header endRefreshing];
    }
    [myTableView reloadEmptyDataSet];
}




-(void)mjLoadMore
{
    if (isFetchingData) {
        return;
    }
    isFetchingData = YES;
    __weak typeof(self) weakSelf = self;
    [viewModel fetchNextNewArticleList:^(NetReturnValue *returnValue) {
        [weakSelf deallLoadModeWithValue:returnValue];
    }];
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
    static NSString *CellIdentifier = @"ArticleCell";
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row < dataArray.count) {
          [cell fillData:[dataArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [viewModel articleDetailWithData:dataArray withIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ArticleCell heightForCell];
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
