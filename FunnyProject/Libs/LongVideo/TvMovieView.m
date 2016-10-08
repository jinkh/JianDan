//
//  TvMovieView.m
//  DemoApp
//
//  Created by Zinkham on 15/11/3.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#import "TvMovieView.h"
#import "TvMovieControll.h"
#import "TvMovieWebController.h"
#import "TvVideoAdView.h"
#import "IJKMediaPlayback.h"
#import "IJKAVMoviePlayerController.h"
#import "TvMovieFullController.h"
#import "TvOrentionManager.h"

@interface TvMovieView () <UIAlertViewDelegate>
{
    
    CGRect portraitFrame;
    
    TvMovieControll *videoControll;
    
    UIActivityIndicatorView *loadingIndicator;
    
    int lastPalyedTime;
    
    BOOL isResetType;
    
    NSString *htmlUrlStr;
    
     NSString *realUrlStr;
    
    NSString *title;
    
    int videoTypeValue;
    
    TvVideoAdView *adView;
    
    IJKAVMoviePlayerController *videoPlayer;
}

@end

@implementation TvMovieView
@synthesize interfaceOrientation;
@synthesize repeat = _repeat;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        title = @"";
        htmlUrlStr = @"";
        realUrlStr = @"";
        videoTypeValue = 2;
        interfaceOrientation = UIInterfaceOrientationPortrait;
        portraitFrame = self.frame;
        self.backgroundColor = [UIColor blackColor];
        adView = [[TvVideoAdView alloc] initWithFrame:self.bounds];
        //[self addSubview:adView];
        
    }
    return self;
}

-(instancetype)init
{
    if (self = [super init]) {
        title = @"";
        htmlUrlStr = @"";
        realUrlStr = @"";
        videoTypeValue = 2;
        interfaceOrientation = UIInterfaceOrientationPortrait;
        portraitFrame = self.frame;
        self.backgroundColor = [UIColor blackColor];
        adView = [[TvVideoAdView alloc] initWithFrame:self.bounds];
        [self addSubview:adView];
    }
    return self;
}

-(void)setViewInterfaceOrientation:(UIInterfaceOrientation)orention
{
    interfaceOrientation = orention;
    if (orention == UIInterfaceOrientationPortrait) {
        self.frame = portraitFrame;
        if (videoPlayer) {
            [videoControll setControllInterfaceOrientation:orention];
            loadingIndicator.center = videoPlayer.view.center;
            videoPlayer.view.frame = self.bounds;
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        }
    } else {
        CGFloat fullWidth = MAX(ScreenSize.width, ScreenSize.height);
        CGFloat fullHeight = MIN(ScreenSize.width, ScreenSize.height);
        self.frame = CGRectMake(0, 0, fullWidth, fullHeight);
        NSLog(@"---frame = %@", NSStringFromCGRect(self.frame));
        if (videoPlayer) {
            [videoControll setControllInterfaceOrientation:orention];
            loadingIndicator.center = videoPlayer.view.center;
            videoPlayer.view.frame = self.bounds;
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        }
    }
    [adView setAdViewlInterfaceOrientation:interfaceOrientation];
}

-(void)destory
{
    if (videoPlayer) {
        [self removeMovieNotificationObservers];
        
        lastPalyedTime = videoPlayer.currentPlaybackTime;

        [loadingIndicator removeFromSuperview];
        loadingIndicator = nil;
        
        videoControll.delegatePlayer = nil;
        [videoControll removeFromSuperview];
        videoControll = nil;
        
        [videoPlayer shutdown];
        [videoPlayer.view removeFromSuperview];
        videoPlayer = nil;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [NSObject cancelPreviousPerformRequestsWithTarget:videoControll];
    
    }
    [self removeFromSuperview];
}

-(void)changeVideoType:(NSNotification *)notification
{
    int typeValue = [((NSNumber *)notification.object) intValue];
    [self resetVideoType:typeValue];
}


-(void)resetVideoType:(int)typeValue
{
    isResetType = YES;
    //不论有无这个清晰度都切换，具体后面优化
    videoTypeValue = typeValue;
    [self destory];
    NSString *pathExtension = [htmlUrlStr pathExtension];
    BOOL isMp4 = [@"MP4" compare:pathExtension options:NSCaseInsensitiveSearch] == NSOrderedSame;
    if (isMp4) {
        [self playVideoWithRealUrl:htmlUrlStr withTitle:title];
        [self resetVideoType:typeValue];
        return;
    }
}

-(void)pausePlay
{
    if (videoPlayer) {
        [videoPlayer pause];
    }
}

-(void)resumePlay
{
    if (videoPlayer) {
        [videoPlayer play];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%d",(int)buttonIndex);
    if (buttonIndex == 1) {
        TvMovieWebController *web = [[TvMovieWebController alloc] init];
        web.title = title;
        web.urlStr = htmlUrlStr;
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        if ([root isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController*)root pushViewController:web animated:YES];
        } else {
            [root.navigationController pushViewController:web animated:YES];
        }
    }
}

