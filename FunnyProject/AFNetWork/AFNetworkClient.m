//
//  AFNetworkClient.m
//  DemoApp
//
//  Created by Zinkham on 15/10/21.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#import "AFNetworkClient.h"
@interface AFNetworkClient()
{

}
@end

@implementation AFNetworkClient


+ (AFHTTPSessionManager *)sessionManager {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] init];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/xml", @"text/xml", @"text/html", @"application/json", @"text/json", @"text/javascript", @"application/xml",@"text/plain", nil];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    
    return manager;
}


+(NSURLSessionDataTask *)netRequestGetWithUrl:(NSString *) urlString
                                withParameter: (NSDictionary *) parameter
                              withBlock:(void(^)(id data, FinishRequestType finishType, NSError *error)) block
{
//    if ([AFNetworkClient sessionManager] && [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
//        [[ToastHelper sharedToastHelper] toast:@"请检查网络连接"];
//        return nil;
//    }
    
    return [[AFNetworkClient sessionManager] GET:urlString parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject, REQUEST_SUCESS, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(task.response, REQUEST_FAILED, error);
    }];
}

+(NSURLSessionDataTask *)netRequestPostWithUrl:(NSString *) urlString
                                 withParameter: (NSDictionary *) parameter
                              withBlock:(void(^)(id data, FinishRequestType finishType, NSError *error)) block
{
//    if ([AFNetworkClient sessionManager] && [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
//        [[ToastHelper sharedToastHelper] toast:@"请检查网络连接"];
//        return nil;
//    }
    
    return [[AFNetworkClient sessionManager] POST:urlString parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject, REQUEST_SUCESS, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(task.response, REQUEST_FAILED, error);
    }];
}

@end
