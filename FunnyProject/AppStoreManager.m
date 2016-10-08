//
//  AppStoreManager.m
//  FunnyProject
//
//  Created by Zinkham on 16/9/12.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "AppStoreManager.h"
#import "NSDate+Extension.h"

@implementation AppStoreManager

+ (BOOL)isInReview
{
    //估算审核时间为7天
    NSString *uploadDateStr = @"2016-09-12 00:00:00";
    NSDate *date = [NSDate dateWithString:uploadDateStr format:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger dayAgo = [date daysAgo];
    if (dayAgo >= 7) {
        return NO;
    }
    return YES;

}

@end
