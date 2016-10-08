//
//  TvVideoMenuView.h
//  DemoApp
//
//  Created by Zinkham on 15/11/6.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

@interface TvVideoMenuView : UIView


@property (nonatomic, copy) void (^clickMenuItemBlock)(int index);

-(void)showMenuInView:(UIView *)pView;

-(void)dismissMenuAnimed:(BOOL)anim;

-(void)setSelectedIndex:(int)index;

-(NSString *)getTitleWithIndex:(int)index;

@end

