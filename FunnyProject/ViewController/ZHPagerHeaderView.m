//
//  TvMovieListPagerHeaderView.m
//  BaoZouTV
//
//  Created by jinkh on 15/1/23.
//  Copyright (c) 2015年 wenxiaopei. All rights reserved.
//

#import "ZHPagerHeaderView.h"

@interface ZHPagerHeaderView()
{
    UIScrollView *scrollView;
    UIButton * lastSelectBtn;
    UIView * selectLineView;
    NSMutableArray *btnArray;
}
@end

@implementation ZHPagerHeaderView

-(void)dealloc
{
    ReleaseClass;
    for (UIView *subView in scrollView.subviews) {
        [subView removeFromSuperview];
    }
}

- (instancetype)initWithFrame:(CGRect)frame withData:(NSArray *)dataSource
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _dataSource = dataSource;
        _tabVisisbleCount = _dataSource.count;
        
        self.clipsToBounds = YES;
        btnArray = [[NSMutableArray alloc] init];
        [self setBackgroundColor:[UIColor whiteColor]];
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.bounces = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        
        [self fillScrollview];
    }
    return self;
}

-(void)fillScrollview
{
    [btnArray removeAllObjects];
    for (UIView *subView in scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    if (_dataSource != nil && _dataSource.count > 0) {
        float btnWidth = self.frame.size.width/_tabVisisbleCount;
        for (int i =0; i<_dataSource.count; i++) {
            NSString *item = [_dataSource objectAtIndex:i];
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(btnWidth*i, 0, btnWidth, self.frame.size.height-1)];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:item forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [btn setTitleColor:COLORA(255, 255, 255, .8) forState:UIControlStateNormal];
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            btn.tag = i;
            btn.titleLabel.font = DefaultFont(19);
            btn.enabled = YES;
            [scrollView addSubview:btn];
            if (i == 0) {
                lastSelectBtn = btn;
                lastSelectBtn.enabled = NO;
            }
            [btnArray addObject:btn];
        }
        scrollView.contentSize = CGSizeMake(btnWidth*_dataSource.count, scrollView.frame.size.height);
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, lastSelectBtn.frame.size.height - 1,scrollView.bounds.size.width, 1)];
        line.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:line];
        
        
        selectLineView = [[UIView alloc]initWithFrame:CGRectMake(lastSelectBtn.frame.origin.x, lastSelectBtn.frame.size.height - 3, btnWidth, 2)];
        selectLineView.backgroundColor = [lastSelectBtn titleColorForState:(UIControlStateDisabled)];
        [scrollView addSubview:selectLineView];
    }
    [self moveToButton:lastSelectBtn];
}

-(void)setTabFont:(UIFont *)tabFont
{
    _tabFont = tabFont;
    for (UIButton *btn in btnArray) {
        btn.titleLabel.font = tabFont;
    }
    [self setNeedsDisplay];
}

-(void)setTabTextColor:(UIColor *)tabTextColor forState:(ZHTabState)state
{
    for (UIButton *btn in btnArray) {
        [btn setTitleColor:tabTextColor forState:(UIControlState)state];
    }
    selectLineView.backgroundColor = [lastSelectBtn titleColorForState:(UIControlState)ZHTabStateSelected];
    [self setNeedsDisplay];
}

-(void)setTabVisisbleCount:(CGFloat)tabVisisbleCount
{
    
    _tabVisisbleCount = tabVisisbleCount;
    [self fillScrollview];
    [self setNeedsDisplay];
}


-(void)setSelectTabIndex:(NSInteger)_index
{
    _selectTabIndex = _index;
    UIButton *btn = [btnArray objectAtIndex:_index];
    
    [self moveToButton:btn];
    
}

-(NSInteger)tabAllCount
{
    return _dataSource.count;
}

-(void)btnAction:(UIButton *)btn
{

    //[self moveToButton:btn];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagerHeaderChangedWithTabIndex:)])
        [self.delegate pagerHeaderChangedWithTabIndex:btn.tag];
}

- (void)moveToButton:(UIButton *)btn{

    _selectTabIndex = btn.tag;
    lastSelectBtn.enabled = YES;
    lastSelectBtn = btn;
    lastSelectBtn.enabled = NO;
    
    CGRect lastFrame = selectLineView.frame;
    lastFrame.origin.x = lastFrame.size.width * btn.tag;
    
    [UIView animateWithDuration:0.2 animations:^{
        selectLineView.frame = lastFrame;
        if (lastFrame.origin.x- scrollView.contentOffset.x> (self.frame.size.width-lastFrame.size.width)) {
            scrollView.contentOffset = CGPointMake((btn.tag+1-_tabVisisbleCount)*lastFrame.size.width, 0);
        }
        if (lastFrame.origin.x < scrollView.contentOffset.x) {
            scrollView.contentOffset = CGPointMake(btn.tag*lastFrame.size.width, 0);
        }
    } completion:^(BOOL finished) {
        
    }];
}
@end
