//
//  JokeViewModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/12.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ViewBaseModel.h"

#define Joke_Fav_Data_Change_Notify @"Joke_Fav_Data_Change_Notify"

@interface JokeViewModel : ViewBaseModel

-(NSURLSessionDataTask *)fetchJokeList:(ReturnBlock) returnBlock;

-(NSURLSessionDataTask *)fetchNextJokeList:(ReturnBlock) returnBlock;

-(void)jokeDetailWithData:(id)data withIndex:(NSInteger)index;

@property (assign, nonatomic) BOOL isRandom;
@property (assign, nonatomic) BOOL isFavType;

//MagicRecord
+(BOOL)isFavWithModel:(id)model;

+(void)deleteFavWithModel:(id)model;

+(void)saveFavWithModel:(id)model withBlock:(void(^)(BOOL result)) block;

+(NSArray*)fetchFavListWithPage:(NSInteger)page withSize:(NSInteger)size;

@end
