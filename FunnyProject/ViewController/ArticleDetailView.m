//
//  ArticleDetailView.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/15.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ArticleDetailView.h"

#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "CommentCell.h"
#import "MWPhotoBrowser.h"
#import "SVWebViewController.h"

@interface ArticleDetailView ()<UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    
    ArticleModel *myData;
    
    UIWebView * myWebView;
    
    //假的进度
    UIProgressView *progressView;
    
    ArticleDetailViewModel *viewModel;
    
    NSMutableArray *commentArray;
    UITableView *myTableView;
    UIActivityIndicatorView *indicatorView;
    ArticleCommentViewModel *commentViewModel;
    
    BOOL isFinishLoading;

}

@end

@implementation ArticleDetailView

-(void)dealloc
{
    ReleaseClass;
    myWebView.delegate = nil;
    [myWebView stopLoading];
    myWebView = nil;

}

-(instancetype)initWithFrame:(CGRect)frame withData:(id)data
{
    if (self = [super initWithFrame:frame]) {
        
        myData = data;
        
        isFinishLoading = NO;
        
        myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenSize.width, ScreenSize.height-64)];
        myWebView.backgroundColor = [UIColor whiteColor];
        myWebView.scrollView.scrollEnabled = NO;
        myWebView.delegate = self;
        myWebView.scrollView.backgroundColor = [UIColor whiteColor];
        
        progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, -1, ScreenSize.width, 2)];
        progressView.backgroundColor = [UIColor clearColor];
        progressView.progressTintColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0];
        progressView.trackTintColor= [UIColor clearColor];
        progressView.progress = 0;
        progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:progressView];
        
        
        [self bringSubviewToFront:progressView];
        float progress = progressView.progress;
        progress = progress+.15;
        [progressView setProgress:progress animated:YES];
        
        
        viewModel = [[ArticleDetailViewModel alloc] initWithId:myData.id];
        
         __weak ArticleDetailView * weakSelf = self;
        [viewModel fetchArticleDetail:^(NetReturnValue *returnValue) {
            [weakSelf deallDetailWithValue:returnValue];
        }];
        
        myTableView = [[UITableView alloc] initWithFrame:self.bounds];
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.scrollsToTop = NO;
        myTableView.showsVerticalScrollIndicator = YES;
        myTableView.hidden = YES;
        myTableView.backgroundColor = [UIColor clearColor];
        
        if (@available(iOS 11.0, *)) {
            myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            myTableView.estimatedRowHeight = 0;
            myTableView.estimatedSectionHeaderHeight = 0;
            myTableView.estimatedSectionFooterHeight = 0;
        }
        [self addSubview:myTableView];
        
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 50)];
        footerView.backgroundColor  = [UIColor clearColor];
        
        myTableView.tableFooterView = footerView;
        
        commentArray = [[NSMutableArray alloc] init];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.frame = CGRectMake(0, 0, ScreenSize.width, 30);
        indicatorView.hidesWhenStopped = YES;
        [indicatorView startAnimating];
        [myTableView addSubview:indicatorView];
        
        commentViewModel = [[ArticleCommentViewModel alloc] initWithId:myData.id];
        [commentViewModel fetchCommentList:^(NetReturnValue *returnValue) {
            [weakSelf dealCommentWithValue:returnValue];
        }];
    }
    return self;
}

-(void)dealCommentWithValue:(NetReturnValue *)returnValue
{
    if (returnValue.finishType != REQUEST_FAILED) {
        commentArray = [NSMutableArray arrayWithArray:returnValue.data];
        [myTableView reloadData];
    }
    [indicatorView stopAnimating];
}


-(void)deallDetailWithValue:(NetReturnValue *)returnValue
{
    if (returnValue.finishType != REQUEST_FAILED) {
        ArticleDetailModel *model = returnValue.data;
        NSString *buildStr = [model.htmlStr stringByReplacingOccurrencesOfString:@"|----标题----|" withString:myData.title];
        
        NSString *dateStr = [NSString stringWithFormat:@"%@ @ %@", myData.author_name, myData.date];
        buildStr = [buildStr stringByReplacingOccurrencesOfString:@"|----日期----|" withString:dateStr];
        [myWebView loadHTMLString:buildStr baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    
    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.clientHeight"] floatValue];
    
    CGFloat documentWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.clientWidth"] floatValue];
    
    CGFloat height = documentHeight*webView.frame.size.width/documentWidth;
    
    webView.hidden = NO;
    webView.frame = CGRectMake(0, 0, webView.frame.size.width, height);
    
    //js方法遍历图片添加点击事件 返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return objs.length;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    
    //注入自定义的js方法后别忘了调用 否则不会生效（不调用也一样生效了，，，不明白）
    [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];

    [self resetContentView];
    
    isFinishLoading = YES;
}

-(void)resetContentView
{
    [progressView setProgress:1.0 animated:YES];
    progressView.hidden = YES;
    
    myTableView.tableHeaderView = myWebView;
    myTableView.hidden = NO;
    
    indicatorView.frame = CGRectMake(0, myWebView.bounds.size.height, ScreenSize.width, 30);
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (isFinishLoading == NO) {
        return YES;
    }
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    //    NSLog(@"requestString is %@",requestString);
    
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        
        NSMutableArray *arry = [[NSMutableArray alloc] init];
        MWPhoto *photo = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:imageUrl]];
        [arry addObject:photo];
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:arry];
        browser.displayActionButton = YES;
        browser.displayNavArrows = YES;
        browser.displaySelectionButtons = NO;
        browser.alwaysShowControls = NO;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = NO;
        browser.startOnGrid = NO;
        [browser setCurrentPhotoIndex:0];
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [TheAppDelegate.rootNavigationController presentViewController:nc animated:YES completion:nil];
        return NO;
    } else {
        if ([requestString hasPrefix:@"http"] || [requestString hasPrefix:@"https"]) {
            NSURL *URL = [NSURL URLWithString:requestString];
            SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
            webViewController.zh_showCustomNav = YES;
            webViewController.zh_title = @"网页浏览器";
            [TheAppDelegate.rootNavigationController pushViewController:webViewController animated:YES];
            return NO;
        }
    }
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row < commentArray.count) {
        [cell fillData:[commentArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommentCell heightForCellWithData:[commentArray objectAtIndex:indexPath.row]];
}

-(void)pushCommentWithText:(NSString *)content withParentComment:(ArticleCommentModel *)pComment
{
    [commentViewModel pushCommentWithContent:content  withParentComment:pComment withBlock:^(NetReturnValue *returnValue) {
        if (returnValue.finishType == REQUEST_SUCESS) {
            [[ToastHelper sharedToastHelper] toast:@"评论成功，有延迟请稍后查看"];
        } else {
            [[ToastHelper sharedToastHelper] toast:@"评论失败"];
        }
    }];
}

@end
