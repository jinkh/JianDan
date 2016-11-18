//
//  ArticleViewModel.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/11.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ArticleViewModel.h"
#import "ArticleDetailController.h"
#define PageSize 24

@interface ArticleViewModel ()
{
    NSInteger page;
    
    BOOL isNoMoreData;
}

@end

@implementation ArticleViewModel

-(instancetype)init
{
    if (self = [super init]) {
        page = 1;
        isNoMoreData = NO;
    }
    return self;
}

-(NSURLSessionDataTask *)fetchNewArticleList:(ReturnBlock) returnBlock
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
            value.data = [ArticleViewModel fetchFavListWithOffset:_favOffset withSize:PageSize];
            if (value.data == nil
                || ([value.data isKindOfClass:[NSArray class]] && ((NSArray *)value.data).count < PageSize)) {
                value.finishType = REQUEST_NO_MORE_DATA;
            }
            _favOffset += ((NSArray *)value.data).count;
            returnBlock(value);
            return nil;
        } else {
            NSString *urlStr = [NSString stringWithFormat:@"%@&page=%ld", FreshNewUrl, page];
            return [AFNetworkClient netRequestGetWithUrl:urlStr withParameter:nil withBlock:^(id data, FinishRequestType finishType, NSError *error) {
                [self deallWithReturnData:data withFinishType:finishType withError:error withBlock:returnBlock];
            }];
        }
    }
}

-(NSURLSessionDataTask *)fetchNextNewArticleList:(ReturnBlock) returnBlock
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
            value.data = [ArticleViewModel fetchFavListWithOffset:_favOffset withSize:PageSize];
            if (value.data == nil
                || ([value.data isKindOfClass:[NSArray class]] && ((NSArray *)value.data).count < PageSize)) {
                value.finishType = REQUEST_NO_MORE_DATA;
            }
            _favOffset += ((NSArray *)value.data).count;
            returnBlock(value);
            return nil;
        } else {
            NSString *urlStr = [NSString stringWithFormat:@"%@&page=%ld", FreshNewUrl, page];
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

-(void)deallWithReturnData:(id)data withFinishType:(FinishRequestType)finishType withError:(NSError *)error withBlock:(ReturnBlock) returnBlock
{
    NetReturnValue *value = [[NetReturnValue alloc] init];
    value.finishType = finishType;
    value.error = error;

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (finishType != REQUEST_FAILED) {
            NSArray *list = [data getArrayValueForKey:@"posts" defaultValue:nil];
            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in list) {
                ArticleModel *model = [[ArticleModel alloc] initWithDictionary:dic error:nil];
                model.isRead = [NSNumber numberWithInteger:[ArticleViewModel isReadWithModelInBackGround:model]];
                [result addObject:model];
            }
            value.data = result;
            if (result.count < PageSize) {
                if (returnBlock) {
                    value.finishType = REQUEST_NO_MORE_DATA;
                    value.error = nil;
                    isNoMoreData = YES;
                }
            } else {
                if (returnBlock) {
                    value.finishType = REQUEST_SUCESS;
                    value.error = nil;
                }
            }
        }
 
        dispatch_async(dispatch_get_main_queue(), ^{
            if (returnBlock) {
               returnBlock(value);
            }
        });
    });

}

-(void)articleDetailWithData:(id)data withIndex:(NSInteger)index
{
    ArticleDetailController *detail = [[ArticleDetailController alloc] initWithData:data withIndex:index];
    detail.isFavType = self.isFavType;
    [TheAppDelegate.rootNavigationController pushViewController:detail animated:YES];
}




//MagicRecord

+(NSArray*)fetchFavListWithOffset:(NSInteger)offset withSize:(NSInteger)size
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ArticleModel_CoreData"];

    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sortTime" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest   setFetchLimit:size];
    [fetchRequest   setFetchOffset:offset];
    
    NSArray *result =[ArticleModel_CoreData MR_executeFetchRequest:fetchRequest inContext:[NSManagedObjectContext MR_defaultContext]];
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < result.count; i++) {
        ArticleModel_CoreData *item = [result objectAtIndex:i];
        ArticleModel *model = [[ArticleModel alloc] init];
        [self changeModel:model withModel:item];
        [returnValue addObject:model];
    }
    return returnValue;
}

+(void)saveFavWithModel:(id)model withBlock:(void(^)(BOOL result)) block
{
    ArticleModel *data = model;
    
    NSArray *array = [ArticleModel_CoreData MR_findByAttribute:@"id" withValue:data.id];
    if (array == nil ||  array.count <= 0) {
        id item = [ArticleModel_CoreData MR_createEntity];
        [self changeModel:item withModel:data];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Article_Fav_Data_Change_Notify object:model];
        });
    }

    if (block) {
         block(YES);
    }
}

+(void)deleteFavWithModel:(id)model
{
    ArticleModel *data = model;
    NSArray *array = [ArticleModel_CoreData MR_findByAttribute:@"id" withValue:data.id];
    if (array && array.count > 0) {
        ArticleModel_CoreData *item = array.firstObject;
        [item MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Article_Fav_Data_Change_Notify object:model];
        });
    }
}

+(BOOL)isFavWithModel:(id)model
{
    ArticleModel *data = model;
    NSArray *array = [ArticleModel_CoreData MR_findByAttribute:@"id" withValue:data.id];
    if (array && array.count > 0) {
        return YES;
    }
    return NO;
}


+(NSArray*)fetchReadListWithPage:(NSInteger)page withSize:(NSInteger)size
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ArticleModel_CoreData"];
    
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sortTime" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest   setFetchLimit:size];
    [fetchRequest   setFetchOffset:(page-1) * size];
    
    NSArray *result =[ArticleModel_Read_CoreData MR_executeFetchRequest:fetchRequest inContext:[NSManagedObjectContext MR_defaultContext]];
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < result.count; i++) {
        ArticleModel_Read_CoreData *item = [result objectAtIndex:i];
        ArticleModel *model = [[ArticleModel alloc] init];
        [self changeModel:model withModel:item];
        [returnValue addObject:model];
    }
    return returnValue;
}

+(void)saveReadWithModel:(id)model withBlock:(void(^)(BOOL result)) block
{
    ArticleModel *data = model;
    
    NSArray *array = [ArticleModel_Read_CoreData MR_findByAttribute:@"id" withValue:data.id];
    if (array == nil ||  array.count <= 0) {
        id item = [ArticleModel_Read_CoreData MR_createEntity];
        [self changeModel:item withModel:data];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
    if (block) {
        block(YES);
    }
}

+(void)deleteReadWithModel:(id)model
{
    ArticleModel *data = model;
    NSArray *array = [ArticleModel_Read_CoreData MR_findByAttribute:@"id" withValue:data.id];
    if (array && array.count > 0) {
        ArticleModel_Read_CoreData *item = array.firstObject;
        [item MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}

+(BOOL)isReadWithModel:(id)model
{
    ArticleModel *data = model;
    NSArray *array = [ArticleModel_Read_CoreData MR_findByAttribute:@"id" withValue:data.id];
    if (array && array.count > 0) {
        return YES;
    }
    return NO;
}

//后续应该全部切换到后台线程
+(BOOL)isReadWithModelInBackGround:(id)model
{
    if ([NSThread currentThread].isMainThread) {
        return [self isReadWithModel:model];
    } else {
        ArticleModel *data = model;
        NSArray *array = [ArticleModel_Read_CoreData MR_findByAttribute:@"id" withValue:data.id inContext:[NSManagedObjectContext MR_context]];
        if (array && array.count > 0) {
            return YES;
        }
        return NO;
    }
}


@end
