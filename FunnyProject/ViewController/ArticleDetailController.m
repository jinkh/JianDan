//
//  ArticleDetailController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/13.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ArticleDetailController.h"
#import "ArticleDetailView.h"

#import "CommentBarView.h"
#import "ZHPagerLongView.h"
#import "ShareView.h"

@interface ArticleDetailController()<UIScrollViewDelegate, CommentBarViewDelegate, ZHPagerLongViewDelegate>

{
    NSArray *myData;
    
    NSInteger origSelectIndex;
    
    ZHPagerLongView *pagerView;
    
    CommentBarView *toolBarView;
    
}

@end

@implementation ArticleDetailController

-(void)dealloc
{
    ReleaseClass;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(instancetype)initWithData:(id)data withIndex:(NSInteger)index
{
    if (self = [super init]) {
        myData = data;
        origSelectIndex = index;
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
    if (pagerView.selectDataIndex < myData.count) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Rest_Table_Position_Article_Notify object:[myData objectAtIndex:pagerView.selectDataIndex]];
    }
    self.navigationController.zh_fullscreenPopWidth = ScreenSize.width;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = Controller_Bg;
    self.zh_showCustomNav = YES;
    self.zh_title = @"新鲜事详情";
    
    pagerView = [[ZHPagerLongView alloc] initWithFrame:CGRectMake(0, 64, ScreenSize.width, ScreenSize.height-64-45)
                                   withSelectDataIndex:origSelectIndex];
    pagerView.delegate = self;
    [self.view addSubview:pagerView];
    [pagerView reloadData];
    
    toolBarView = [[CommentBarView alloc] initWithFrame:CGRectMake(0, ScreenSize.height-45, ScreenSize.width, 45)];
    toolBarView.delegate = self;
    [self.view addSubview:toolBarView];
    ArticleModel *model = [myData objectAtIndex:origSelectIndex];
    [toolBarView resetFavSate:[ArticleViewModel isFavWithModel:model]];
}

//ZHPagerLongViewDelegate
-(UIView *)viewForPageIndex:(NSInteger)index
{
    if (index < myData.count) {
        ArticleDetailView *view = [[ArticleDetailView alloc] initWithFrame:pagerView.bounds
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
        [[NSNotificationCenter defaultCenter] postNotificationName:Fetch_More_Article_Notify object:myData.lastObject];
    }
}

-(void)didSelectPageIndex:(NSInteger)index
{
     ArticleModel *model = [myData objectAtIndex:pagerView.selectDataIndex];
    model.isRead = [NSNumber numberWithInteger:1];
    [toolBarView resetFavSate:[ArticleViewModel isFavWithModel:model]];
    [ArticleViewModel saveReadWithModel:model withBlock:nil];
}

//CommentBarViewDelegate
-(void)shareAction
{
    ShareView *share = [[ShareView alloc] initWithData:[myData objectAtIndex:pagerView.selectDataIndex]];
    [share showAnimate:YES];
}

-(void)favAction
{
    ArticleModel *model = [myData objectAtIndex:pagerView.selectDataIndex];
    if ([ArticleViewModel isFavWithModel:model]) {
        [ArticleViewModel deleteFavWithModel:model];
        [[ToastHelper sharedToastHelper] toast:@"取消收藏"];
           [toolBarView resetFavSate:NO];
    } else {
        BOOL result = [ArticleViewModel saveFavWithModel:model];
        if (result) {
            [[ToastHelper sharedToastHelper] toast:@"收藏成功"];
            [toolBarView resetFavSate:YES];
        } else {
            [[ToastHelper sharedToastHelper] toast:@"收藏失败"];
        }
    }
    if (_isFavType) {
        [TheAppDelegate.rootNavigationController popViewControllerAnimated:YES];
    }
}

-(void)commentActionWithText:(NSString *)content withParent:(id)parent
{
    NSLog(@"content = %@", content);
    
    ArticleDetailView *view = (ArticleDetailView *)pagerView.selectView;
    [view pushCommentWithText:content withParentComment:parent];
}



@end
