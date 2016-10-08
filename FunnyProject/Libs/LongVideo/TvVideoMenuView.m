//
//  TvVideoMenuView.m
//  DemoApp
//
//  Created by Zinkham on 15/11/6.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#import "TvVideoMenuView.h"

@interface TvVideoMenuView ()<UIGestureRecognizerDelegate>
{
    NSMutableArray *btnArray;
    
    UIView *bgView;
    
    NSArray *titles;
}
@end

@implementation TvVideoMenuView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgView.backgroundColor = [UIColor blackColor];
        [self addSubview:bgView];
        
        titles = @[@"标清", @"高清", @"超清", @"1080P"];
        btnArray = [[NSMutableArray alloc] init];

        CGFloat btnHeight = 45;
        CGFloat btnWidth = 100;
        CGFloat edgeX = (frame.size.width-btnWidth*titles.count)/2;
        for (int i = 0; i < titles.count; i++) {
            NSString *name = [titles objectAtIndex:i];

            UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(edgeX+btnWidth*i, (frame.size.height-btnHeight)*.5, btnWidth, btnHeight)];
            item.backgroundColor = [UIColor clearColor];
            item.titleLabel.font = DefaultFont(18);
            item.tag = i+1;
            item.clipsToBounds = YES;
            [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [item setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [item setTitle:name forState:UIControlStateNormal];
            [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:item];
            [btnArray addObject:item];
        }
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tapGes.delegate = self;
        [self addGestureRecognizer:tapGes];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        panGes.delegate = self;
        [self addGestureRecognizer:panGes];
        
    }
    return self;
}

-(void)tapAction:(UITapGestureRecognizer *)gesture
{
    [self dismissMenuAnimed:YES];
}

-(void)panAction:(UIPanGestureRecognizer *)gesture
{
    [self dismissMenuAnimed:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

-(void)itemClicked:(UIButton *)sender
{
    int index = (int)sender.tag;
    [self setSelectedIndex:index];
    if (self.clickMenuItemBlock) {
        self.clickMenuItemBlock(index);
    }
    [self dismissMenuAnimed:NO];
}

-(NSString *)getTitleWithIndex:(int)index
{
    return [titles objectAtIndex:index-1];
}

-(void)setSelectedIndex:(int)index
{
    for (int i = 1; i <= btnArray.count; i++) {
        UIButton *item = [btnArray objectAtIndex:i-1];
        if (i == index) {
            item.selected = YES;
            item.layer.cornerRadius = item.frame.size.height*.5;
            item.layer.borderWidth = 1.5;
            item.layer.borderColor = [UIColor redColor].CGColor;
        } else {
            item.selected = NO;
            item.layer.cornerRadius = 0;
            item.layer.borderWidth = 0;
            item.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
}

-(void)showMenuInView:(UIView *)pView
{
    [pView addSubview:self];
    [UIView animateWithDuration:.5 animations:^{
        bgView.alpha = .8;
    }];
}

-(void)dismissMenuAnimed:(BOOL)anim
{
    if (anim) {
        [UIView animateWithDuration:.5 animations:^{
            bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [self removeFromSuperview];
    }


}

@end
