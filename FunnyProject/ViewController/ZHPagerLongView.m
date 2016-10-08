//
//  ZHPagerLongView.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/19.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ZHPagerLongView.h"

#define PreViewTag 1000
#define MiddleViewTag 2000
#define NextViewTag 3000


@interface ZHPagerLongView () <UIScrollViewDelegate>
{
    CGRect preViewFrame;
    CGRect midlleViewFrame;
    CGRect nextViewFrame;
}

@end

@implementation ZHPagerLongView

-(void)dealloc
{
    ReleaseClass;
}

-(instancetype)initWithFrame:(CGRect)frame withSelectDataIndex:(NSInteger)index
{
    if (self = [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = Controller_Bg;
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        //bounces必须为no
        _scrollView.bounces = NO;
        _scrollView.scrollsToTop = NO;
        [_scrollView setMultipleTouchEnabled:NO];
        _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width*3, _scrollView.bounds.size.height);
        [self addSubview:_scrollView];
        
        _selectDataIndex = index;
        if (_selectDataIndex >= 1) {
            _selectPageIndex = 1;
            [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0)];
        } else {
            _selectPageIndex = 0;
            [_scrollView setContentOffset:CGPointMake(0, 0)];
        }
    }
    return self;
}
-(void)reloadData
{
    for (UIView *subView in _scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    NSInteger startIndex = (_selectDataIndex >= 1) ? (_selectDataIndex-1) : 0;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewForPageIndex:)]) {
        UIView *preView = [self.delegate viewForPageIndex:startIndex];
        if (preView) {
            preView.frame = CGRectMake(preView.frame.origin.x, preView.frame.origin.y,
                                       preView.frame.size.width, preView.frame.size.height);
            [_scrollView addSubview:preView];
            preView.tag = PreViewTag;
        }
        preViewFrame = CGRectMake(0, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        
        
        UIView *middleView = [self.delegate viewForPageIndex:startIndex+1];
        if (middleView) {
            middleView.frame = CGRectMake(_scrollView.bounds.size.width+middleView.frame.origin.x, middleView.frame.origin.y,
                                          middleView.frame.size.width, middleView.frame.size.height);
            [_scrollView addSubview:middleView];
            middleView.tag = MiddleViewTag;
        }
        midlleViewFrame = CGRectMake(_scrollView.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        
        UIView *nextView = [self.delegate viewForPageIndex:startIndex+2];
        if (nextView) {
            nextView.frame = CGRectMake(_scrollView.bounds.size.width*2+nextView.frame.origin.x, nextView.frame.origin.y,
                                        nextView.frame.size.width, nextView.frame.size.height);
            [_scrollView addSubview:nextView];
            nextView.tag = NextViewTag;
        }
        nextViewFrame = CGRectMake(_scrollView.bounds.size.width*2, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataCountForPage)]) {
        NSInteger count = [self.delegate dataCountForPage];
        if (count == 1) {
            _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, _scrollView.bounds.size.height);
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectPageIndex:)]) {
        [self.delegate didSelectPageIndex:_selectDataIndex];
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //修复双手指可以从1直接划到3，导致错误,  和最后一页
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataCountForPage)]) {
        NSInteger count = [self.delegate dataCountForPage];
        
        if (_selectDataIndex == 0 || count-1 == _selectDataIndex) {
            _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width*2, _scrollView.bounds.size.height);
        } else {
            _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width*3, _scrollView.bounds.size.height);
            
            UIView *nextView = [_scrollView viewWithTag:NextViewTag];
            //上一次没有更多数据，待数据补充上，要把上次缺失view加上
            if (nextView == nil) {
                nextView = [self.delegate viewForPageIndex:_selectDataIndex+1];
                nextView.tag = NextViewTag;
                nextView.frame = nextViewFrame;
                [_scrollView addSubview:nextView];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)_decelerate
{
    if (_decelerate == NO) {
        [self checkNeedshowNext];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self checkNeedshowNext];
}

