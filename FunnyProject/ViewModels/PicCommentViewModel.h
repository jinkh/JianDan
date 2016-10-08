//
//  PicCommentViewModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/14.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ViewBaseModel.h"

@interface PicCommentViewModel : ViewBaseModel

-(instancetype)initWithId:(NSString *)_id;

//抓取的接口不支持分页，so没有分页请求
-(NSURLSessionDataTask *)fetchCommentList:(ReturnBlock) returnBlock;

-(NSURLSessionDataTask *)pushCommentWithContent:(NSString *)content withParentId:(NSString *)pId withBlock:(ReturnBlock) returnBlock;

@end
