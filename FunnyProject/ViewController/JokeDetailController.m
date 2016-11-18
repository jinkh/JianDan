//
//  JokeDetailController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/18.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "JokeDetailController.h"

#import "JokeDetailView.h"
#import "CommentBarView.h"
#import "ZHPagerLongView.h"
#import "ShareView.H"


@interface JokeDetailController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate, CommentBarViewDelegate, ZHPagerLongViewDelegate>
{
    
    NSArray *myData;
    
    NSInteger orginSselectIndex;
    
    ZHPagerLongView *pagerView;
    
    CommentBarView *toolBarView;
    
}

@end

@implementation JokeDetailController

-(void)dealloc
{
    ReleaseClass;
}

-(instancetype)initWithData:(id)data withIndex:(NSInteger)index
{
    if (self = [super init]) {
        myData = data;
        orginSselectIndex = index;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (pagerView.pageEnabled == YES) {
        self.navigationController.zh_fullscreenPopWidth = 60;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:Rest_Table_Position_Joke_Notify object:[myData objectAtIndex:pagerView.selectDataIndex]];
    self.navigationController.zh_fullscreenPopWidth = ScreenSize.width;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.dk_backgroundColorPicker  = Controller_Bg;
    self.zh_showCustomNav = YES;
    self.zh_title = @"段子详情";
    
    pagerView = [[ZHPagerLongView alloc] initWithFrame:CGRectMake(0, 64, ScreenSize.width, ScreenSize.height-64-45)
                                   withSelectDataIndex:orginSselectIndex];
    pagerView.delegate = self;
    [self.view addSubview:pagerView];
    [pagerView reloadData];
    
    toolBarView = [[CommentBarView alloc] initWithFrame:CGRectMake(0, ScreenSize.height-45, ScreenSize.width, 45)];
    toolBarView.delegate = self;
    [self.view addSubview:toolBarView];
    
    [self.view addSubview:toolBarView];
    JokeModel *model = [myData objectAtIndex:orginSselectIndex];
    [toolBarView resetFavSate:[JokeViewModel isFavWithModel:model]];
    if (_isFavType) {
        pagerView.pageEnabled = NO;
    }
}

//ZHPagerLongViewDelegate
-(UIView *)viewForPageIndex:(NSInteger)index
{
    if (index < myData.count) {
        JokeDetailView *view = [[JokeDetailView alloc] initWithFrame:pagerView.bounds
                                                                  withData:[myData objectAtIndex:index]];
        return view;
    }
    return nil;
}

-(NSInteger)dataCountForPage
{
    return myData.count;
}

-(void)checkNeedFetchMore
{
    //如果剩余数据小于等于8个，请求更多数据
    if (pagerView.selectDataIndex+8 > myData.count) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Fetch_More_Joke_notify object:myData.lastObject];
    }
}

-(void)didSelectPageIndex:(NSInteger)index
{
    JokeModel *model = [myData objectAtIndex:pagerView.selectDataIndex];
    [toolBarView resetFavSate:[JokeViewModel isFavWithModel:model]];
}


//CommentBarViewDelegate
-(void)shareAction
{
    ShareView *share = [[ShareView alloc] initWithData:[myData objectAtIndex:pagerView.selectDataIndex]];
    [share showAnimate:YES];
}

-(void)favAction
{
    JokeModel *model = [myData objectAtIndex:pagerView.selectDataIndex];
    if ([JokeViewModel isFavWithModel:model]) {
        [JokeViewModel deleteFavWithModel:model];
        [[ToastHelper sharedToastHelper] toast:@"取消收藏"];
        [toolBarView resetFavSate:NO];
    } else {
        [JokeViewModel saveFavWithModel:model withBlock:^(BOOL result) {
            if (result) {
                [[ToastHelper sharedToastHelper] toast:@"收藏成功"];
                [toolBarView resetFavSate:YES];
            } else {
                [[ToastHelper sharedToastHelper] toast:@"收藏失败"];
            }
        }];
    }
}

-(void)commentActionWithText:(NSString *)content withParent:(id)parent
{
    NSLog(@"content = %@", content);
    JokeDetailView *view = (JokeDetailView *)pagerView.selectView;
    [view pushCommentWithText:content withParentId:parent];
}





@end

