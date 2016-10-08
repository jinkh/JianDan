//
//  ArticlePagerController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/19.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ArticlePagerController.h"

#import "ArticleController.h"

@interface ArticlePagerController ()
{
    NSMutableArray *pagerArray;
}

@end

@implementation ArticlePagerController

-(instancetype)init
{
    if (self = [super init]) {
        pagerArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (ArticleController *controller in pagerArray) {
        [controller viewWillAppear:animated];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    TheAppDelegate.deckController.centerController = self;
}

-(UIView *)contentViewForPagerAtIndex:(NSInteger)index
{
    ArticleController *pager = [[ArticleController alloc] initWithRandom:(index==1)];
    pager.view.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height-64);
    pager.view.tag = index;
    //保存下，不然PictureController会立马释放
    [pagerArray addObject:pager];
    return pager.view;
}


-(NSArray *)headerDataForPager
{
    return @[@"最新", @"随机"];
}

@end
