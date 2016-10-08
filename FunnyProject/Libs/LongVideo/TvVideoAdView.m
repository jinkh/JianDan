//
//  TvVideoAdView.m
//  DemoApp
//
//  Created by Zinkham on 15/11/12.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#import "TvVideoAdView.h"
#import "TvOrentionManager.h"

@interface TvVideoAdView () <UIAlertViewDelegate>
{

    UIActivityIndicatorView *loadingIndicator;
    
    UIButton *backBtn;
    
    UIInterfaceOrientation  interfaceorention;
    
    UIButton *fullBtn;
}

@end

@implementation TvVideoAdView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        interfaceorention = UIInterfaceOrientationPortrait;
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loadingIndicator.center = self.center;
        [loadingIndicator startAnimating];
        [self addSubview:loadingIndicator];
        
        backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        backBtn.backgroundColor = [UIColor clearColor];
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"back_s"] forState:UIControlStateHighlighted];
        backBtn.titleLabel.font = DefaultFont(16);
        [backBtn addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        
        fullBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-45, self.frame.size.height-45, 45, 45)];
        fullBtn.backgroundColor = [UIColor clearColor];
        [fullBtn setImage:[UIImage imageNamed:@"full_mode"] forState:UIControlStateNormal];
        fullBtn.titleLabel.font = DefaultFont(16);
        [fullBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fullBtn];
    }
    return self;
}

-(void)goBackAction:(id)sender
{
    
    //自定义
//    if (interfaceorention == UIInterfaceOrientationPortrait) {
//        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
//        if ([root isKindOfClass:[UINavigationController class]]) {
//            [(UINavigationController*)root popViewControllerAnimated:YES];
//        } else {
//            [root.navigationController popViewControllerAnimated:YES];
//        }
//    } else {
//        [[TvOrentionManager sharedInstance] setOrentionPortrait];
//    }
    
}

-(void)fullScreenAction:(id)sender
{
    //自定义
   //[[TvOrentionManager sharedInstance] setOrentionLandscapeRight];
}

-(void)setAdViewlInterfaceOrientation:(UIInterfaceOrientation)orention
{
    if (self.isHidden) {
        return;
    }
    interfaceorention = orention;
    self.frame = self.superview.bounds;
    loadingIndicator.center = self.center;
    backBtn.frame = CGRectMake(0, 0, 45, 45);
    fullBtn.frame = CGRectMake(self.frame.size.width-45, self.frame.size.height-45, 45, 45);
    backBtn.frame = CGRectMake(0, 0, 45, 45);
    if (orention == UIInterfaceOrientationPortrait) {
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        fullBtn.hidden = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    } else {
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        fullBtn.hidden = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

@end
