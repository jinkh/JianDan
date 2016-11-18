//
//  PictureViewModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/11.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PictureViewModel : ViewBaseModel

-(instancetype)initWithUrl:(NSString *)urlStr;

-(NSURLSessionDataTask *)fetchPictureList:(ReturnBlock) returnBlock;

-(NSURLSessionDataTask *)fetchNextPictureList:(ReturnBlock) returnBlock;

-(void)pictureDetailWithData:(id)data withIndex:(NSInteger)index withType:(NSString *)typeUrl;

@property (assign, nonatomic) BOOL isRandom;
@property (assign, nonatomic) BOOL isFavType;


//special

+(NSArray*)fetchFavListWithPage:(NSInteger)page withSize:(NSInteger)size withType:(NSString *)type;

+(void)saveFavWithModel:(id)model withBlock:(void(^)(BOOL result))block withType:(NSString *)type;

+(void)deleteFavWithModel:(id)model withType:(NSString *)type;

+(BOOL)isFavWithModel:(id)model withType:(NSString *)type;

@end
