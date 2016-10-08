//
//  UserManager.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/29.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject


+(NSString *)getUSerEmail;

+(void)saveUSerEmail:(NSString *)value;

+(NSString *)getUSerName;

+(void)saveUSerName:(NSString *)value;

+(BOOL)isUserLogin;


@end
