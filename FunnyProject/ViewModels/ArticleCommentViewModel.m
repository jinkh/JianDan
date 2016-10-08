//
//  ArticleCommentViewModel.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/14.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ArticleCommentViewModel.h"
#import "NSString+Size.h"
#import "NSString+Matcher.h"

@interface ArticleCommentViewModel ()
{
    NSString *myId;
    
     NSString *threadId;
}

@end

@implementation ArticleCommentViewModel

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

-(NSURLSessionDataTask *)fetchCommentList:(ReturnBlock) returnBlock
{
    @synchronized(self) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", FreshNewCommentlUrl, myId];
        return [AFNetworkClient netRequestGetWithUrl:urlStr withParameter:nil withBlock:^(id data, FinishRequestType finishType, NSError *error) {
            [self deallWithReturnData:data withFinishType:finishType withError:error withBlock:returnBlock];
        }];
    }
}

-(void)deallWithReturnData:(id)data withFinishType:(FinishRequestType)finishType withError:(NSError *)error withBlock:(ReturnBlock) returnBlock
{
    @synchronized(self) {
        
        NetReturnValue *value = [[NetReturnValue alloc] init];
        value.finishType = finishType;
        value.error = error;
        
        if (finishType != REQUEST_FAILED) {
            
            NSDictionary * parentPosts = [data getDicValueForKey:@"post" defaultValue:nil];
            
            threadId =[parentPosts getStringValueForKey:@"id" defaultValue:@""];
            
            NSArray *list = [parentPosts getArrayValueForKey:@"comments" defaultValue:nil];
            NSMutableArray *result = [ArticleCommentModel arrayOfModelsFromDictionaries:list error:nil];
            value.data = result;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                for (ArticleCommentModel *model in result) {
                    
                    [self getParentComment:result forComment:model];
                    
                    NSInteger width = ScreenSize.width-60;
                    NSInteger height = 0;
                    NSString *pStr = @"";
                    if (model.parentComment) {
                        pStr = [NSString stringWithFormat:@" | @%@：%@", model.parentComment.name, model.parentComment.content];
                    }
                    NSString * htmlString = @"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\" /><style type=\"text/css\">body{ font-size:14px; color: #4F4F4F;}</style></head><body><div\"><p>%@%@</p>\n</div></body></html>";
                    htmlString = [NSString stringWithFormat:htmlString, model.content, pStr];
                    
                    //避免混乱，评论只显示一张图
                    
                    NSScanner *theScanner = [NSScanner scannerWithString:htmlString];
                    NSString *text = nil;
                    NSInteger picCount = 0;
                    while ([theScanner isAtEnd] == NO) {
                        // find start of tag
                        [theScanner scanUpToString:@"<img" intoString:NULL] ;
                        // find end of tag
                        [theScanner scanUpToString:@">" intoString:&text] ;
                        if (text) {
                    
                            text = [NSString stringWithFormat:@"%@>", text];
                            if (picCount > 0) {
                                htmlString = [htmlString stringByReplacingOccurrencesOfString:text withString:@""];
                                return;
                            }
                            
                            NSString *toReplace = [NSString stringWithFormat:@"%@", text];
                            toReplace = [toReplace stringByReplacingOccurrencesOfString:@"<img" withString:@"<br/><img width=100 height=100"];
                            toReplace = [toReplace stringByAppendingString:@"<br/>"];
    
                            htmlString = [htmlString stringByReplacingOccurrencesOfString:text withString:toReplace];
                            text = nil;
                            picCount++;
                        }
  
                    }
                    NSInteger scale = (NSInteger)[UIScreen mainScreen].scale;
                    if (scale == 1) {
                        height = height+100*picCount;
                    } else {
                        height = height+85*picCount;
                    }
                    
                    
                    model.attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                    
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
                        [paragraphStyle setLineSpacing:2];
                    }
                    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                    NSMutableDictionary *attDic = [NSMutableDictionary dictionary];
                    [attDic setObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
                    [attDic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
                    
                    
                    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
                        [model.attributedString addAttribute:NSForegroundColorAttributeName value:COLORA(255, 255,255, .7)
                                                       range:NSMakeRange(0, model.attributedString.string.length)];
                    } else {
                        [model.attributedString addAttribute:NSForegroundColorAttributeName value:COLORA(0, 0, 0, .6)
                                                       range:NSMakeRange(0, model.attributedString.string.length)];
                    }
                    
                    NSRange range = [model.attributedString.string rangeOfString:@" | @"];
                    
                    if (range.location != NSNotFound) {
                        
                        if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
                            [model.attributedString addAttribute:NSForegroundColorAttributeName value:COLORA(255, 255,255, .5)
                                                           range:NSMakeRange(range.location+2, model.attributedString.string.length-range.location-2)];
                        } else {
                            [model.attributedString addAttribute:NSForegroundColorAttributeName value:COLORA(0, 0, 0, .4)
                                                           range:NSMakeRange(range.location+2, model.attributedString.string.length-range.location-2)];
                        }
                    }
                    
                    CGSize strSize = [model.attributedString.string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                                                 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                              attributes:attDic
                                                                                 context:nil].size;
                    if (strSize.height < 40) {
                        strSize.height = 40;
                    }
                    height = strSize.height+height;
                    model.msgWidth = [NSNumber numberWithInteger:width];
                    model.msgHeight = [NSNumber numberWithInteger:height-15];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finishType == REQUEST_SUCESS) {
                        if (returnBlock) {
                            value.finishType = REQUEST_SUCESS;
                            value.error = nil;
                            returnBlock(value);
                        }
                    } else {
                        if (returnBlock) {
                            value.finishType = REQUEST_FAILED;
                            value.error = error;
                            returnBlock(value);
                        }
                    }
                });
            });
        } else {
            if (returnBlock) {
                returnBlock(value);
            }
        }
        
    }
}

