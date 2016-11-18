//
//  JokeViewModel.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/12.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "JokeViewModel.h"
#import "NSString+Size.h"
#import "JokeDetailController.h"

#define PageSize 25

@interface JokeViewModel ()
{
    NSInteger page;
    
    BOOL isNoMoreData;
    
}

@end

@implementation JokeViewModel

-(void)dealloc
{
    ReleaseClass;
}
-(instancetype)init
{
    if (self = [super init]) {
  
        page = 1;
        isNoMoreData = NO;
    }
    return self;
}

-(NSURLSessionDataTask *)fetchJokeList:(ReturnBlock) returnBlock
{
    @synchronized(self) {
        if (_isRandom) {
            page = [self randomPage];
        } else {
            page = 1;
        }
        isNoMoreData = NO;
        if (_isFavType) {
            NetReturnValue *value = [[NetReturnValue alloc] init];
            value.finishType = REQUEST_SUCESS;
            value.error = nil;
            value.data = [JokeViewModel fetchFavListWithPage:page withSize:PageSize];
            if (value.data == nil
                || ([value.data isKindOfClass:[NSArray class]] && ((NSArray *)value.data).count < PageSize)) {
                value.finishType = REQUEST_NO_MORE_DATA;
            }
            returnBlock(value);
            return nil;
        } else {
            NSString *urlStr = [NSString stringWithFormat:@"%@&page=%ld", JokeUrl, page];
            return [AFNetworkClient netRequestGetWithUrl:urlStr withParameter:nil withBlock:^(id data, FinishRequestType finishType, NSError *error) {
                [self deallWithReturnData:data withFinishType:finishType withError:error withBlock:returnBlock];
            }];
        }
    }
}

-(NSURLSessionDataTask *)fetchNextJokeList:(ReturnBlock) returnBlock
{
    //容错
    if (isNoMoreData) {
        if (returnBlock) {
            returnBlock(nil);
        }
        return nil;
    }
    
    @synchronized(self) {
        if (_isRandom) {
            page = [self randomPage];
        } else {
            page++;
        }
        if (_isFavType) {
            NetReturnValue *value = [[NetReturnValue alloc] init];
            value.finishType = REQUEST_SUCESS;
            value.error = nil;
            value.data = [JokeViewModel fetchFavListWithPage:page withSize:PageSize];
            if (value.data == nil
                || ([value.data isKindOfClass:[NSArray class]] && ((NSArray *)value.data).count < PageSize)) {
                value.finishType = REQUEST_NO_MORE_DATA;
            }
            returnBlock(value);
            return nil;
        } else {
            NSString *urlStr = [NSString stringWithFormat:@"%@&page=%ld", JokeUrl, page];
            return [AFNetworkClient netRequestGetWithUrl:urlStr withParameter:nil withBlock:^(id data, FinishRequestType finishType, NSError *error) {
                [self deallWithReturnData:data withFinishType:finishType withError:error withBlock:returnBlock];
            }];
        }
    }
}

-(NSInteger)randomPage
{
    //随机取b不常见到的20-300页
    NSInteger value = (arc4random() % 300) + 20;
    NSLog(@"randomPage = %ld", value);
    return value;
}


