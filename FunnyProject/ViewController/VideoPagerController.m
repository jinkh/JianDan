//
//  VideoPagerController.m
//  FunnyProject
//
//  Created by Zinkham on 16/8/2.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "VideoPagerController.h"
#import "VideoController.h"

@interface VideoPagerController ()
{
    NSMutableArray *pagerArray;
}

@end

@implementation VideoPagerController

-(instancetype)init
{
    if (self = [super init]) {
        pagerArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(UIView *)contentViewForPagerAtIndex:(NSInteger)index
{
    VideoController *pager = [[VideoController alloc] initWithRandom:(index==1)];
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
