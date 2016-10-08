//
//  ArticleDetailViewModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/13.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ViewBaseModel.h"

@interface ArticleDetailViewModel : ViewBaseModel

-(instancetype)initWithId:(NSString *)_id;

-(NSURLSessionDataTask *)fetchArticleDetail:(ReturnBlock) returnBlock;

@end
