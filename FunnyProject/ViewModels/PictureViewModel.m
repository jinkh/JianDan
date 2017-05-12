//
//  PictureViewModel.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/11.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "PictureViewModel.h"
#import "PictureDetailController.h"

//#define SisterType @"SisterType"
//
//#define BoardType @"BoardType"

#define PageSize 25

@interface PictureViewModel ()
{
    //normal
    NSInteger page;
    BOOL isNoMoreData;
    NSString *urlString;
    NSOperationQueue *queue;
}

@end

@implementation PictureViewModel

-(void)dealloc
{
    [queue cancelAllOperations];
}
-(instancetype)initWithUrl:(NSString *)urlStr
{
    if (self = [super init]) {
        page = 1;
        isNoMoreData = NO;
        urlString = urlStr;
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 3;
        
    }
    return self;
}

-(NSURLSessionDataTask *)fetchPictureList:(ReturnBlock) returnBlock
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
            value.data = [PictureViewModel fetchFavListWithOffset:_favOffset withSize:PageSize withType:urlString];
            if (value.data == nil
                || ([value.data isKindOfClass:[NSArray class]] && ((NSArray *)value.data).count < PageSize)) {
                value.finishType = REQUEST_NO_MORE_DATA;
            }
            _favOffset += ((NSArray *)value.data).count;
            returnBlock(value);
            return nil;
        } else {
            NSString *urlStr = [NSString stringWithFormat:@"%@&page=%ld", urlString, page];
            return [AFNetworkClient netRequestGetWithUrl:urlStr withParameter:nil withBlock:^(id data, FinishRequestType finishType, NSError *error) {
                [self deallWithReturnData:data withFinishType:finishType withError:error withBlock:returnBlock];
            }];
        }
    }
}

-(NSURLSessionDataTask *)fetchNextPictureList:(ReturnBlock) returnBlock
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
            value.data = [PictureViewModel fetchFavListWithOffset:_favOffset withSize:PageSize withType:urlString];
            if (value.data == nil
                || ([value.data isKindOfClass:[NSArray class]] && ((NSArray *)value.data).count < PageSize)) {
                value.finishType = REQUEST_NO_MORE_DATA;
            }
            _favOffset += ((NSArray *)value.data).count;
            returnBlock(value);
            return nil;
        } else {
            NSString *urlStr = [NSString stringWithFormat:@"%@&page=%ld", urlString, page];
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
            if (list.count <= 0) {
                return nil;
            }
            NSMutableArray *result = [PictureModel arrayOfModelsFromDictionaries:list error:nil];
            value.data = result;
            NSMutableString *param = [NSMutableString string];
            for (PictureModel *model in result) {
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
                
                //获取评论数量
                NSDictionary * cResponse = [cData objectForKey:@"response"];
                
                [queue cancelAllOperations];
                
                __block NSInteger operationCount = result.count;
                
                for (PictureModel *model in result) {
                    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
                    __weak NSBlockOperation *weakOperation = operation;
                    [operation addExecutionBlock:^{
                        if (weakOperation.isCancelled) {
                            return;
                        }
                        //获取评论数量
                        NSString * key = [NSString stringWithFormat:@"comment-%@",model.comment_ID];
                        NSDictionary * cResult = [cResponse objectForKey:key];
                        model.comment_count = [cResult getStringValueForKey:@"comments" defaultValue:@"0"];
                        
                        //获取网络图片尺寸
                        
                        for (PictureSourceModel *item in model.pics) {
                            CGSize picSize = [ZHURLImageSize getImageSizeWithURL:[NSURL URLWithString:item.url]];
                            NSInteger width = ScreenSize.width-10;
                            NSInteger height = picSize.height*width/picSize.width;
                            item.picWidth = [NSNumber numberWithInteger:width];
                            item.picHeight = [NSNumber numberWithInteger:height];
                        }
                    }];
                    [operation setCompletionBlock:^{
                        operationCount--;
                        NSLog(@"operationCount = %ld", operationCount);
                        if (operationCount == 0) {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
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
                            }];
                        }
                    }];
                    [queue addOperation:operation];
                }
            }];
        } else {
            if (returnBlock) {
                returnBlock(value);
            }
            return nil;
        }
    }
}

-(void)pictureDetailWithData:(id)data withIndex:(NSInteger)index withType:(NSString *)typeUrl
{
    PictureDetailController *detail = [[PictureDetailController alloc] initWithData:data withIndex:index withType:typeUrl];
    detail.isFavType = self.isFavType;
    [TheAppDelegate.rootNavigationController pushViewController:detail animated:YES];
}


//MagicRecord

+(NSArray*)fetchFavListWithOffset:(NSInteger)offset withSize:(NSInteger)size withType:(NSString *)type
{
    @synchronized ([PictureViewModel class]) {
        Class class = nil;
        if ([type isEqualToString:BoredPicturesUrl]) {
            class = NSClassFromString(@"BoardPictureModel_CoreData");
        } else {
            class = NSClassFromString(@"SisterPictureModel_CoreData");
        }
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(class)];
        
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sortTime" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
        
        [fetchRequest   setFetchLimit:size];
        [fetchRequest   setFetchOffset:offset];
        
        NSArray *result =[class MR_executeFetchRequest:fetchRequest inContext:[NSManagedObjectContext MR_defaultContext]];
        NSMutableArray *returnValue = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < result.count; i++) {
            id item = [result objectAtIndex:i];
            PictureModel *model = [[PictureModel alloc] init];
            [self changeModel:model withModel:item];
            [returnValue addObject:model];
        }
        return returnValue;
    }
}


+(BOOL)saveFavWithModel:(id)model withType:(NSString *)type
{
    @synchronized ([PictureViewModel class]) {
        Class class = nil;
        if ([type isEqualToString:BoredPicturesUrl]) {
            class = NSClassFromString(@"BoardPictureModel_CoreData");
        } else {
            class = NSClassFromString(@"SisterPictureModel_CoreData");
        }
        
        PictureModel *data = model;
        
        NSArray *array = [class MR_findByAttribute:@"comment_ID" withValue:data.comment_ID];
        if (array == nil ||  array.count <= 0) {
            id item = [class MR_createEntity];
            [self changeModel:item withModel:data];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:Picture_Fav_Data_Change_Notify object:model];
            });
        }
        return YES;
    }
}

+(void)deleteFavWithModel:(id)model withType:(NSString *)type
{
    @synchronized ([PictureViewModel class]) {
        Class class = nil;
        if ([type isEqualToString:BoredPicturesUrl]) {
            class = NSClassFromString(@"BoardPictureModel_CoreData");
        } else {
            class = NSClassFromString(@"SisterPictureModel_CoreData");
        }
        
        PictureModel *data = model;
        NSArray *array = [class MR_findByAttribute:@"comment_ID" withValue:data.comment_ID];
        if (array && array.count > 0) {
            id item = array.firstObject;
            [item MR_deleteEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:Picture_Fav_Data_Change_Notify object:model];
            });
        }
    }
}

+(BOOL)isFavWithModel:(id)model withType:(NSString *)type
{
    @synchronized ([PictureViewModel class]) {
        Class class = nil;
        if ([type isEqualToString:BoredPicturesUrl]) {
            class = NSClassFromString(@"BoardPictureModel_CoreData");
        } else {
            class = NSClassFromString(@"SisterPictureModel_CoreData");
        }
        PictureModel *data = model;
        NSArray *array = [class MR_findByAttribute:@"comment_ID" withValue:data.comment_ID];
        if (array && array.count > 0) {
            return YES;
        }
        return NO;
    }
}

@end
