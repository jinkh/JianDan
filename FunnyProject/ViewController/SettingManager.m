//
//  SettingManager.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/29.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "SettingManager.h"
#import "ZHShortVideoManager.h"

@implementation SettingManager


+(NSArray *)getOrginLeftContentMenuTitles
{
      return @[@"新鲜事", @"无聊图", @"妹子图", @"段子", @"短视频"];
}

+(NSArray *)getLeftMenuOrder
{
    id data = [[NSUserDefaults standardUserDefaults] objectForKey:@"left_menu_order"];
    if (data == nil || data == [NSNull null]) {
        NSArray *titleArray = [SettingManager getOrginLeftContentMenuTitles];
        NSMutableArray *orginOrder = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < titleArray.count; i++) {
            [orginOrder addObject:[NSString stringWithFormat:@"%ld", i]];
        }
        data = orginOrder;
        [SettingManager saveLeftMenuOrder:data];
    }
    return data;
}

+(void)saveLeftMenuOrder:(NSArray *)array
{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"left_menu_order"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(BOOL)getSortVideoShoulAuoPlay
{
    id data = [[NSUserDefaults standardUserDefaults] objectForKey:@"sort_video_auto_play"];
    if (data == nil || data == [NSNull null]) {
        [SettingManager setSortVideoShoulAuoPlay:YES];
        return YES;
    }
    return [data boolValue];
}

+(void)setSortVideoShoulAuoPlay:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:value] forKey:@"sort_video_auto_play"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ZHShortVideoManager setShouldAutoPlay:value];
}

+(BOOL)getNightMode
{
    id data = [[NSUserDefaults standardUserDefaults] objectForKey:@"night_mode_value"];
    if (data == nil || data == [NSNull null]) {
        [SettingManager settNightMode:NO];
        return NO;
    }
    return [data boolValue];
}

+(void)settNightMode:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:value] forKey:@"night_mode_value"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSInteger)getCachUsefulDateType
{
    id data = [[NSUserDefaults standardUserDefaults] objectForKey:@"pic_cach_useful_date"];
    if (data == nil || data == [NSNull null]) {
        [SettingManager setCachUsefulDateType:2];
        return YES;
    }
    return [data integerValue];
}

+(void)setCachUsefulDateType:(NSInteger)value
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:value] forKey:@"pic_cach_useful_date"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (value == 0) {
        [SDImageCache sharedImageCache].maxCacheAge = 1 * 24 * 60 * 60;
    } else if (value == 1) {
        [SDImageCache sharedImageCache].maxCacheAge = 3 * 24 * 60 * 60;
    } else if (value == 2) {
        [SDImageCache sharedImageCache].maxCacheAge = 7 * 24 * 60 * 60;
    } else if (value == 3) {
        [SDImageCache sharedImageCache].maxCacheAge = 14 * 24 * 60 * 60;
    }
}

+(NSArray *)getCachUsefulData
{
    NSArray *data = @[@"一天", @"三天", @"一周", @"两周"];
    return data;
}


+(NSArray *)getOrginFavContentMenuTitles
{
    return @[@"新鲜事", @"无聊图", @"妹子图", @"段子", @"短视频"];
}

+(NSArray *)getFavMenuOrder
{
    id data = [[NSUserDefaults standardUserDefaults] objectForKey:@"fav_menu_order"];
    if (data == nil || data == [NSNull null]) {
        NSArray *titleArray = [SettingManager getOrginFavContentMenuTitles];
        NSMutableArray *orginOrder = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < titleArray.count; i++) {
            [orginOrder addObject:[NSString stringWithFormat:@"%ld", i]];
        }
        data = orginOrder;
        [SettingManager saveFavMenuOrder:data];
    }
    return data;
}

+(void)saveFavMenuOrder:(NSArray *)array
{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"fav_menu_order"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)cleanUpDbWithcompletedBlock:(void(^)(BOOL result)) block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
        [ArticleModel_Read_CoreData MR_truncateAllInContext:context];
        [ArticleModel_CoreData MR_truncateAllInContext:context];
        [BoardPictureModel_CoreData MR_truncateAllInContext:context];
        [SisterPictureModel_CoreData MR_truncateAllInContext:context];
        [JokeModel_CoreData MR_truncateAllInContext:context];
        [VideoModel_CoreData MR_truncateAllInContext:context];
        [context MR_saveToPersistentStoreAndWait];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(YES);
            }
        });

    });
}


@end
