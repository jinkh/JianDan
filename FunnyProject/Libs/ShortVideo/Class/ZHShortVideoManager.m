//
//  ZHShortVideoManager.m
//  ZHListVideo
//
//  Created by Zinkham on 16/3/24.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ZHShortVideoManager.h"
#import "TvMovieFullController.h"

#define CenterY ([[UIScreen mainScreen] bounds].size.height*.5)


@interface ZHShortVideoManager()
{
    
    
    BOOL shouldCheckOnTracking;
    
    BOOL  isTracking;
    
    BOOL  isShowInWindow;
    
     BOOL  isVisible;
    
    NSHashTable *dataArrray;
    
    CFRunLoopObserverRef observe;

    __weak ZHShortPlayerView *lastView;
    
    BOOL shouldReplayWhenVisibleAgain;
    
}
@end

@implementation ZHShortVideoManager

static BOOL shouldAutoPaly;

+(void)setShouldAutoPlay:(BOOL)value
{
    shouldAutoPaly = value;
}

+(BOOL)getShouldAutoPlay
{
    return shouldAutoPaly;
}

-(void)dealloc
{
    NSLog(@"release class:%@",NSStringFromClass([self class]));
    [self unregisterObservers];
}

-(instancetype)initWithIdentifier:(NSString *)ident
{
    if (self = [super init]) {
        
        shouldAutoPaly = [SettingManager getSortVideoShoulAuoPlay];
        //初始化变量
        isTracking = NO;
        isShowInWindow = NO;
        shouldCheckOnTracking = NO;
        shouldReplayWhenVisibleAgain = YES;
        dataArrray = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        _identifier = [[NSString alloc] initWithFormat:@"%@", ident];
        
        //初始化播放器
        [self resetIJKVieoPlayWithUrl:@""];
        
        //设置监听
        [self registerObservers];
    }
    return self;
}


-(void)checkPlayState
{
    @autoreleasepool {
        //系统的滑动返回过程忽略,如使用的UINavigationController+FDFullscreenPopGesture,请切换为fd_fullscreenPopGestureRecognizer
        BOOL transing = NO;
        if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
            UIGestureRecognizerState state = ((UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController).zh_fullscreenPopGestureRecognizer.state;
            
            transing =  (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged);
        }
        if (transing) {
            return;
        }
        
        //页面切换后，不可见
        BOOL showInWindow = NO;
        ZHShortPlayerView *chekView = nil;
        for (ZHShortPlayerView *view in dataArrray) {
            if (view.window) {
                showInWindow = YES;
                chekView = view;
                break;
            }
        }
        
        if (isShowInWindow && !showInWindow) {
            [self becomeInvisible];
        }
        if (!isShowInWindow && showInWindow) {
            [self becomeVisible];
        }
        isShowInWindow = showInWindow;
        
        
        if (isShowInWindow && ![[self getPresentedViewController] isKindOfClass:[TvMovieFullController class]]) {
            //scrollview 左右滑动导致可见状态变化
            CGRect rect = [chekView convertRect:chekView.frame toView:[UIApplication sharedApplication].keyWindow];
            BOOL visible = rect.origin.x >= 0 && (rect.origin.x+rect.size.width) <= [UIScreen mainScreen].bounds.size.width;
            if (!visible && isVisible) {
                [self becomeInvisible];
            }
            if (visible && !isVisible) {
                [self becomeVisible];
            }
            isVisible = visible;
        }
        if (!isShowInWindow || !isVisible) {
            //NSLog(@"%@已经切换到可见，直接返回", _identifier);
            return;
        }
        
        BOOL tracking = [NSRunLoop currentRunLoop].currentMode == UITrackingRunLoopMode;
        if (tracking && !isTracking) {
            [self beginTrack];
        }
        if (tracking) {
            [self onTracking];
        }
        if (!tracking && isTracking) {
            //添加延时，避免在setVideoUrl
            [self endTrack];
        }
        isTracking = tracking;
    }
}

