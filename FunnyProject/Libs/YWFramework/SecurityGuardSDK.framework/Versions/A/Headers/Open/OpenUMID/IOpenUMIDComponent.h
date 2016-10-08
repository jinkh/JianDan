//
//  IOpenUMIDComponent.h
//  OpenSecurityGuardSDK
//
//  Created by lifengzhong on 14/8/13.
//  Copyright (c) 2014年 Li Fengzhong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  umid 使用的环境变量定义
 */
typedef enum {
    /**
     *  线上环境
     */
    SDP_ENVIRONMENT_ONLINE = 0,
    /**
     *  预发布环境
     */
    SDP_ENVIRONMENT_PRE,
    /**
     *  日常环境
     */
    SDP_ENVIRONMENT_DAILY,
    /**
     *  未设置
     */
    SDP_ENVIRONMENT_UNSET
    
} SDP_ENVIRONMENT;

@protocol IOpenUMIDComponent <NSObject>

/**
 *  初始化 umid
 *
 *  @param resultHandler 初始化结果回调，本函数必须在主线程内完成（推荐在 appdelegate中，应用启动时调用）
 *
 *  @return 调用成功结果
 */
- (void) registerInitListener: (void (^) (NSString* securityToken, NSError* error)) listener;

/**
 *  初始化umid
 *
 *  @param appKey   appkey，注意此值要与 dpEnv 对应，线上环境对应传线上的 appkey，以此类推
 *  @param sdpEnv   接入应用当前的环境，包括线上，预发，线上
 *  @param authCode 授权码，指定umid使用哪个加密文件，注意入参appkey在authCode对应的图片中要存在
 *  @param handler 初始化结果回调，本函数必须在主线程内完成（推荐在 appdelegate中，应用启动时调用）
 *
 */
- (void) initUMID: (NSString*) appKey
      environment: (SDP_ENVIRONMENT) sdpEnv
         authCode: (NSString*) authCode
          handler: (void (^) (NSString* securityToken, NSError* error)) handler;

/**
 *  返回UMID Token，长度为32的字符串
 *
 *  @return 如果失败，返回内容为24个0的字符串
 */
- (NSString*) getSecurityToken;

/**
 *  清空 umid 本地数据（mock接口，正常情况不要调用！）
 */
- (void) resetClientData;

/**
 *  获取 umid
 *
 *  @return umid版本号
 */
- (NSString*) getUMIDVersion;

@end
