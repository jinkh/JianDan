//
//  ArticleViewModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/11.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ViewBaseModel.h"
#import "ArticleModel.h"

#define Article_Fav_Data_Change_Notify @"Article_Fav_Data_Change_Notify"

@interface ArticleViewModel : ViewBaseModel

-(NSURLSessionDataTask *)fetchNewArticleList:(ReturnBlock) returnBlock;

-(NSURLSessionDataTask *)fetchNextNewArticleList:(ReturnBlock) returnBlock;

-(void)articleDetailWithData:(id)data withIndex:(NSInteger)index;

@property (assign, nonatomic) BOOL isRandom;
@property (assign, nonatomic) BOOL isFavType;
@property (assign, nonatomic) NSInteger favOffset;

//MagicRecord
+(BOOL)isFavWithModel:(id)model;

+(void)deleteFavWithModel:(id)model;

+(BOOL)saveFavWithModel:(id)model;

+(NSArray*)fetchFavListWithOffset:(NSInteger)offset withSize:(NSInteger)size;


+(BOOL)isReadWithModel:(id)model;

+(void)deleteReadWithModel:(id)model;

+(void)saveReadWithModel:(id)model withBlock:(void(^)(BOOL result)) block;

+(NSArray*)fetchReadListWithPage:(NSInteger)page withSize:(NSInteger)size;

+(BOOL)isReadWithModelInBackGround:(id)model;


@end
