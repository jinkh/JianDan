//
//  ArticleDetailViewModel.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/13.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ArticleDetailViewModel.h"

@interface ArticleDetailViewModel ()
{
    NSString *myId;
    
}

@end

@implementation ArticleDetailViewModel

-(void)dealloc
{
    ReleaseClass;
}

-(instancetype)initWithId:(NSString *)_id
{
    if (self = [super init]) {
        myId = [[NSString alloc] initWithString:_id];
    }
    return self;
}

-(NSURLSessionDataTask *)fetchArticleDetail:(ReturnBlock) returnBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", FreshNewDetailUrl, myId];
    return [AFNetworkClient netRequestGetWithUrl:urlStr withParameter:nil withBlock:^(id data, FinishRequestType finishType, NSError *error) {
        
        NetReturnValue *value = [[NetReturnValue alloc] init];
        value.finishType = finishType;
        value.error = error;
        
        if (finishType != REQUEST_FAILED) {
            NSDictionary *dic = [data getDicValueForKey:@"post" defaultValue:nil];
            ArticleDetailModel *result = [[ArticleDetailModel alloc] initWithDictionary:dic error:nil];
            result.htmlStr = [self getHtml:result];
            value.data = result;
        }
        
        if (returnBlock) {
            returnBlock(value);
        }
    }];
}

- (NSString *)getHtml:(ArticleDetailModel *)model {
    //图片适应屏幕宽度
    model.content = [model.content stringByReplacingOccurrencesOfString:@"<img" withString:@"<img width=100%"];
    //去掉底部分享部分
    NSRange range = [model.content rangeOfString:@"<div class=\"share-links\"" options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        model.content = [model.content stringByReplacingCharactersInRange:NSMakeRange(range.location, model.content.length-range.location)
                                                           withString:@""];
    }

    
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<!DOCTYPE html>"];
    [html appendString:@"<html dir=\"ltr\" lang=\"zh\">"];
    [html appendString:@"<head>"];
    [html appendString:@"<meta name=\"viewport\" content=\"width=100%; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\" />"];
    //夜间模式
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
         [html appendString:@"<link  href=\"style_night.css\" type=\"text/css\"  rel=\"stylesheet\" media=\"screen\" />"];
    } else{
        [html appendString:@"<link  href=\"style.css\" type=\"text/css\"  rel=\"stylesheet\" media=\"screen\" />"];
    }
    [html appendString:@"</head>"];
    [html appendString:@"<body style=\"padding:0px 8px 8px 8px;\">"];
    [html appendString:@"<div id=\"pagewrapper\">"];
    [html appendString:@"<div id=\"mainwrapper\" class=\"clearfix\">"];
    [html appendString:@"<div id=\"maincontent\">"];
    [html appendString:@"<div class=\"post\">"];
    [html appendString:@"<div class=\"posthit\">"];
    [html appendString:@"<div class=\"postinfo\">"];
    [html appendString:@"<h2 class=\"thetitle\">"];
    [html appendString:@"<a>"];
    [html appendString:@"|----标题----|"];
    [html appendString:@"</a>"];
    [html appendString:@"</h2>"];
    [html appendFormat:@"|----日期----|"];
    [html appendString:@"</div>"];
    [html appendString:@"<div class=\"entry\">"];
    [html appendString:model.content];
    [html appendString:@"</div>"];
    [html appendString:@"</div>"];
    [html appendString:@"</div>"];
    [html appendString:@"</div>"];
    [html appendString:@"</div>"];
    [html appendString:@"</div>"];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    
    NSString *htmStr = html;
    return htmStr;
}
@end
