//
//  Macro.h
//  DemoApp
//
//  Created by Zinkham on 15/10/21.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#ifndef Macro_h
#define Macro_h
#import "AppDelegate.h"

//重新定义系统的NSLog，__OPTIMIZE__ 是release 默认会加的宏,release版本不打日志
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...){}
#endif


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#define ISIP4  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) : NO)

#define ISIP4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define ISIP5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define ISIP6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define ISIP6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define ISIP6later [[UIScreen mainScreen] currentMode].size.width > 640



#define COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define COLORA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


#define ScreenSize [[UIScreen mainScreen]bounds].size
#define ScreenSizeFix CGSizeMake(MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height), MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))


//#define DefaultFont(fontsize)[UIFont systemFontOfSize:fontsize]
#define IconFont(fontsize) [UIFont fontWithName:@"IconFont" size:fontsize]
#define FONT(fontsize) [UIFont fontWithName:@"STHeitiSC-Medium" size:fontsize]
#define DefaultFont(fontsize) SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0") ? [UIFont fontWithName:@"PingFangSC-Regular" size:fontsize] : [UIFont systemFontOfSize:fontsize]


#define TheAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])



#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]

#define WIDTH  (ScreenSize.width > ScreenSize.height ? ScreenSize.height : ScreenSize.width)
#define TAB_HEIGHT 50


#define ReleaseClass NSLog(@"release class:%@",NSStringFromClass([self class]))

#define GET_IMAGE(name) [CATCommon imageNamed:name]
#define ThemeColor COLOR(49, 193, 124)


#endif /* Macro_h */
