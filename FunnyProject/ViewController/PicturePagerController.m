//
//  PicturePagerController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/19.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "PicturePagerController.h"
#import "PictureController.h"

@interface PicturePagerController ()
{
    NSString *urlString;
    NSMutableArray *pagerArray;
}

@end

@implementation PicturePagerController

-(instancetype)initWithUrl:(NSString *)urlStr
{
    if (self = [super init]) {
        urlString = urlStr;
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
    PictureController *pager = [[PictureController alloc] initWithUrl:urlString isRandom:(index==1)];
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
