//
//  AppDelegate.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/7.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftController.h"
#import "TvMovieFullController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialData.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "AppStoreManager.h"
#import "VideoPagerController.h"

static NSString * const kStoreName = @"Funny.sqlite";

@interface AppDelegate () <UIGestureRecognizerDelegate>


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //夜间模式初始化
    [DKColorTable sharedColorTable].file = @"ThemeColor.txt";
    self.dk_manager.changeStatusBar = NO;
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        [self.dk_manager nightFalling];
    } else {
        [self.dk_manager dawnComing];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    if ([AppStoreManager isInReview] ) {
        VideoPagerController *video = [[VideoPagerController alloc] init];
        
        UINavigationController *centerController = [[UINavigationController alloc] initWithRootViewController:video];
        self.deckController =  [[IIViewDeckController alloc] initWithCenterViewController:centerController
                                                                       leftViewController:nil];
        [self.deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
        self.deckController.leftSize = MIN(ScreenSize.width, ScreenSize.height)*.7;
        self.deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
        self.deckController.panningGestureDelegate = self;
        self.deckController.panningCancelsTouchesInView = YES;
        self.rootNavigationController = [[UINavigationController alloc] initWithRootViewController:self.deckController];
        
        self.window.rootViewController = self.rootNavigationController;
        [self.window makeKeyAndVisible];

    } else {
        
        
        LeftController *leftController = [[LeftController alloc] init];
        UINavigationController *centerController = [[UINavigationController alloc] initWithRootViewController:leftController.selectController];
        self.deckController =  [[IIViewDeckController alloc] initWithCenterViewController:centerController
                                                                       leftViewController:[IISideController autoConstrainedSideControllerWithViewController:leftController]];
        [self.deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
        self.deckController.leftSize = MIN(ScreenSize.width, ScreenSize.height)*.7;
        self.deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
        self.deckController.panningGestureDelegate = self;
        self.deckController.panningCancelsTouchesInView = YES;
        self.rootNavigationController = [[UINavigationController alloc] initWithRootViewController:self.deckController];
        
        self.window.rootViewController = self.rootNavigationController;
        [self.window makeKeyAndVisible];
    }

    
    //解决瀑布流内存峰值崩溃
    [[SDImageCache sharedImageCache] setShouldCacheImagesInMemory:NO];
    [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    [SettingManager getCachUsefulDateType];
    
    //IQKeyboardManager
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    //MagicRecord
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:kStoreName];
    
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:[kStoreName stringByDeletingPathExtension] ofType:[kStoreName pathExtension]];
        if (defaultStorePath) {
            NSError *error;
            BOOL success = [fileManager copyItemAtPath:defaultStorePath toPath:[storeURL path] error:&error];
            if (!success) {
                NSLog(@"Failed to install default recipe store");
            }
        }
    }
    
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
    [MagicalRecord setupCoreDataStackWithStoreNamed:kStoreName];
    
    //友盟
    //设置友盟社会化组件appkey

    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionTop|UMSocialiToastPositionBottom|UMSocialiToastPositionCenter];
    [UMSocialData openLog:NO];
    [UMSocialData setAppKey:@"57983dcf67e58e50c5003753"];
    [UMSocialWechatHandler setWXAppId:@"wx26be9814d558777f" appSecret:@"97ced3f54d3a90d6d76fb558d940b4bf" url:@"http://jandan.net"];
    [UMSocialQQHandler setQQWithAppId:@"1105572270" appKey:@"YCE8UPYDOBvuLs1S" url:@"http://jandan.net"];
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"1782488373"
                                              secret:@"9f0fe5798bdc0ce12cc864551df6f04c"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];


    return YES;
}

//图片保存到相册
//- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
//{
//    NSString *message = @"保存到相册失败";
//    if (!error) {
//        message = @"保存到相册成功";
//    }
//    [[ToastHelper sharedToastHelper] toast:message];
//}

-(void)reportWithArticleId:(NSString *)_id
{
    NSMutableString *mailUrl = [[NSMutableString alloc]init];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"kehanking@qq.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    //添加抄送
    NSArray *ccRecipients = [NSArray array];
    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
    //添加密送
    NSArray *bccRecipients = [NSArray array];
    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    
    //添加主题
    [mailUrl appendString:[NSString stringWithFormat:@"&subject=举报此篇帖子，帖子ID为%@", _id]];

    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //解决IIViewDeckController和scrollView的冲突
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]] && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        UIScrollView *scrollView = (UIScrollView *)otherGestureRecognizer.view;
        if ( scrollView.contentOffset.x <= 0 && scrollView.contentSize.width > scrollView.frame.size.width) {
            CGPoint trans = [((UIPanGestureRecognizer *)gestureRecognizer) translationInView:gestureRecognizer.view];
            NSLog(@"trans = %@", NSStringFromCGPoint(trans));
            if (trans.x > 0 &&fabs(trans.x)>fabs(trans.y)) {
                [otherGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
                return YES;
            }
        }
    }
    return NO;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}

@end