-(void)playVideoWithRealUrl:(NSString *)url withTitle:(NSString *)vTitle
{
    [self destory];
    title = vTitle;
    realUrlStr = url;
    
    videoPlayer = [[IJKAVMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:url]];
    videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    videoPlayer.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
     videoPlayer.scalingMode = IJKMPMovieScalingModeAspectFit;
    videoPlayer.view.backgroundColor = [UIColor clearColor];
    videoPlayer.view.autoresizesSubviews = YES;
    [videoPlayer prepareToPlay];
    [self addSubview:videoPlayer.view];

    
    videoControll = [[TvMovieControll alloc] initWithFrame:videoPlayer.view.bounds];
        videoControll.delegatePlayer = videoPlayer;
    [videoControll refreshMediaControl];
    [videoControll setTitle:title];
    [videoControll resetVideoType:videoTypeValue];
    [videoPlayer.view addSubview:videoControll];
    
    __weak typeof(self) weakSelf = self;
    videoControll.fullScreenBlock = ^{
        TvMovieFullController *full = [[TvMovieFullController alloc] initWithMoviePlayer:weakSelf];
        [TheAppDelegate.deckController presentViewController:full animated:NO completion:nil];
    };
    
    videoControll.goBackBlock = ^{

        if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
            [weakSelf destory];
        } else {
            [TheAppDelegate.deckController dismissViewControllerAnimated:NO completion:nil];
        }
    };
    
    [self installMovieNotificationObservers];
    
    
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadingIndicator.center = videoPlayer.view.center;
    [videoPlayer.view addSubview:loadingIndicator];
    [loadingIndicator startAnimating];
    
    adView.hidden = NO;
    [self bringSubviewToFront:adView];
    
    [self setViewInterfaceOrientation:interfaceOrientation];
}

-(void)playVideoWithLocallUrl:(NSString *)urlStr withTitle:(NSString *)vTitle
{
    [self destory];
    title = vTitle;
    realUrlStr = urlStr;

    
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    NSLog(@"----url = %@", url.absoluteString);
    
    videoPlayer = [[IJKAVMoviePlayerController alloc] initWithContentURL:url];
    videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    videoPlayer.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    videoPlayer.scalingMode = IJKMPMovieScalingModeAspectFit;
    videoPlayer.view.backgroundColor = [UIColor clearColor];
    videoPlayer.view.autoresizesSubviews = YES;
    [videoPlayer prepareToPlay];
    [self addSubview:videoPlayer.view];
    
    videoControll = [[TvMovieControll alloc] initWithFrame:videoPlayer.view.bounds];
    videoControll.delegatePlayer = videoPlayer;
    [videoControll refreshMediaControl];
    [videoControll setTitle:title];
    [videoControll setTypeBtnEnabled:NO];
    [videoControll resetVideoType:videoTypeValue];
    [videoPlayer.view addSubview:videoControll];
    
    __weak typeof(self) weakSelf = self;
    videoControll.fullScreenBlock = ^{
        TvMovieFullController *full = [[TvMovieFullController alloc] initWithMoviePlayer:weakSelf];
        [TheAppDelegate.deckController presentViewController:full animated:NO completion:nil];
    };
    
    videoControll.goBackBlock = ^{
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
            [weakSelf destory];
        } else {
            [TheAppDelegate.deckController dismissViewControllerAnimated:NO completion:nil];
        }
    };
    
    [self installMovieNotificationObservers];
    
    
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadingIndicator.center = videoPlayer.view.center;
    [videoPlayer.view addSubview:loadingIndicator];
    [loadingIndicator startAnimating];
    
    adView.hidden = NO;
    [self bringSubviewToFront:adView];
    
    [self setViewInterfaceOrientation:interfaceOrientation];
}

-(void)moviePreparedToPlay:(NSNotification*)notification
{
    [loadingIndicator stopAnimating];
    [self resumePlay];
    adView.hidden = YES;
    if (isResetType) {
        isResetType = NO;
        videoPlayer.currentPlaybackTime = lastPalyedTime;
    }
    NSLog(@"moviePreparedToPlay: ok");
}

- (void)loadStateDidChange:(NSNotification*)notification
{
    
    IJKMPMovieLoadState loadState = videoPlayer.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        [loadingIndicator stopAnimating];
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        [loadingIndicator startAnimating];
        
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    }else if ((loadState & IJKMPMovieLoadStatePlayable) != 0) {
        [loadingIndicator stopAnimating];
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlayable: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: MPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: MPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: MPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}


- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    
    switch (videoPlayer.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"moviePlayBackStateDidChange %d: stoped", (int)videoPlayer.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            [loadingIndicator stopAnimating];
            NSLog(@"moviePlayBackStateDidChange %d: playing", (int)videoPlayer.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"moviePlayBackStateDidChange %d: paused", (int)videoPlayer.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"moviePlayBackStateDidChange %d: interrupted", (int)videoPlayer.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            [loadingIndicator  startAnimating];
            NSLog(@"moviePlayBackStateDidChange %d: seeking", (int)videoPlayer.playbackState);
            break;
        }
        default: {
            NSLog(@"moviePlayBackStateDidChange %d: unknown", (int)videoPlayer.playbackState);
            break;
        }
    }
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:videoPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:videoPlayer];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:videoPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePreparedToPlay:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:videoPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeVideoType:) name:@"ChangeVideoType" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlay) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumePlay) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:videoPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:videoPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:videoPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:videoPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeVideoType" object:self];
      [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:self];
      [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(NSURL *)playUrl
{
    return videoPlayer.playUrl;
}

-(BOOL)isShutdown
{
    return videoPlayer.isShutdown;
}

-(BOOL)repeat
{
    return videoPlayer.repeat;
}

-(void)setRepeat:(BOOL)rep
{
    _repeat = rep;
    videoPlayer.repeat = rep;
}

-(void)dealloc
{

}

@end
