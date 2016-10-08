//
//  LeftController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/8.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "LeftController.h"
#import "LeftCell.h"

#import "ArticlePagerController.h"
#import "PicturePagerController.h"
#import "JokePagerController.h"
#import "VideoPagerController.h"
#import "FavController.h"
#import "CenterController.h"
#import "SettingController.h"
#import "LeftMenuSortController.h"

@interface LeftController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *myTableView;
    UIView *headerView;
    NSInteger selectIndex;
    
    NSMutableArray *dataArray;
    NSMutableArray *contentArray;
    
    NSArray *orginDataArray;
    NSArray *orginContentarray;
}
@end

@implementation LeftController

-(void)dealloc
{
    ReleaseClass;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(instancetype)init
{
    if (self = [super init]) {
        selectIndex = 0;
        ArticlePagerController *articleController = [[ArticlePagerController alloc] init];
        PicturePagerController *boredController = [[PicturePagerController alloc] initWithUrl:BoredPicturesUrl];
        PicturePagerController *sisterController = [[PicturePagerController alloc] initWithUrl:SisterPicturesUrl];
        JokePagerController *jokeController = [[JokePagerController alloc] init];
        VideoPagerController *videoController = [[VideoPagerController alloc] init];
        FavController *favController = [[FavController alloc] init];
        CenterController *centerController = [[CenterController alloc] init];
        SettingController *setController = [[SettingController alloc] init];
        
        //对内容排序
        contentArray = [[NSMutableArray alloc] init];
        dataArray = [[NSMutableArray alloc] init];
        
        NSArray *orderArray = [SettingManager getLeftMenuOrder];
        orginContentarray = @[articleController, boredController, sisterController, jokeController, videoController];

        orginDataArray = [SettingManager getOrginLeftContentMenuTitles];
        for (int i = 0; i < orderArray.count; i++) {
            NSInteger num = [[orderArray objectAtIndex:i] integerValue];
            [contentArray addObject:[orginContentarray objectAtIndex:num]];
            [dataArray addObject:[orginDataArray objectAtIndex:num]];
        }
        [dataArray addObjectsFromArray:@[@"收藏", @"", @"个人中心", @"设置"]];
        [contentArray addObjectsFromArray:@[favController, @"", centerController, setController]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restOrder:) name:Left_Menu_Order_Reset_Notify object:nil];

    }
    return self;
}

-(void)restOrder:(NSNotification *)notify
{
    
    NSArray *orderArray = [SettingManager getLeftMenuOrder];
    for (int i = 0; i < contentArray.count; i++) {
        if (i < orderArray.count) {
            NSInteger num = [[orderArray objectAtIndex:i] integerValue];
            [contentArray removeObjectAtIndex:i];
            [contentArray insertObject:[orginContentarray objectAtIndex:num] atIndex:i];
            [dataArray removeObjectAtIndex:i];
            [dataArray insertObject:[orginDataArray objectAtIndex:num] atIndex:i];
        }
    }
    [myTableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker =DKColorPickerWithColors(COLOR(42, 40, 39), COLOR(22, 22, 28));
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.bounces = NO;
    myTableView.dataSource = self;
    myTableView.scrollsToTop = NO;
    myTableView.showsVerticalScrollIndicator = YES;
    myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];
    
    CGFloat headerHeight = (myTableView.frame.size.height-dataArray.count*[LeftCell heightForCell])*.5-20;
    if (headerHeight < 0) {
        headerHeight = 0;
    }
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headerHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView *hLine = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.bounds.size.height-3, self.view.frame.size.width, 3)];
    hLine.backgroundColor = COLOR(30, 29, 29);
    [headerView addSubview:hLine];
    
    myTableView.tableHeaderView = headerView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [TheAppDelegate.deckController.centerController.navigationController.visibleViewController.view endEditing:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeftCell";
    LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[LeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell fillData:[dataArray objectAtIndex:indexPath.row] selected:selectIndex == indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6) {
        return;
    }
    selectIndex = indexPath.row;
    [tableView reloadData];
    if (selectIndex < contentArray.count) {
        UINavigationController *selController = [[UINavigationController alloc] initWithRootViewController:self.selectController];
        TheAppDelegate.deckController.centerController = selController;
    }
    [TheAppDelegate.deckController closeLeftView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LeftCell heightForCell];
}


-(UIViewController *)selectController
{
    return [contentArray objectAtIndex:selectIndex];
}

@end
