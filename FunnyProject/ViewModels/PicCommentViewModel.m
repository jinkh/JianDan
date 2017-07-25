//
//  PicCommentViewModel.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/14.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "PicCommentViewModel.h"
#import "NSString+Size.h"
#import "UserManager.h"

@interface PicCommentViewModel ()
{
    NSString *myId;
    NSString *threadId;
}

@end

@implementation PicCommentViewModel

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
        NSString *urlStr = [NSString stringWithFormat:@"%@comment-%@", DuoShuoCommentListlUrl, myId];
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
        
        //暂时取消评论功能
        if (returnBlock) {
            value.finishType = REQUEST_FAILED;
            value.error = error;
            returnBlock(value);
        }
        return;
        
        NSDictionary *threadDic = [data getDicValueForKey:@"thread" defaultValue:nil];
        
        threadId =[threadDic getStringValueForKey:@"thread_id" defaultValue:@""];
   
        if (finishType != REQUEST_FAILED) {
            NSMutableArray *result = [[NSMutableArray alloc] init];
            NSDictionary * parentPosts = [data getDicValueForKey:@"parentPosts" defaultValue:nil];
           
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                //整理评论，得到父评论
                for (NSString *key in parentPosts.allKeys) {
                    NSDictionary *dic = [parentPosts getDicValueForKey:key defaultValue:nil];
                    PicCommentModel *model = [[PicCommentModel alloc] initWithDictionary:dic error:nil];
                    [result addObject:model];

                }
                value.data = result;
                
                
                
                for (PicCommentModel *model in result) {
                    
                    [self getParentComment:result forComment:model];

                    NSInteger width = ScreenSize.width-60;
                    NSInteger height = 0;
                    NSString *pStr = @"";
                    if (model.parentComment) {
                        pStr = [NSString stringWithFormat:@" | @%@：%@", model.parentComment.author_name, model.parentComment.message];
                    }
                    NSString * htmlString = @"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\" /><style type=\"text/css\">body{ font-size:14px; color: #4F4F4F;}</style></head><body><div\"><p>%@%@</p>\n</div></body></html>";
                    htmlString = [NSString stringWithFormat:htmlString, model.message, pStr];
                                    
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
                    
                    model.attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                    
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
                        [paragraphStyle setLineSpacing:2];
                    }
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

- (void)getParentComment:(NSMutableArray *)comments forComment:(PicCommentModel *)comment
{
    if ([comment.message isEqualToString:@"有想法哈哈"]) {
        
    }
    NSString *parentId = comment.parents.firstObject;
    for (PicCommentModel *item in comments) {
        if (comment != item && parentId && [parentId isEqualToString:item.post_id]) {
            comment.parentComment = item;
            break;
        }
    }
}

//comment
-(NSURLSessionDataTask *)pushCommentWithContent:(NSString *)content withParentId:(NSString *)pId withBlock:(ReturnBlock) returnBlock
{
    NSString * author_name = [UserManager getUSerName];
    NSString * author_email = [UserManager getUSerEmail];
    NSMutableDictionary *params = [@{@"thread_id" : threadId,
                            @"author_name" : author_name,
                            @"author_email" : author_email,
                            @"message" : content,
                            } mutableCopy];
    if (pId && pId.length > 0) {
        params[@"parent_id"] = pId;
    }
    return [AFNetworkClient netRequestPostWithUrl:DuoShuoPushCommentUrl withParameter:params withBlock:^(id data, FinishRequestType finishType, NSError *error) {
        if (returnBlock) {
            NetReturnValue *value = [[NetReturnValue alloc] init];
            value.finishType = finishType;
            value.error = error;
            returnBlock(value);
        }
    }];
}

@end
