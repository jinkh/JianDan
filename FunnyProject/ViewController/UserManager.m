//
//  UserManager.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/29.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager


+(NSString *)getUSerName
{
    NSString *name =  [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    return name;
}

+(void)saveUSerEmail:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"user_email"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getUSerEmail
{
    NSString *email =  [[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"];
    return email;
}

+(void)saveUSerName:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"user_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(BOOL)isUserLogin
{
    if ([UserManager getUSerName] && [UserManager getUSerEmail] ) {
        return YES;
    }
    return NO;
}


@end
