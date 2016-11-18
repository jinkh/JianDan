//
//  VideoViewModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/12.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ViewBaseModel.h"

#define Video_Fav_Data_Change_Notify @"Video_Fav_Data_Change_Notify"

@interface VideoViewModel : ViewBaseModel

@property (assign, nonatomic) BOOL isRandom;

@property (assign, nonatomic) BOOL isFavType;

@property (assign, nonatomic) NSInteger favOffset;

-(NSURLSessionDataTask *)fetchVideoList:(ReturnBlock) returnBlock;

-(NSURLSessionDataTask *)fetchNextVideoList:(ReturnBlock) returnBlock;


//MagicRecord
+(BOOL)isFavWithModel:(id)model;

+(void)deleteFavWithModel:(id)model;

+(void)saveFavWithModel:(id)model withBlock:(void(^)(BOOL result)) block;

+(NSArray*)fetchFavListWithOffset:(NSInteger)offset withSize:(NSInteger)size;

@end