-(void)beginTrack
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //开始滑动
        shouldCheckOnTracking = YES;
        NSLog(@"%@  beginTrack", _identifier);
    });
}


-(void)onTracking
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //滑动过程
        if (shouldCheckOnTracking && ![self isDisplayedInScreen:lastView]) {
            [lastView shutDownPlay];
            shouldCheckOnTracking = NO;
        }
        NSLog(@"%@  onTracking", _identifier);
    });
}

-(void)endTrack
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //滑动结束
        shouldCheckOnTracking = NO;
        if (shouldAutoPaly) {
            ZHShortPlayerView *pview = [self getCurrentShouldPlayView];
            if (pview) {
                if (lastView && lastView != pview) {
                    [lastView shutDownPlay];
                }
                [self resetIJKVieoPlayWithUrl:pview.videoUrl];
                [pview play];
                lastView = pview;
            }
        }
        NSLog(@"%@  endTrack", _identifier);
    });
}

-(void)becomeVisible
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //切换到可见
        if (shouldReplayWhenVisibleAgain == NO) {
            [lastView addSubview:_moviePlayer];
            shouldReplayWhenVisibleAgain = YES;
        } else {
            [self endTrack];
        }
        NSLog(@"%@  becomeVisible", _identifier);
    });
}

-(void)becomeInvisible
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //切换到不可见
        if ([[self getPresentedViewController] isKindOfClass:[TvMovieFullController class]]) {
            shouldReplayWhenVisibleAgain = NO;
        } else {
            [_moviePlayer destory];
        }
        
        NSLog(@"%@  becomeInvisible", _identifier);
    });
}

-(void)didScrollToTop:(NSNotification *)notification
{
    [self endTrack];
    
}

-(void)resetLastViewForNotAuto:(ZHShortPlayerView *)view
{
    if (shouldAutoPaly == NO) {
        lastView = view;
    }
}


-(void)resetIJKVieoPlayWithUrl:(NSString *)url
{

    @autoreleasepool {
        if (_moviePlayer == nil || _moviePlayer.superview == nil
            || ![_moviePlayer.playUrl.absoluteString isEqualToString:url] || _moviePlayer.isShutdown) {
            [_moviePlayer destory];
            _moviePlayer = [[TvMovieView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width-10, (ScreenSize.width-10)/16.0f*9)];
            [_moviePlayer playVideoWithRealUrl:url withTitle:@""];
            [_moviePlayer setViewInterfaceOrientation:UIInterfaceOrientationPortrait];
            _moviePlayer.repeat = YES;

        }
    }
}

-(ZHShortPlayerView *)getCurrentShouldPlayView
{
    ZHShortPlayerView *pview = nil;
    CGPoint lastPos = CGPointZero;
    for (ZHShortPlayerView *view in dataArrray) {
        if ([self isDisplayedInScreen:view]) {
            CGPoint pos = [view convertPoint:view.center toView:[UIApplication sharedApplication].keyWindow];
            if (CGPointEqualToPoint(lastPos, CGPointZero)) {
                lastPos = pos;
                pview = view;
            } else if (fabs(lastPos.y-CenterY > 0 ? lastPos.y-CenterY-pview.frame.size.height*.5 : CenterY-lastPos.y-pview.frame.size.height*.5)
                       > fabs(pos.y-CenterY > 0 ? pos.y-CenterY-view.frame.size.height*.5 : CenterY-pos.y-view.frame.size.height*.5)) {
                lastPos = pos;
                pview = view;
            }
        }
    }
    return pview;
}

// 判断View是否显示在屏幕上
-(BOOL)isDisplayedInScreen:(UIView *)view
{
    
    if (view.window == nil) {
        return NO;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect rect = [view convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return NO;
    }
    
    if (view.hidden) {
        return NO;
    }
    
    if (view.superview == nil) {
        return NO;
    }
    
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  NO;
    }
    
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }
    return YES;
}


