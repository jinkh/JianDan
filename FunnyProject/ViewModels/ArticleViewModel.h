//
//  ArticleViewModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/11.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ViewBaseModel.h"
#import "ArticleModel.h"

@interface ArticleViewModel : ViewBaseModel

-(NSURLSessionDataTask *)fetchNewArticleList:(ReturnBlock) returnBlock;

-(NSURLSessionDataTask *)fetchNextNewArticleList:(ReturnBlock) returnBlock;

-(void)articleDetailWithData:(id)data withIndex:(NSInteger)index;

@property (assign, nonatomic) BOOL isRandom;


//MagicRecord
+(BOOL)isFavWithModel:(id)model;

+(void)deleteFavWithModel:(id)model;

+(void)saveFavWithModel:(id)model withBlock:(void(^)(BOOL result)) block;

+(NSArray*)fetchFavListWithPage:(NSInteger)page withSize:(NSInteger)size;


+(BOOL)isReadWithModel:(id)model;

+(void)deleteReadWithModel:(id)model;

+(void)saveReadWithModel:(id)model withBlock:(void(^)(BOOL result)) block;

+(NSArray*)fetchReadListWithPage:(NSInteger)page withSize:(NSInteger)size;

+(BOOL)isReadWithModelInBackGround:(id)model;


@end