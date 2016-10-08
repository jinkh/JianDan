//
//  ZHPagerView.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/19.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ZHPagerView.h"

@interface ZHPagerView () <UIScrollViewDelegate>

@end

@implementation ZHPagerView


-(void)dealloc
{
    ReleaseClass;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
    }
    return self;
}

-(void)setPageCount:(NSInteger)pageCount
{
    
    _pageCount = pageCount;
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width*_pageCount, _scrollView.bounds.size.height);
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewForPageIndex:)]) {
        for (int i = 0; i <  _pageCount; i++) {
            UIView *view = [self.delegate viewForPageIndex:i];
            if (view) {
                view.frame = CGRectMake(_scrollView.bounds.size.width*i, 0,
                                        view.frame.size.width, view.frame.size.height);
                [_scrollView addSubview:view];
            }
        }
    }
}

-(void)setSelectPageIndex:(NSInteger)selectPageIndex
{
    _selectPageIndex = selectPageIndex;
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*selectPageIndex, _scrollView.contentOffset.y) animated:YES];
}

-(void)checkSwithchPage
{
    // 得到每页宽度
    CGFloat pageWidth = _scrollView.bounds.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    NSInteger page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page <= 0) {
        page = 0;
    }
    if (page >= self.pageCount) {
        page = self.pageCount-1;
    }
    if (_selectPageIndex != page) {
        _selectPageIndex = page;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectPageIndex:)]) {
            [self.delegate didSelectPageIndex:_selectPageIndex];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self checkSwithchPage];
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)_scrollView willDecelerate:(BOOL)_decelerate
//{
//    if (_decelerate == NO) {
//        [self checkSwithchPage];
//    }
//}
//
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
//{
//    [self checkSwithchPage];
//}

@end
