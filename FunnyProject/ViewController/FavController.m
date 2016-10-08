//
//  FavController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/13.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "FavController.h"

#import "ZHPagerHeaderView.h"
#import "ArticleController.h"
#import "PictureController.h"
#import "JokeController.h"
#import "VideoController.h"
#import "FavMenuSortController.h"

@interface FavController ()

{
    
    NSMutableArray *dataArray;
    NSMutableArray *contentArray;
    
    NSArray *orginDataArray;
    NSArray *orginContentarray;
}

@end

@implementation FavController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init
{
    if (self = [super init]) {

        contentArray = [[NSMutableArray alloc] init];
        dataArray = [[NSMutableArray alloc] init];
        
        

            ArticleController *pager0 = [[ArticleController alloc] initWithFavType];
            pager0.view.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height-64);
            pager0.view.tag = 0;


            PictureController *pager1 = [[PictureController alloc] initWithFavTypeAndUrl:BoredPicturesUrl];
            pager1.view.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height-64);
            pager1.view.tag = 1;


            PictureController *pager2 = [[PictureController alloc] initWithFavTypeAndUrl:SisterPicturesUrl];
            pager2.view.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height-64);
            pager2.view.tag = 2;


            JokeController *pager3 = [[JokeController alloc] initWithFavType];
            pager3.view.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height-64);
            pager3.view.tag = 3;


            VideoController *pager4 = [[VideoController alloc] initWithFavType];
            pager4.view.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height-64);
            pager4.view.tag = 4;
  

        
        
        NSArray *orderArray = [SettingManager getFavMenuOrder];
        orginContentarray = @[pager0, pager1, pager2, pager3, pager4];
        
        orginDataArray = [SettingManager getOrginFavContentMenuTitles];
        for (int i = 0; i < orderArray.count; i++) {
            NSInteger num = [[orderArray objectAtIndex:i] integerValue];
            [contentArray addObject:[orginContentarray objectAtIndex:num]];
            [dataArray addObject:[orginDataArray objectAtIndex:num]];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restOrder:) name:Fav_Menu_Order_Reset_Notify object:nil];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(UIView *)contentViewForPagerAtIndex:(NSInteger)index
{
    if (index < contentArray.count) {
        UIViewController *controller = [contentArray objectAtIndex:index];
        controller.view.tag = index;
        return controller.view;
    }
    return nil;
}


-(NSArray *)headerDataForPager
{
    
    return dataArray;
}

-(void)restOrder:(NSNotification *)notify
{
    
    NSArray *orderArray = [SettingManager getFavMenuOrder];
    [contentArray removeAllObjects];
    [dataArray removeAllObjects];
    
    for (int i = 0; i < orderArray.count; i++) {
        NSInteger num = [[orderArray objectAtIndex:i] integerValue];
        [contentArray addObject:[orginContentarray objectAtIndex:num]];
        [dataArray addObject:[orginDataArray objectAtIndex:num]];
    }
    [self reloadData];
}

@end
