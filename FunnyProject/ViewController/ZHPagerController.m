//
//  ZHPagerController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/13.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ZHPagerController.h"
#import "AppStoreManager.h"

@interface ZHPagerController () 
{
    
    ZHPagerHeaderView *headerView;
    
    ZHPagerView *pagerView;

    CGFloat visibleCount;
}

@end

@implementation ZHPagerController

-(void)dealloc
{
    ReleaseClass;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.view.dk_backgroundColorPicker = Controller_Bg;
    self.zh_showCustomNav = YES;
    
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setTitle:@"\U0000e6b4" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = IconFont(20);
    [leftBtn addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.zh_customNav addSubview:leftBtn];
    
    if ([AppStoreManager isInReview] ) {
        leftBtn.hidden = YES;
    } else {
        leftBtn.hidden = NO;
    }
    
    NSArray *headerData = [self headerDataForPager];
    visibleCount = 3.5;
    if (headerData.count < visibleCount) {
        visibleCount = headerData.count;
    }

    
    headerView = [[ZHPagerHeaderView alloc] initWithFrame:CGRectMake((ScreenSize.width-visibleCount*70)*.5, 20, visibleCount*70, 44)
                                                 withData:headerData];
    headerView.center = CGPointMake(ScreenSize.width*.5, 42);
    headerView.delegate = self;
    headerView.tabVisisbleCount = visibleCount;
    headerView.backgroundColor = [UIColor clearColor];
    [self.zh_customNav addSubview:headerView];
    
    
    pagerView = [[ZHPagerView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    pagerView.delegate = self;
    pagerView.pageCount = headerData.count;
    [self.view addSubview:pagerView];
}

-(void)showLeftMenu
{
    [TheAppDelegate.deckController openLeftView];
}

-(UIView *)contentViewForPagerAtIndex:(NSInteger)index
{
    return nil;
}

-(NSArray *)headerDataForPager
{
    return [NSArray array];
}

//ZHPagerViewDelegate
-(void)didSelectPageIndex:(NSInteger)index
{
    [headerView setSelectTabIndex:index];
}

-(UIView *)viewForPageIndex:(NSInteger)index
{
    return [self contentViewForPagerAtIndex:index];
}



//ZHPagerHeaderViewDelegate
- (void)pagerHeaderChangedWithTabIndex:(NSUInteger)_index
{
    [pagerView setSelectPageIndex:_index];
}

-(void)reloadData
{
    
    headerView.delegate = nil;
    [headerView removeFromSuperview];
    
    pagerView.delegate = nil;
    [pagerView removeFromSuperview];
    
    
    
    NSArray *headerData = [self headerDataForPager];
    
    visibleCount = 3.5;
    if (headerData.count < visibleCount) {
        visibleCount = headerData.count;
    }
    headerView = [[ZHPagerHeaderView alloc] initWithFrame:CGRectMake((ScreenSize.width-visibleCount*70)*.5, 20, visibleCount*70, 44)
                                                 withData:headerData];
    headerView.center = CGPointMake(ScreenSize.width*.5, 42);
    headerView.delegate = self;
    headerView.tabVisisbleCount = visibleCount;
    headerView.backgroundColor = [UIColor clearColor];
    [self.zh_customNav addSubview:headerView];
    
    
    pagerView = [[ZHPagerView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    pagerView.delegate = self;
    pagerView.pageCount = headerData.count;
    [self.view addSubview:pagerView];
    
}









@end