-(NSURLSessionDataTask *)deallWithReturnData:(id)data withFinishType:(FinishRequestType)finishType withError:(NSError *)error withBlock:(ReturnBlock) returnBlock
{
    @synchronized(self) {
        NetReturnValue *value = [[NetReturnValue alloc] init];
        value.finishType = finishType;
        value.error = error;
        
        if (finishType != REQUEST_FAILED) {
            NSArray *list = [data getArrayValueForKey:@"comments" defaultValue:nil];
            NSMutableArray *result = [JokeModel arrayOfModelsFromDictionaries:list error:nil];
            value.data = result;
            
            NSMutableString *param = [NSMutableString string];
            for (JokeModel *model in result) {
                [param appendFormat:@"comment-%@,", model.comment_ID];
            }
            [param replaceCharactersInRange:NSMakeRange(param.length-1, 1) withString:@""];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@", CommentCountUrl, param];
            return [AFNetworkClient netRequestGetWithUrl:urlStr withParameter:nil withBlock:^(id cData, FinishRequestType cFinishType, NSError *cError) {
                
                if (cFinishType == REQUEST_FAILED) {
                    if (returnBlock) {
                        returnBlock(value);
                    }
                    return;
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //获取评论数量
                    NSDictionary * cResponse = [cData objectForKey:@"response"];
                    
                    for (JokeModel *model in result) {
                        //获取评论数量
                        NSString * key = [NSString stringWithFormat:@"comment-%@",model.comment_ID];
                        NSDictionary * cResult = [cResponse objectForKey:key];
                        model.comment_count = [cResult getStringValueForKey:@"comments" defaultValue:@"0"];
                        
                        //获取网络图片尺寸
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        [paragraphStyle setLineSpacing:6];
                        NSMutableDictionary *attDic = [NSMutableDictionary dictionary];
                        [attDic setObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
                        [attDic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
                        
                        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.text_content];
                        [attributedString addAttributes:attDic range:NSMakeRange(0, model.text_content.length)];
                        model.attributedString = attributedString;
                        
                        
                        CGSize strSize = [attributedString.string boundingRectWithSize:CGSizeMake(ScreenSize.width-20, CGFLOAT_MAX)
                                                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                            attributes:attDic
                                                                               context:nil].size;
                        
                        
                        
                        NSInteger width = ScreenSize.width-20;
                        NSInteger height = strSize.height+12;
                        model.textWidth = [NSNumber numberWithInteger:width];
                        model.textHeight = [NSNumber numberWithInteger:height];
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (finishType == REQUEST_SUCESS) {
                            if (result.count < PageSize) {
                                if (returnBlock) {
                                    value.finishType = REQUEST_NO_MORE_DATA;
                                    value.error = nil;
                                    returnBlock(value);
                                    isNoMoreData = YES;
                                }
                            } else {
                                if (returnBlock) {
                                    value.finishType = REQUEST_SUCESS;
                                    value.error = nil;
                                    returnBlock(value);
                                }
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
            }];
        } else {
            if (returnBlock) {
                returnBlock(value);
            }
            return nil;
        }
    }
}

-(void)jokeDetailWithData:(id)data withIndex:(NSInteger)index
{
    JokeDetailController *detail = [[JokeDetailController alloc] initWithData:data withIndex:index];
    [TheAppDelegate.rootNavigationController pushViewController:detail animated:YES];
}



//MagicRecord

+(NSArray*)fetchFavListWithPage:(NSInteger)page withSize:(NSInteger)size
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"JokeModel_CoreData"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sortTime" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchLimit:size];
    [fetchRequest setFetchOffset:(page-1) * size];
    
    
    
    NSArray *result =[JokeModel_CoreData MR_executeFetchRequest:fetchRequest inContext:[NSManagedObjectContext MR_defaultContext]];
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < result.count; i++) {
        JokeModel_CoreData *item = [result objectAtIndex:i];
        JokeModel *model = [[JokeModel alloc] init];
        [self changeModel:model withModel:item];
        [returnValue addObject:model];
    }
    return returnValue;
}

+(void)saveFavWithModel:(id)model withBlock:(void(^)(BOOL result)) block
{
    JokeModel *data = model;

    NSArray *array = [JokeModel_CoreData MR_findByAttribute:@"comment_ID" withValue:data.comment_ID];
    if (array == nil ||  array.count <= 0) {
        id item = [JokeModel_CoreData MR_createEntity];
        [self changeModel:item withModel:data];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Joke_Fav_Data_Change_Notify object:model];
        });
    }
    
    if (block) {
        block(YES);
    }
}

+(void)deleteFavWithModel:(id)model
{
    JokeModel *data = model;
    NSArray *array = [JokeModel_CoreData MR_findByAttribute:@"comment_ID" withValue:data.comment_ID];
    if (array && array.count > 0) {
        JokeModel_CoreData *item = array.firstObject;
        [item MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Joke_Fav_Data_Change_Notify object:model];
        });
    }
}

+(BOOL)isFavWithModel:(id)model
{
    JokeModel *data = model;
    NSArray *array = [JokeModel_CoreData MR_findByAttribute:@"comment_ID" withValue:data.comment_ID];
    if (array && array.count > 0) {
        return YES;
    }
    return NO;
}

@end
