//
//  VideoViewModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/12.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ViewBaseModel.h"

@interface VideoViewModel : ViewBaseModel


@property (assign, nonatomic) BOOL isRandom;

@property (assign, nonatomic) BOOL isFavType;

-(NSURLSessionDataTask *)fetchVideoList:(ReturnBlock) returnBlock;

-(NSURLSessionDataTask *)fetchNextVideoList:(ReturnBlock) returnBlock;


//MagicRecord
+(BOOL)isFavWithModel:(id)model;

+(void)deleteFavWithModel:(id)model;

+(void)saveFavWithModel:(id)model withBlock:(void(^)(BOOL result)) block;

+(NSArray*)fetchFavListWithPage:(NSInteger)page withSize:(NSInteger)size;

@end
