//
//  AFNetworkClient.h
//  DemoApp
//
//  Created by Zinkham on 15/10/21.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Urls.h"

typedef enum {
    REQUEST_SUCESS=1,  //请求成功
    REQUEST_FAILED,    //请求失败
    REQUEST_NO_MORE_DATA,   //请求没有数据
} FinishRequestType;



@interface AFNetworkClient : NSObject

+(NSURLSessionDataTask *)netRequestGetWithUrl:(NSString *) urlString
                                withParameter: (NSDictionary *) parameter
                                withBlock:(void(^)(id data, FinishRequestType finishType, NSError *error)) block;

+(NSURLSessionDataTask *)netRequestPostWithUrl:(NSString *) urlString
                                withParameter: (NSDictionary *) parameter
                                withBlock:(void(^)(id data, FinishRequestType finishType, NSError *error)) block;

@end
