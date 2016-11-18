//
//  PictureDetailController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/13.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "PictureDetailController.h"
#import "PictureDetailView.h"
#import "CommentBarView.h"
#import "ZHPagerLongView.h"
#import "ShareView.H"


@interface PictureDetailController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate, CommentBarViewDelegate,ZHPagerLongViewDelegate>
{
    
    NSArray *myData;
    
    NSInteger orginSelectIndex;
    
    ZHPagerLongView *pagerView;
    
    CommentBarView *toolBarView;
    
    NSString *typeUrlStr;
    
}

@end

@implementation PictureDetailController

-(void)dealloc
{
    ReleaseClass;
}

-(instancetype)initWithData:(id)data withIndex:(NSInteger)index withType:(NSString *)typeUrl
{
    if (self = [super init]) {
        myData = data;
        orginSelectIndex = index;
        typeUrlStr = typeUrl;
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
        [[NSNotificationCenter defaultCenter] postNotificationName:Rest_Table_Position_Pictures_Notify object:[myData objectAtIndex:pagerView.selectDataIndex]];
    }
    self.navigationController.zh_fullscreenPopWidth = ScreenSize.width;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.dk_backgroundColorPicker = Controller_Bg;
    self.zh_showCustomNav = YES;
    self.zh_title = @"图片详情";
    
    pagerView = [[ZHPagerLongView alloc] initWithFrame:CGRectMake(0, 64, ScreenSize.width, ScreenSize.height-64-45)
                                    withSelectDataIndex:orginSelectIndex];
    pagerView.delegate = self;
    [self.view addSubview:pagerView];
    [pagerView reloadData];
    
    toolBarView = [[CommentBarView alloc] initWithFrame:CGRectMake(0, ScreenSize.height-45, ScreenSize.width, 45)];
    toolBarView.delegate = self;
    [self.view addSubview:toolBarView];
    
    PictureModel *model = [myData objectAtIndex:orginSelectIndex];
    [toolBarView resetFavSate:[PictureViewModel isFavWithModel:model withType:typeUrlStr]];
}

//ZHPagerLongViewDelegate
-(UIView *)viewForPageIndex:(NSInteger)index
{
    if (index < myData.count) {
        PictureDetailView *view = [[PictureDetailView alloc] initWithFrame:pagerView.bounds
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
        [[NSNotificationCenter defaultCenter] postNotificationName:Fetch_More_Pictures_notify object:myData.lastObject];
    }
}


-(void)didSelectPageIndex:(NSInteger)index
{
    PictureModel *model = [myData objectAtIndex:pagerView.selectDataIndex];
    [toolBarView resetFavSate:[PictureViewModel isFavWithModel:model withType:typeUrlStr]];
}


//CommentBarViewDelegate
-(void)shareAction
{
    ShareView *share = [[ShareView alloc] initWithData:[myData objectAtIndex:pagerView.selectDataIndex]];
    [share showAnimate:YES];
}

-(void)favAction
{
    PictureModel *model = [myData objectAtIndex:pagerView.selectDataIndex];
    if ([PictureViewModel isFavWithModel:model  withType:typeUrlStr]) {
        [PictureViewModel deleteFavWithModel:model withType:typeUrlStr];
        [[ToastHelper sharedToastHelper] toast:@"取消收藏"];
        [toolBarView resetFavSate:NO];
    } else {
        [PictureViewModel saveFavWithModel:model withBlock:^(BOOL result) {
            if (result) {
                [[ToastHelper sharedToastHelper] toast:@"收藏成功"];
                [toolBarView resetFavSate:YES];
            } else {
                [[ToastHelper sharedToastHelper] toast:@"收藏失败"];
            }
        } withType:typeUrlStr];
    }
    if (_isFavType) {
        [TheAppDelegate.rootNavigationController popViewControllerAnimated:YES];
    }
}

-(void)commentActionWithText:(NSString *)content withParent:(id)parent
{
    NSLog(@"content = %@", content);
    PictureDetailView *view = (PictureDetailView *)pagerView.selectView;
    [view pushCommentWithText:content withParentId:parent];
}










@end
