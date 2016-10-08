//
//  TvMovieControll.m
//  DemoApp
//
//  Created by Zinkham on 15/11/2.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#import "TvMovieControll.h"
#import "TvFastRewindView.h"
#import "TvProgressView.h"
#import "TvVideoMenuView.h"
#import "TvOrentionManager.h"
#import <MediaPlayer/MPMusicPlayerController.h>
#import "TvMovieFullController.h"
#import "TVSliderView.h"

#define Controll_Height 35

@interface TvMovieControll ()<UIGestureRecognizerDelegate>
{
    
     BOOL isMediaSliderBeingDragged;
    
    
    UIInterfaceOrientation  interfaceorention;
    
    BOOL isShowToolBar;
    
    UIImageView *topControllView;
    
    UIButton *backBtn;
    
    UILabel *titleLabel;
    
    UIButton *lockBtn;
    
    UIImageView *bottomControllView;
    
    UIButton *playControllBtn;
    
    UIButton *fullBtn;
    
    TVSliderView *sliderView;
    
    UILabel *totalDurationLabel;
    
    UILabel *currentTimeLabel;
    
    int panMode;
    
    TvFastRewindView *frView;
    
    TvProgressView *loadProgress;
    
    UIButton *typeBtn;
    
    TvVideoMenuView *videoMenu;
    
    int videoTypeIndex;
}
@end

