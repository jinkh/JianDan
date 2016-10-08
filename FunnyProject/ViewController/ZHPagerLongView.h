//
//  ZHPagerLongView.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/19.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZHPagerLongViewDelegate<NSObject>

@optional

-(UIView *)viewForPageIndex:(NSInteger)index;

-(void)didSelectPageIndex:(NSInteger)index;

-(NSInteger)dataCountForPage;

-(void)checkNeedFetchMore;

@end


@interface ZHPagerLongView : UIView

-(instancetype)initWithFrame:(CGRect)frame withSelectDataIndex:(NSInteger)index;

@property (strong, nonatomic, readonly) UIScrollView *scrollView;

@property (assign, nonatomic, readonly) NSInteger selectPageIndex;

@property (assign, nonatomic, readonly) NSInteger selectDataIndex;

@property (strong, nonatomic) UIView *selectView;

@property (weak, nonatomic) id<ZHPagerLongViewDelegate>delegate;

-(void)reloadData;

@end
