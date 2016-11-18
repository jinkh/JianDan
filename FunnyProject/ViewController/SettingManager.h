//
//  SettingManager.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/29.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Clear_Fav_Data_Change_Notify @"Clear_Fav_Data_Change_Notify"

@interface SettingManager : NSObject

+(NSArray *)getOrginLeftContentMenuTitles;

+(NSArray *)getLeftMenuOrder;

+(void)saveLeftMenuOrder:(NSArray *)array;

+(BOOL)getSortVideoShoulAuoPlay;

+(void)setSortVideoShoulAuoPlay:(BOOL)value;

+(BOOL)getNightMode;

+(void)settNightMode:(BOOL)value;

+(NSArray *)getCachUsefulData;

+(NSInteger)getCachUsefulDateType;

+(void)setCachUsefulDateType:(NSInteger)value;


+(NSArray *)getOrginFavContentMenuTitles;

+(NSArray *)getFavMenuOrder;

+(void)saveFavMenuOrder:(NSArray *)array;

+(void)cleanUpDbWithcompletedBlock:(void(^)(BOOL result)) block;


@end