@implementation TvMovieControll

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [ super initWithFrame:frame]) {
        panMode = -1;
        videoTypeIndex = 2;
        interfaceorention = UIInterfaceOrientationPortrait;
        self.backgroundColor = [UIColor clearColor];
        isShowToolBar = NO;
        topControllView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, Controll_Height)];
        topControllView.alpha = 0;
        topControllView.userInteractionEnabled = YES;
        topControllView.image = [UIImage imageNamed:@"top_bar"];
        [self addSubview:topControllView];
        
        backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, topControllView.frame.size.height)];
        backBtn.backgroundColor = [UIColor clearColor];
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"back_s"] forState:UIControlStateHighlighted];
        backBtn.titleLabel.font = DefaultFont(16);
        [backBtn addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [topControllView addSubview:backBtn];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, frame.size.width-100, topControllView.frame.size.height)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = DefaultFont(17);
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.hidden = YES;
        [topControllView addSubview:titleLabel];
        
        lockBtn = [[UIButton alloc] initWithFrame:CGRectMake(topControllView.frame.size.width-45, 0, 45, topControllView.frame.size.height)];
        lockBtn.backgroundColor = [UIColor clearColor];
        [lockBtn setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
        [lockBtn setImage:[UIImage imageNamed:@"lock_s"] forState:UIControlStateHighlighted];
        [lockBtn setImage:[UIImage imageNamed:@"locked"] forState:UIControlStateSelected];
        lockBtn.titleLabel.font = DefaultFont(16);
        lockBtn.hidden = YES;
        [lockBtn addTarget:self action:@selector(lockAction:) forControlEvents:UIControlEventTouchUpInside];
        [topControllView addSubview:lockBtn];
        
        bottomControllView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-Controll_Height, frame.size.width, Controll_Height)];
        bottomControllView.alpha = 0;
        bottomControllView.userInteractionEnabled = YES;
        bottomControllView.image = [UIImage imageNamed:@"bottom_bar"];
        [self addSubview:bottomControllView];
        
        playControllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, bottomControllView.frame.size.height)];
        playControllBtn.backgroundColor = [UIColor clearColor];
        [playControllBtn setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
        [playControllBtn setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateSelected];
        playControllBtn.titleLabel.font = DefaultFont(16);
        [playControllBtn addTarget:self action:@selector(playControllAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomControllView addSubview:playControllBtn];
        
        fullBtn = [[UIButton alloc] initWithFrame:CGRectMake(bottomControllView.frame.size.width-45, 0, 45, bottomControllView.frame.size.height)];
        fullBtn.backgroundColor = [UIColor clearColor];
        [fullBtn setImage:[UIImage imageNamed:@"full_mode"] forState:UIControlStateNormal];
                 fullBtn.titleLabel.font = DefaultFont(16);
        [fullBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomControllView addSubview:fullBtn];
        
        
        typeBtn = [[UIButton alloc] initWithFrame:fullBtn.frame];
        typeBtn.backgroundColor = [UIColor clearColor];
        [typeBtn setTitle:@"高清" forState:UIControlStateNormal];
        typeBtn.titleLabel.font = DefaultFont(16);
        typeBtn.hidden = YES;
        [typeBtn addTarget:self action:@selector(videoTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomControllView addSubview:typeBtn];
        
        loadProgress = [[TvProgressView alloc] initWithFrame:CGRectMake(85+2, bottomControllView.frame.size.height*.5-2.5, frame.size.width-170-4, 5)];
        [loadProgress setInnerColor:[UIColor grayColor]];
        [loadProgress setEmptyColor:[UIColor clearColor]];
        [loadProgress setOuterColor:[UIColor clearColor]];
        [loadProgress setProgress:0];
        [bottomControllView addSubview:loadProgress];
        
        
        sliderView = [[TVSliderView alloc] initWithFrame:CGRectMake(85, 0, frame.size.width-170, bottomControllView.frame.size.height)];
        
        UIImage *minumumImage = [[UIImage imageNamed:@"slider_min"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
        [sliderView setMinimumTrackImage:minumumImage forState:UIControlStateNormal];
        [sliderView setMaximumTrackImage:[UIImage imageNamed:@"slider_max"] forState:UIControlStateNormal];
        [sliderView setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
        [sliderView setThumbImage:[UIImage imageNamed:@"slider_s"] forState:UIControlStateHighlighted];
        sliderView.maximumValue = 1;
        sliderView.minimumValue = 0;
        sliderView.value = 0;
        [sliderView addTarget:self action:@selector(didSliderTouchBegin) forControlEvents:UIControlEventTouchDown];
        [sliderView addTarget:self action:@selector(didSliderValueChanged) forControlEvents:UIControlEventValueChanged];
        [sliderView addTarget:self action:@selector(didSliderTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        [sliderView addTarget:self action:@selector(didSliderTouchEnd) forControlEvents:UIControlEventTouchUpOutside];
        [sliderView addTarget:self action:@selector(didSliderTouchEnd) forControlEvents:UIControlEventTouchCancel];
        [bottomControllView addSubview:sliderView];
        
        totalDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-85, 0, 45, bottomControllView.frame.size.height)];
        totalDurationLabel.backgroundColor = [UIColor clearColor];
        totalDurationLabel.font = DefaultFont(12);
        totalDurationLabel.textAlignment = NSTextAlignmentLeft;
        totalDurationLabel.textColor = [UIColor whiteColor];
        totalDurationLabel.contentMode = UIViewContentModeScaleToFill;
        totalDurationLabel.text = @"--:--";
        [bottomControllView addSubview:totalDurationLabel];
        
        currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 45, bottomControllView.frame.size.height)];
        currentTimeLabel.backgroundColor = [UIColor clearColor];
        currentTimeLabel.font = DefaultFont(12);
        currentTimeLabel.textAlignment = NSTextAlignmentRight;
        currentTimeLabel.textColor = [UIColor whiteColor];
        currentTimeLabel.contentMode = UIViewContentModeScaleToFill;
        currentTimeLabel.text = @"--:--";
        [bottomControllView addSubview:currentTimeLabel];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tapGes.delegate = self;
        [self addGestureRecognizer:tapGes];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        panGes.delegate = self;
        [self addGestureRecognizer:panGes];
        
    }
    return self;
}

-(void)setControllInterfaceOrientation:(UIInterfaceOrientation)orention
{
    interfaceorention = orention;
    CGRect frame = self.delegatePlayer.view.bounds;
    self.frame = frame;
    
    if (interfaceorention == UIInterfaceOrientationPortrait) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        titleLabel.hidden = YES;
        fullBtn.hidden = NO;
        typeBtn.hidden = YES;
        lockBtn.hidden = YES;
        
        topControllView.frame = CGRectMake(0, 0, frame.size.width, Controll_Height);
        backBtn.frame = CGRectMake(0, 0, 45, topControllView.frame.size.height);
        titleLabel.frame = CGRectMake(50, 0, frame.size.width-100, topControllView.frame.size.height);
        
        bottomControllView.frame = CGRectMake(0, frame.size.height-Controll_Height, frame.size.width, Controll_Height);
        
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:!isShowToolBar];
        titleLabel.hidden = NO;
        fullBtn.hidden = YES;
        typeBtn.hidden = YES;
        lockBtn.hidden = YES;
        
        topControllView.frame = CGRectMake(0, 0, frame.size.width, Controll_Height+30);
        backBtn.frame = CGRectMake(0, 20, 45, Controll_Height+10);
        titleLabel.frame = CGRectMake(50, 20, frame.size.width-100, Controll_Height+10);
        lockBtn.frame = CGRectMake(topControllView.frame.size.width-45, 20, 45, Controll_Height+10);

        bottomControllView.frame = CGRectMake(0, frame.size.height-(Controll_Height+10), frame.size.width, Controll_Height+10);
    }
    
    playControllBtn.frame = CGRectMake(0, 0, 45, bottomControllView.frame.size.height);
    sliderView.frame = CGRectMake(85, 0, frame.size.width-170, bottomControllView.frame.size.height);
    currentTimeLabel.frame = CGRectMake(40, 0, 45, bottomControllView.frame.size.height);
    totalDurationLabel.frame = CGRectMake(frame.size.width-85, 0, 45, bottomControllView.frame.size.height);
    fullBtn.frame = CGRectMake(bottomControllView.frame.size.width-45, 0, 45, bottomControllView.frame.size.height);
    typeBtn.frame = fullBtn.frame;
    loadProgress.frame = CGRectMake(sliderView.frame.origin.x+2, sliderView.frame.size.height*.5-2.5, sliderView.frame.size.width-4, 5);
    if (videoMenu) {
        [videoMenu dismissMenuAnimed:NO];
    }
}

