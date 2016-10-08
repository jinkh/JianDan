//
//  FavMenuSortController.m
//  FunnyProject
//
//  Created by Zinkham on 16/8/1.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "FavMenuSortController.h"

@interface FavMenuSortController ()<UITableViewDataSource, UITableViewDelegate>

{
    UITableView *myTableView;
    NSMutableArray *dataArray;
    NSMutableArray *orderArray;
}

@end

@implementation FavMenuSortController


-(void)dealloc
{
    ReleaseClass;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = Controller_Bg;
    self.zh_showCustomNav = YES;
    self.zh_title = @"收藏菜单排序";
    
    dataArray = [[NSMutableArray alloc] init];
    NSArray *titleArray = [SettingManager getOrginFavContentMenuTitles];
    orderArray =  [[NSMutableArray alloc] initWithArray:[SettingManager getFavMenuOrder]];
    for (NSString *item in orderArray) {
        NSInteger num = [item integerValue];
        [dataArray addObject:[titleArray objectAtIndex:num]];
    }
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenSize.width, ScreenSize.height-64)];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.dk_separatorColorPicker = Sep_Bg_System;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.scrollsToTop = NO;
    myTableView.showsVerticalScrollIndicator = YES;
    myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];
    
    if ([myTableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        myTableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
    myTableView.tableFooterView = [UIView new];
    [myTableView setEditing:YES animated:YES];
    [myTableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SettingManager saveFavMenuOrder:orderArray];
    [[NSNotificationCenter defaultCenter] postNotificationName:Fav_Menu_Order_Reset_Notify object:nil];
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
    static NSString *CellIdentifier = @"LefMenuSortCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.dk_backgroundColorPicker = Cell_Bg;
        cell.textLabel.dk_textColorPicker  =Text_Title;
        cell.textLabel.font = DefaultFont(17);
        cell.textLabel.textAlignment  =NSTextAlignmentLeft;
    }
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSInteger fromRow = sourceIndexPath.row;
    NSInteger toRow = destinationIndexPath.row;
    
    id object = [dataArray objectAtIndex:fromRow];
    [dataArray removeObjectAtIndex:fromRow];
    [dataArray insertObject:object atIndex:toRow];
    
    id orderObject = [orderArray objectAtIndex:fromRow];
    [orderArray removeObjectAtIndex:fromRow];
    [orderArray insertObject:orderObject atIndex:toRow];
}

@end