- (void)registerObservers
{
    //监听应用器状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    

    //监听滚动到顶部
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didScrollToTop:)
                                                 name:ZHScrollToTopNotification
                                               object:nil];
    
    
    //监听滑动状态变化
    __weak typeof(self) weakSelf = self;
    observe = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopBeforeWaiting|kCFRunLoopExit, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        [weakSelf checkPlayState];
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observe, kCFRunLoopCommonModes);
    CFRelease(observe);
    
}

- (void)unregisterObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), observe, kCFRunLoopCommonModes);
}


- (void)applicationWillEnterForeground
{
    NSLog(@"ZHShortVideoManager:applicationWillEnterForeground: %d\n", (int)[UIApplication sharedApplication].applicationState);
}

- (void)applicationDidBecomeActive
{
    if ([self isDisplayedInScreen:_moviePlayer]) {
        [_moviePlayer resumePlay];
    }
    NSLog(@"ZHShortVideoManager:applicationDidBecomeActive: %d\n", (int)[UIApplication sharedApplication].applicationState);

}

- (void)applicationWillResignActive
{
    if ([self isDisplayedInScreen:_moviePlayer]) {
        [_moviePlayer pausePlay];
    }
    NSLog(@"ZHShortVideoManager:applicationWillResignActive: %d\n", (int)[UIApplication sharedApplication].applicationState);
}

- (void)applicationDidEnterBackground
{
    NSLog(@"ZHShortVideoManager:applicationDidEnterBackground: %d\n", (int)[UIApplication sharedApplication].applicationState);

}

-(void)addPlayerView:(ZHShortPlayerView *)view
{
    for (ZHShortPlayerView *item in dataArrray) {
        if ([view.videoUrl isEqualToString:item.videoUrl]) {
            [dataArrray removeObject:item];
            break;
        }
    }
    [dataArrray addObject:view];
}

-(void)removePlayerView:(ZHShortPlayerView *)view
{
    [dataArrray removeObject:view];
    
    if (dataArrray.count <= 0) {
        [[ZHShortVideoManagerDequeue sharecInstance] removeManagerWithIdentifier:view.identifier];
    }
}

-(void)removeAllPlayerView
{
    
    [dataArrray removeAllObjects];
}

- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

@end




@implementation ZHShortVideoManagerDequeue

static NSMapTable *resumeManagerData;

-(void)dealloc
{
    NSLog(@"release class:%@",NSStringFromClass([self class]));
}

+(ZHShortVideoManagerDequeue *)sharecInstance
{
    
    static ZHShortVideoManagerDequeue *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[ZHShortVideoManagerDequeue alloc] init];
        resumeManagerData =  [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
        
    });
    return sharedClient;
}

-(ZHShortVideoManager *)dequeueManagerWithIdentifier:(NSString *)identifier
{
    id tmpValue = [resumeManagerData objectForKey:identifier];
    
    if (tmpValue == nil || tmpValue == [NSNull null])
    {
        ZHShortVideoManager *manager = [[ZHShortVideoManager alloc] initWithIdentifier:identifier];
        [self addManager:manager];
        return manager;
    }
    return tmpValue;
}

-(void)addManager:(ZHShortVideoManager *)manaer
{
    id tmpValue = [resumeManagerData objectForKey:manaer.identifier];
    
    if (tmpValue == nil || tmpValue == [NSNull null])
    {
        [resumeManagerData setObject:manaer forKey:manaer.identifier];
    }
}

-(void)removeManagerWithIdentifier:(NSString *)identifier
{
    id tmpValue = [resumeManagerData objectForKey:identifier];
    
    if (tmpValue != nil && tmpValue != [NSNull null])
    {
        [resumeManagerData removeObjectForKey:identifier];
        [((ZHShortVideoManager *)tmpValue) removeAllPlayerView];
    }
}


@end