-(void)setTitle:(NSString *)title
{
    titleLabel.text = title;
}

-(void)panAction:(UIPanGestureRecognizer *)gesture
{
    NSTimeInterval duration = self.delegatePlayer.duration;
    NSInteger intDuration = duration + 0.5;
    if (intDuration <= 0) {
        return;
    }
    
    if (interfaceorention != UIInterfaceOrientationPortrait) {
        CGPoint translation = [gesture translationInView:self];
        if (gesture.state == UIGestureRecognizerStateBegan) {
            panMode = -1;
        } else if (gesture.state == UIGestureRecognizerStateChanged){
            
            if (panMode == -1) {
                if (fabs(translation.x) >= fabs(translation.y)) {
                    //左右移动
                    panMode = 0;
                    if (!frView) {
                        frView = [[TvFastRewindView alloc] initWithFrame:self.bounds];
                        frView.hidden = YES;
                        frView.duration = self.delegatePlayer.duration;
                        frView.initTime = self.delegatePlayer.currentPlaybackTime;
                        [self addSubview:frView];
                    }
                    frView.duration = self.delegatePlayer.duration;
                    frView.initTime = self.delegatePlayer.currentPlaybackTime;
                    frView.hidden = NO;
                } else {
                    
                    CGPoint startPoint = [gesture locationInView:self];
                    if (startPoint.x < self.frame.size.width*.5) {
                        //上下移动,左半屏
                        panMode = 1;
                    } else {
                        //上下移动,右半屏
                        panMode = 2;
                    }
                }
            }
            
            
            if (panMode == 0) {
                if (translation.x >= 0) {
                    [frView fast];
                } else {
                    [frView rewind];
                }
            } else if (panMode == 1) {
                if (translation.y >= 0) {
                    float bright = [UIScreen mainScreen].brightness-0.02;
                    [[UIScreen mainScreen] setBrightness:bright];
                } else {
                    float bright = [UIScreen mainScreen].brightness+0.02;
                    [[UIScreen mainScreen] setBrightness:bright];
                }
            } else {
                //上下移动
                if (translation.y >= 0) {
                    float volume = [MPMusicPlayerController applicationMusicPlayer].volume-0.02;
                    [MPMusicPlayerController applicationMusicPlayer].volume = volume;
                } else {
                    float volume = [MPMusicPlayerController applicationMusicPlayer].volume+0.02;
                    [MPMusicPlayerController applicationMusicPlayer].volume = volume;
                }
            }
        } else {
            if (panMode == 0) {
                frView.hidden = YES;
                self.delegatePlayer.currentPlaybackTime = frView.initTime;
            } else {
                
            }
            panMode = -1;
        }
        
        [gesture setTranslation:CGPointZero inView:self];
    }
}

-(void)tapAction:(UITapGestureRecognizer *)gesture
{
    NSTimeInterval duration = self.delegatePlayer.duration;
    NSInteger intDuration = duration + 0.5;
    if (intDuration <= 0) {
        return;
    }
    if (isMediaSliderBeingDragged && isShowToolBar) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tapAction:) object:nil];
        [self performSelector:@selector(tapAction:) withObject:nil afterDelay:5];
        return;
    }
    
    isShowToolBar = !isShowToolBar;
    if (interfaceorention != UIInterfaceOrientationPortrait) {
        [[UIApplication sharedApplication] setStatusBarHidden:!isShowToolBar];
    }
    if (isShowToolBar) {
        [UIView animateWithDuration:.3 animations:^{
            topControllView.alpha = 1;
            bottomControllView.alpha = 1;

        }  completion:^(BOOL finished) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tapAction:) object:nil];
            [self performSelector:@selector(tapAction:) withObject:nil afterDelay:5];
        }];
    } else {
        [UIView animateWithDuration:.3 animations:^{
            topControllView.alpha = 0;
            bottomControllView.alpha = 0;
        } completion:^(BOOL finished) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tapAction:) object:nil];
        }];
    }
}

-(void)lockAction:(id)sender
{
    lockBtn.selected = !lockBtn.selected;
    [TvOrentionManager sharedInstance].isOrientationLocked = lockBtn.selected;
}

