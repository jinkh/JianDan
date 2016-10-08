//
//  ZHShortPlayerView.h
//  BaoManReader
//
//  Created by xinguang.hu on 15/3/23.
//  Copyright (c) 2015年 Baozou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IJKMediaPlayback.h"
#import "IJKMPMoviePlayerController.h"
#import "IJKAVMoviePlayerController.h"

#define ZHScrollToTopNotification   @"ZHScrollToTop"

@interface ZHShortPlayerView : UIImageView


-(id)initWithFrame:(CGRect)frame withIdentifier:(NSString *)ident;

-(void)setVideoUrl:(NSString *)sourceUrl;

-(void)play;

-(void)shutDownPlay;

-(void)resumePlay;

-(void)pausePlay;

-(void)destroy;

@property (strong, readonly)  NSString *identifier;

@property (strong, readonly, atomic)  NSString *videoUrl;

@end

