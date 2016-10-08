//
//  ZHPagerHeaderView.h
//  BaoZouTV
//
//  Created by jinkh on 15/1/23.
//  Copyright (c) 2015年 wenxiaopei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, ZHTabState) {
    ZHTabStateNormal       = UIControlStateNormal,
    ZHTabStateSelected  = UIControlStateDisabled
};

@protocol ZHPagerHeaderViewDelegate <NSObject>

- (void)pagerHeaderChangedWithTabIndex:(NSUInteger)_index;

@end

@interface  ZHPagerHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame withData:(NSArray *)dataSource;

@property(strong, nonatomic, readonly) NSArray *dataSource;
@property (assign, nonatomic) NSInteger selectTabIndex;
@property (assign, nonatomic, readonly) NSInteger tabAllCount;
@property (assign, nonatomic) CGFloat tabVisisbleCount;
@property (strong, nonatomic) UIFont *tabFont;

-(void)setTabTextColor:(UIColor *)tabTextColor forState:(ZHTabState)state;


@property (weak, nonatomic) id<ZHPagerHeaderViewDelegate> delegate;

@end