-(void)goBackAction:(id)sender
{
    //自定义
    if (self.goBackBlock) {
        self.goBackBlock();
        [self tapAction:nil];
    }
    
//    if (self.goBackBlock) {
//        self.goBackBlock();
//    } else {
//        if (interfaceorention == UIInterfaceOrientationPortrait) {
//            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
//            if ([root isKindOfClass:[UINavigationController class]]) {
//                [(UINavigationController*)root popViewControllerAnimated:YES];
//            } else {
//                [root.navigationController popViewControllerAnimated:YES];
//            }
//        } else {
//            lockBtn.selected = NO;
//            [TvOrentionManager sharedInstance].isOrientationLocked = NO;
//            [[TvOrentionManager sharedInstance] setOrentionPortrait];
//        }
//    }
}

-(void)fullScreenAction:(id)sender
{
    if (self.fullScreenBlock) {
        self.fullScreenBlock();
        [self tapAction:nil];
    }
}

-(void)playControllAction:(id)sender
{
    playControllBtn.selected = !playControllBtn.selected;
    if (self.playControllBlock) {
        self.playControllBlock();
    } else {
        if (self.delegatePlayer.isPlaying) {
            [self.delegatePlayer pause];
        } else {
            [self.delegatePlayer play];
        }
    }
}

-(void)videoTypeAction:(id)sender
{
    [self tapAction:nil];
    if (self.videoTypeBlock) {
        self.videoTypeBlock();
    } else {
        if (videoMenu == nil) {
            CGFloat fullWidth = MAX(ScreenSize.width, ScreenSize.height);
            CGFloat fullHeight = MIN(ScreenSize.width, ScreenSize.height);
            videoMenu = [[TvVideoMenuView alloc] initWithFrame:CGRectMake(0, 0, fullWidth, fullHeight)];
            videoMenu.clickMenuItemBlock = ^(int index){
                //切换清晰度
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeVideoType" object:[NSNumber numberWithInt:index]];
            };
        }
        [videoMenu setSelectedIndex:videoTypeIndex];
        [videoMenu showMenuInView:self];
        [self bringSubviewToFront:videoMenu];
    }
}

-(void)resetVideoType:(int)typeValue
{
    if (videoMenu == nil) {
        CGFloat fullWidth = MAX(ScreenSize.width, ScreenSize.height);
        CGFloat fullHeight = MIN(ScreenSize.width, ScreenSize.height);
        videoMenu = [[TvVideoMenuView alloc] initWithFrame:CGRectMake(0, 0, fullWidth, fullHeight)];
        videoMenu.clickMenuItemBlock = ^(int index){
            //切换清晰度
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeVideoType" object:[NSNumber numberWithInt:index]];
        };
    }
    videoTypeIndex = typeValue;
    [videoMenu setSelectedIndex:videoTypeIndex];
    [typeBtn setTitle:[videoMenu getTitleWithIndex:typeValue] forState:UIControlStateNormal];
}

-(void)setTypeBtnEnabled:(BOOL)enable
{
    typeBtn.enabled = enable;
}

- (void)didSliderTouchBegin
{
    isMediaSliderBeingDragged = YES;
}

- (void)didSliderTouchEnd
{
    isMediaSliderBeingDragged = NO;
    self.delegatePlayer.currentPlaybackTime = sliderView.value;
}

- (void)didSliderValueChanged
{
    [self refreshMediaControl];
}

- (void)refreshMediaControl
{
    NSTimeInterval duration = self.delegatePlayer.duration;
    NSInteger intDuration = duration + 0.5;
    if (intDuration > 0) {
        sliderView.maximumValue = duration;
        totalDurationLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
    } else {
        totalDurationLabel.text = @"--:--";
        sliderView.maximumValue = 1.0f;
    }
    
    
    // position
    NSTimeInterval position;
    if (isMediaSliderBeingDragged) {
        position = sliderView.value;
    } else {
        position = self.delegatePlayer.currentPlaybackTime;
    }
    NSInteger intPosition = position + 0.5;
    if (intDuration > 0) {
        sliderView.value = position;
    } else {
        sliderView.value = 0.0f;
    }
    currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intPosition / 60), (int)(intPosition % 60)];
    float progress = [self.delegatePlayer playableDuration]/((float)self.delegatePlayer.duration+1);
    [loadProgress setProgress:progress];
    if (self.delegatePlayer.isPlaying) {
        playControllBtn.selected = NO;
    } else {
        playControllBtn.selected = YES;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
}

-(void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    
    if ([touch.view isDescendantOfView:topControllView] ||
        [touch.view isDescendantOfView:bottomControllView]) {
        
        return NO;
        
    } else {
        if (interfaceorention == UIInterfaceOrientationPortrait
             && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            return  NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}


@end
