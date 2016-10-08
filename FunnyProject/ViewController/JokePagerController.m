//
//  JokePagerController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/19.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "JokePagerController.h"

#import "JokeController.h"

@interface JokePagerController ()
{
    NSMutableArray *pagerArray;
}

@end

@implementation JokePagerController

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
    JokeController *pager = [[JokeController alloc] initWithRandom:(index==1)];
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
