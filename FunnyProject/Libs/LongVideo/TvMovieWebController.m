//
//  TvMovieWebController.m
//  DemoApp
//
//  Created by Zinkham on 15/11/4.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#import "TvMovieWebController.h"

@interface TvMovieWebController ()

@end

@implementation TvMovieWebController

-(void)viewDidLoad
{
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    
    [webView loadRequest:request];
    [self.view addSubview:webView];
}
@end