- (void)getParentComment:(NSMutableArray *)comments forComment:(ArticleCommentModel *)comment
{
    BOOL isHas7Num = [self isMatch:comment.content regex:@"((?=.*[0-9]).{7,1000})"];
    BOOL isHasCommentString = [comment.content rangeOfString:@"#comment-"].length > 0;
    BOOL isHandled = (comment.parentComment != nil);
    if ([comment.name isEqualToString:@"金子"]) {
        
    }
    
    BOOL hasParent = NO;
    if ((isHas7Num && isHasCommentString) && isHandled == NO) {
        //获得父评价的id
        NSInteger parentId = [self getParentIdFromContent:comment.content];
        for (ArticleCommentModel *item in comments) {
            if (parentId == [item.id integerValue]) {
                comment.parentComment = item;
                hasParent = YES;
                break;
            }
        }
    }
    if (hasParent) {
        comment.content = [self getContentWithParent:comment.content];
    }else{
        comment.content=[self getContentOnlySelf:comment.content];
    }
}

- (NSInteger)getParentIdFromContent:(NSString *)content {
    @try {
        NSString * text = @"comment-";
        NSInteger index = [content rangeOfString:text].location + text.length;
        NSInteger parentId = [[content substringWithRange:NSMakeRange(index, 7)] integerValue];
        return parentId;
    }
    @catch (NSException *exception) {
        return 0;
    }
    
}

- (NSString *)getContentWithParent:(NSString *)originContent {
    if ([originContent rangeOfString:@"</a>:"].length > 0) {
        NSArray * array = [[self getContentOnlySelf:originContent] componentsSeparatedByString:@"</a>:"];
        if (array.count > 1) {
            return array[1];
        }
        return originContent;
    }
    return originContent;
}


- (NSString *)getContentOnlySelf:(NSString *)originContent {
    originContent = [originContent stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    originContent = [originContent stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    NSString *regular = @"<a\\s+([^>h]|h(?!ref\\s))*(?<=[\\s+]?href[\\s+]?=[\\s+]?('|\")?)([^\"|'>]+?(?=\"|'))(.+?)?((?<=>)(.+?)?(?=</a>))";
    originContent = [originContent stringByReplacingOccurrencesOfString:regular withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, originContent.length)];
    return [originContent stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
}


-(BOOL)isMatch:(NSString *)strPlace regex:(NSString *)regex {
    //    NSString* regex = regex;//@"\\d{7}";
    NSPredicate *predicateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [predicateTest evaluateWithObject:strPlace];
}

//comment
-(NSURLSessionDataTask *)pushCommentWithContent:(NSString *)content withParentComment:(ArticleCommentModel *)pComment withBlock:(ReturnBlock) returnBlock
{
    NSString * author_name = [UserManager getUSerName];
    NSString * author_email = [UserManager getUSerEmail];

    if (pComment) {
        content = [NSString stringWithFormat:@"<a href=\"#comment-%@\">%@</a>: %@", pComment.id, pComment.name, content];
    }
    NSString * url = [NSMutableString stringWithFormat:@"%@&content=%@&email=%@&name=%@&post_id=%@", PushCommentlUrl, content, author_email, author_name, threadId];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return [AFNetworkClient netRequestGetWithUrl:url withParameter:nil withBlock:^(id data, FinishRequestType finishType, NSError *error) {
        if (returnBlock) {
            NetReturnValue *value = [[NetReturnValue alloc] init];
            value.finishType = finishType;
            value.error = error;
            returnBlock(value);
        }
    }];
}

@end
