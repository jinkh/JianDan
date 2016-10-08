//
//  ZHPagerView.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/19.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHPagerViewDelegate<NSObject>

@optional

-(UIView *)viewForPageIndex:(NSInteger)index;

-(void)didSelectPageIndex:(NSInteger)index;

@end


@interface ZHPagerView : UIView

-(instancetype)initWithFrame:(CGRect)frame;

@property (assign, nonatomic) NSInteger pageCount;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger selectPageIndex;

@property (weak, nonatomic) id<ZHPagerViewDelegate>delegate;

@end
