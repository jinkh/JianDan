//
//  VideoViewModel.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/12.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "VideoViewModel.h"

#define PageSize 20

@interface VideoViewModel ()
{
    NSInteger page;
    
    BOOL isNoMoreData;
    
}

@end

@implementation VideoViewModel

-(void)dealloc
{
    
}

-(instancetype)init
{
    if (self = [super init]) {
        
        page = 1;
        isNoMoreData = NO;
    }
    return self;
}

-(NSURLSessionDataTask *)fetchVideoList:(ReturnBlock) returnBlock
{
    @synchronized(self) {
        if (_isRandom) {
            page = [self randomPage];
        } else {
            page = 1;
        }
        isNoMoreData = NO;
        if (_isFavType) {
            _favOffset = 0;
            NetReturnValue *value = [[NetReturnValue alloc] init];
            value.finishType = REQUEST_SUCESS;
            value.error = nil;
            value.data = [VideoViewModel fetchFavListWithOffset:_favOffset withSize:PageSize];
            if (value.data == nil
                || ([value.data isKindOfClass:[NSArray class]] && ((NSArray *)value.data).count < PageSize)) {
                value.finishType = REQUEST_NO_MORE_DATA;
            }
            _favOffset += ((NSArray *)value.data).count;
            returnBlock(value);
            return nil;
        } else {
            //百思不得姐
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *timeString = [dateFormatter stringFromDate:[NSDate date]];
            
            NSString *urlStr = @"http://route.showapi.com/255-1";
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        @"22249", @"showapi_appid",
                                        @"41",@"type",
                                        timeString,@"showapi_timestamp",
                                        [NSNumber numberWithInteger:page],@"page",nil];
            
            NSString *signString=[CATCommon signWithParmString:dic];
            [dic setObject:signString forKey:@"showapi_sign"];
            [dic setObject:@"" forKey:@"title"];
            
            return [AFNetworkClient netRequestGetWithUrl:urlStr withParameter:dic withBlock:^(id data, FinishRequestType finishType, NSError *error) {
                [self deallWithReturnData:data withFinishType:finishType withError:error withBlock:returnBlock];
            }];
        }
    }
}

-(NSURLSessionDataTask *)fetchNextVideoList:(ReturnBlock) returnBlock
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
            value.data = [VideoViewModel fetchFavListWithOffset:_favOffset withSize:PageSize];
            if (value.data == nil
                || ([value.data isKindOfClass:[NSArray class]] && ((NSArray *)value.data).count < PageSize)) {
                value.finishType = REQUEST_NO_MORE_DATA;
            }
            _favOffset += ((NSArray *)value.data).count;
            returnBlock(value);
            return nil;
        } else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *timeString = [dateFormatter stringFromDate:[NSDate date]];
            
            NSString *urlStr = @"http://route.showapi.com/255-1";
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        @"22249", @"showapi_appid",
                                        @"41",@"type",
                                        timeString,@"showapi_timestamp",
                                        [NSNumber numberWithInteger:page],@"page",nil];
            
            NSString *signString=[CATCommon signWithParmString:dic];
            [dic setObject:signString forKey:@"showapi_sign"];
            [dic setObject:@"" forKey:@"title"];
            
            return [AFNetworkClient netRequestGetWithUrl:urlStr withParameter:dic withBlock:^(id data, FinishRequestType finishType, NSError *error) {
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

-(void)deallWithReturnData:(id)data withFinishType:(FinishRequestType)finishType withError:(NSError *)error withBlock:(ReturnBlock) returnBlock
{
    @synchronized(self) {
        NetReturnValue *value = [[NetReturnValue alloc] init];
        value.finishType = finishType;
        value.error = error;
        
        if (finishType != REQUEST_FAILED) {
            NSDictionary *body = [data getDicValueForKey:@"showapi_res_body" defaultValue:nil];
            NSDictionary *pagebean = [body getDicValueForKey:@"pagebean" defaultValue:nil];
            NSArray *list = [pagebean getArrayValueForKey:@"contentlist" defaultValue:nil];
            NSMutableArray *result = [VideoModel arrayOfModelsFromDictionaries:list error:nil];
            value.data = result;
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
                returnBlock(value);
            }
        }
    }
}


//MagicRecord

+(NSArray*)fetchFavListWithOffset:(NSInteger)offset withSize:(NSInteger)size
{
    @synchronized ([VideoViewModel class]) {
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"VideoModel_CoreData"];
        
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sortTime" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
        
        [fetchRequest   setFetchLimit:size];
        [fetchRequest   setFetchOffset:offset];
        
        NSArray *result =[VideoModel_CoreData MR_executeFetchRequest:fetchRequest inContext:[NSManagedObjectContext MR_defaultContext]];
        NSMutableArray *returnValue = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < result.count; i++) {
            VideoModel_CoreData *item = [result objectAtIndex:i];
            VideoModel *model = [[VideoModel alloc] init];
            [self changeModel:model withModel:item];
            [returnValue addObject:model];
        }
        return returnValue;
    }
}

+(BOOL)saveFavWithModel:(id)model;
{
    @synchronized ([VideoViewModel class]) {
        VideoModel *data = model;
        
        NSArray *array = [VideoModel_CoreData MR_findByAttribute:@"id" withValue:data.id];
        if (array == nil ||  array.count <= 0) {
            id item = [VideoModel_CoreData MR_createEntity];
            [self changeModel:item withModel:data];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:Video_Fav_Data_Change_Notify object:model];
            });
        }
        return YES;
    }
}

+(void)deleteFavWithModel:(id)model
{
    @synchronized ([VideoViewModel class]) {
        VideoModel *data = model;
        NSArray *array = [VideoModel_CoreData MR_findByAttribute:@"id" withValue:data.id];
        if (array && array.count > 0) {
            VideoModel_CoreData *item = array.firstObject;
            [item MR_deleteEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:Video_Fav_Data_Change_Notify object:model];
            });
        }
    }
}

+(BOOL)isFavWithModel:(id)model
{
    @synchronized ([VideoViewModel class]) {
        VideoModel *data = model;
        NSArray *array = [VideoModel_CoreData MR_findByAttribute:@"id" withValue:data.id];
        if (array && array.count > 0) {
            return YES;
        }
        return NO;
    }
}


@end
