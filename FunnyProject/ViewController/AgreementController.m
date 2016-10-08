//
//  AgreementController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/29.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "AgreementController.h"

@interface AgreementController ()
{
    UIWebView *myWebView;
}

@end

@implementation AgreementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = Controller_Bg;
    self.zh_showCustomNav = YES;
    self.zh_title = @"用户协议";
    
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenSize.width, ScreenSize.height-64)];
    myWebView.backgroundColor = [UIColor clearColor];
    myWebView.scrollView.backgroundColor = [UIColor clearColor];
    myWebView.alpha = .7;
    [self.view addSubview:myWebView];
    
    NSString *path = @"";
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        path = [[NSBundle mainBundle] pathForResource:@"user_agreement_night" ofType:@"html"];
    } else {
        path = [[NSBundle mainBundle] pathForResource:@"user_agreement" ofType:@"html"];
    }

    NSString *htmlStr = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [myWebView loadHTMLString:htmlStr baseURL:nil];
}


@end
