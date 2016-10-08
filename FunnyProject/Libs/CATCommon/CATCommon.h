//
//  CATCommon.h
//  Catering
//
//  Created by 王 强 on 14-8-12.
//  Copyright (c) 2014年 jackygood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CATCommon : NSObject


+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

+ (void)showGlobalLoadingIndicator;

+ (void)hideGlobalLoadingIndicator;

+ (void)showLoadingIndicatorInView:(UIView *)view;

+ (void)hideLoadingIndicatorInView:(UIView *)view;

+ (NSString *)numberFormat:(int)number;

+ (NSString *)datsStringWithTimeInterval:(long long)interval;

//获取图片
+(UIImage *)imageNamed:(NSString *)_imageName;

+ (BOOL)isHaveAuthorForLibrary;

+ (BOOL)isHaveAuthorForCamer;

+(NSString *)string2MD5;

+(NSString *)signWithParmString:(NSDictionary *)_parmDic;

+(BOOL)isEmailAddress:(NSString*)email;

+ (UIImage*)makeCircleCornerImage:(UIImage*)img;

@end
