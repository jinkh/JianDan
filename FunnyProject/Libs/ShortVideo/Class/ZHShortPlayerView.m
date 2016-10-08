//
//  ZHShortPlayerView.m
//  BaoManReader
//
//  Created by xinguang.hu on 15/3/23.
//  Copyright (c) 2015年 Baozou. All rights reserved.
//

#import "ZHShortPlayerView.h"
#import "ZHShortVideoManager.h"
#import "TvMovieFullController.h"

@interface ZHShortPlayerView()
{
    
    
    ZHShortVideoManager *manager;
    
}

@end


@implementation ZHShortPlayerView

-(void)destroy
{
    [self shutDownPlay];
    [manager removePlayerView:self];
    
}
-(void)dealloc
{
    NSLog(@"release class:%@",NSStringFromClass([self class]));
}

-(instancetype)init
{
    if (self = [self initWithFrame:CGRectZero]) {
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame withIdentifier:(NSString *)ident
{
    if (self = [super initWithFrame:frame]) {
        _videoUrl = [[NSString alloc] init];
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        
        //重要不同的tableView, identifier必须不同, 否则会混乱
        _identifier = [[NSString alloc] initWithFormat:@"%@", ident];
        
        manager = [[ZHShortVideoManagerDequeue sharecInstance] dequeueManagerWithIdentifier:_identifier];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

-(void)tapAction:(UITapGestureRecognizer *)getsure
{
    if ([ZHShortVideoManager getShouldAutoPlay] == NO) {
        [manager resetIJKVieoPlayWithUrl:_videoUrl];
        manager.moviePlayer.frame = self.bounds;
        [manager.moviePlayer setNeedsDisplay];
        [manager.moviePlayer resumePlay];
        [self addSubview:manager.moviePlayer];
        
        [manager resetLastViewForNotAuto:self];
    }
}


//内容设置
-(void)setVideoUrl:(NSString *)sourceUrl
{
    @synchronized(_videoUrl) {
        //来自重用cell
        if (_videoUrl.length > 0) {
            [self shutDownPlay];
        }
        _videoUrl = [[NSString alloc] initWithFormat:@"%@",sourceUrl];
        
        [manager addPlayerView:self];
    }
}

-(void)shutDownPlay
{
    @synchronized(_videoUrl) {
        if ([_videoUrl isEqualToString:manager.moviePlayer.playUrl.absoluteString]) {
            [manager.moviePlayer destory];
        }
    }
}

-(void)pausePlay
{
    @synchronized(_videoUrl) {
        if ([_videoUrl isEqualToString:manager.moviePlayer.playUrl.absoluteString]) {
            [manager.moviePlayer pausePlay];
        }
    }
}

-(void)resumePlay
{
    @synchronized(_videoUrl) {
        if ([_videoUrl isEqualToString:manager.moviePlayer.playUrl.absoluteString]) {
            [manager.moviePlayer resumePlay];
        }
    }
}

-(void)play
{
    @synchronized(_videoUrl) {
        manager.moviePlayer.frame = self.bounds;
        [manager.moviePlayer setNeedsDisplay];
        
        if ([_videoUrl isEqualToString:manager.moviePlayer.playUrl.absoluteString]) {
            [manager.moviePlayer resumePlay];
            [self addSubview:manager.moviePlayer];
        }
        
    }
}

@end
