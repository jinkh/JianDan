//
//  TvMovieView.h
//  DemoApp
//
//  Created by Zinkham on 15/11/3.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

#define REMOVE_FOR_FULL_SCREEN 14680


@interface TvMovieView : UIView

@property (readonly, assign) UIInterfaceOrientation interfaceOrientation;


-(instancetype)initWithFrame:(CGRect)frame;

-(void)setViewInterfaceOrientation:(UIInterfaceOrientation) orention;

-(void)playVideoWithRealUrl:(NSString *)urlStr withTitle:(NSString *)vTitle;

-(void)playVideoWithLocallUrl:(NSString *)urlStr withTitle:(NSString *)vTitle;

-(void)destory;

-(void)resetVideoType:(int)typeValue;

-(void)pausePlay;

-(void)resumePlay;

@property(strong, readonly, atomic) NSURL *playUrl;
@property(assign, nonatomic, readonly) BOOL isShutdown;
@property(assign, nonatomic) BOOL repeat;

@end
