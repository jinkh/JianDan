//
//  JokeViewModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/12.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ViewBaseModel.h"

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