-(void)checkNeedshowNext
{
    CGFloat pageWidth = _scrollView.bounds.size.width;
    NSInteger nowPage = ((NSInteger)_scrollView.contentOffset.x) == 0 ?  0 : floor(_scrollView.contentOffset.x / pageWidth);
        if (nowPage >_selectPageIndex) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(dataCountForPage)]) {
                NSInteger count = [self.delegate dataCountForPage];
                if (count-1 == _selectDataIndex) {
                    NSLog(@"最后一页，没有数据啦");
                    return;
                }
            }
            //下一页
            _selectDataIndex++;
                NSLog(@"_selectDataIndex = %ld", _selectDataIndex);
            _selectPageIndex = nowPage;
            if (_selectDataIndex > 1) {
                _selectPageIndex = 1;
                [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0)];

                //把当前2、3页面移动到1、2页面，释放掉当前1页面，请求下一页数据
                UIView *preView = [_scrollView viewWithTag:PreViewTag];
                UIView *middleView = [_scrollView viewWithTag:MiddleViewTag];
                UIView *nextView = [_scrollView viewWithTag:NextViewTag];
                
                middleView.tag = PreViewTag;
                middleView.frame = preViewFrame;
                nextView.tag = MiddleViewTag;
                nextView.frame = midlleViewFrame;
                [preView removeFromSuperview];
                preView = nil;
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(viewForPageIndex:)]) {
                    UIView *newView = [self.delegate viewForPageIndex:_selectDataIndex+1];
                    newView.frame = nextViewFrame;
                    newView.tag = NextViewTag;
                    [_scrollView addSubview:newView];
                    
                }
            } else {
                _selectPageIndex = nowPage;
                [_scrollView setContentOffset:CGPointMake(_selectPageIndex*_scrollView.bounds.size.width, 0)];
            }
        } else if (nowPage <_selectPageIndex) {
            //上一页
            _selectDataIndex--;
            NSLog(@"_selectDataIndex = %ld", _selectDataIndex);
            _selectPageIndex = nowPage;
            if (_selectDataIndex >= 1) {
                _selectPageIndex = 1;
                [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0)];
                //把当前1、2页面移动到2、3页面，释放掉当前3页面，请求上一页数据
                UIView *preView = [_scrollView viewWithTag:PreViewTag];
                UIView *middleView = [_scrollView viewWithTag:MiddleViewTag];
                UIView *nextView = [_scrollView viewWithTag:NextViewTag];
                
                middleView.tag = NextViewTag;
                middleView.frame = nextViewFrame;
                preView.tag = MiddleViewTag;
                preView.frame = midlleViewFrame;
                [nextView removeFromSuperview];
                nextView = nil;
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(viewForPageIndex:)]) {
                    UIView *newView = [self.delegate viewForPageIndex:_selectDataIndex-1];
                    newView.frame = preViewFrame;
                    newView.tag = PreViewTag;
                    [_scrollView addSubview:newView];
                }
            } else {
                _selectPageIndex = nowPage;
                [_scrollView setContentOffset:CGPointMake(_selectPageIndex*_scrollView.bounds.size.width, 0)];
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(dataCountForPage)]) {
                NSInteger count = [self.delegate dataCountForPage];
                if (_selectDataIndex == 0 ) {
                    [[ToastHelper sharedToastHelper] toast:@"已经是第一页"];
                } else if (_selectDataIndex == count-1) {
                    [[ToastHelper sharedToastHelper] toast:@"已经是最后一页"];
                }
            }
        }
        
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkNeedFetchMore)]) {
        [self.delegate checkNeedFetchMore];

    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectPageIndex:)]) {
        [self.delegate didSelectPageIndex:_selectDataIndex];
        
    }

}

-(UIView *)selectView
{
    NSInteger tag = (self.selectPageIndex+1)*1000;
    return [_scrollView viewWithTag:tag];
}


@end
