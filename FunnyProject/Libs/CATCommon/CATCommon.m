//
//  CATCommon.m
//  Catering
//
//  Created by 王 强 on 14-8-12.
//  Copyright (c) 2014年 jackygood. All rights reserved.
//

#import "CATCommon.h"
#import "MBProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#include <sys/param.h>
#include <sys/mount.h>
#import <Accelerate/Accelerate.h>
#include <sys/xattr.h>
#import <CommonCrypto/CommonDigest.h>
#import <ImageIO/ImageIO.h>
#import "FLAnimatedImage.h"
#import "UIImage+Resize.h"

@implementation CATCommon

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)showGlobalLoadingIndicator
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    HUD.minSize = CGSizeMake(75, 75);
    HUD.mode = MBProgressHUDModeIndeterminate;
}

+ (void)showLoadingIndicatorInView:(UIView *)view
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.minSize = CGSizeMake(75, 75);
    HUD.mode = MBProgressHUDModeIndeterminate;
}

+ (void)hideLoadingIndicatorInView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
}

+ (void)hideGlobalLoadingIndicator
{
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:NO];
}


+ (NSString *)numberFormat:(int)number
{
    NSMutableString * mutString = [NSMutableString stringWithFormat:@"%d",number];
    if (number < 1000) {
        
    }else if((number >= 1000)&&(number < 10000)){
        [mutString insertString:@"," atIndex:[mutString length]-3];
        
    }else{
        if((number >= 10000)&&(number < 10000000)){
            [mutString insertString:@"." atIndex:[mutString length]- 4];
        } else {
            
            [mutString insertString:@"," atIndex:[mutString length] - 7];
            [mutString insertString:@"." atIndex:[mutString length] - 4];
        }
        [mutString deleteCharactersInRange:NSMakeRange([mutString rangeOfString:@"."].location + 2, 2)];
        [mutString appendString:@"万"];
    }
    return mutString;
}

+ (NSString *)datsStringWithTimeInterval:(long long)interval
{
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:interval/1000];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *tempString=[dateFormatter stringFromDate:date];
    
    tempString = [CATCommon modifyTimeDisp:tempString];
    return tempString;
}

+(NSString *)modifyTimeDisp:(NSString *)_timeString
{
    NSString *tempTimeString=[NSString stringWithFormat:@"%@",_timeString];
    NSString *retTimeString=@"";
    if([tempTimeString isEqualToString:@""])
    {
        retTimeString=@" ";
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date = [dateFormatter dateFromString:tempTimeString];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *tempValue=[dateFormatter stringFromDate:date];
        //判断是否为今天
        if([tempValue isEqualToString:[dateFormatter stringFromDate:[NSDate date]]])
        {
            NSTimeInterval timeInterval=[[NSDate date] timeIntervalSinceDate:date];
            //判断时间差是否在一个小时之内
            if(timeInterval<3600)
            {
                //显示"多少分钟前"
                int tempValue=timeInterval/60;
                retTimeString=[NSString stringWithFormat:@"%d分钟前",tempValue];
            }
            else
            {
                //显示"多少小时前"
                int tempValue=timeInterval/(60 * 60);
                retTimeString=[NSString stringWithFormat:@"%d小时前",tempValue];
            }
        }
        else
        {
            //显示"几几年几月几号"
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            retTimeString=[dateFormatter stringFromDate:date];
        }
    }
    return retTimeString;
}

//获取图片
+(UIImage *)imageNamed:(NSString *)_imageName
{
    UIImage *tempImage = nil;
    if (_imageName ==nil
        ||_imageName.length == 0)
    {
        
    }
    else if ([_imageName hasSuffix:@".png"]
             ||[_imageName hasSuffix:@".jpg"])
    {
        NSString *extension = [_imageName pathExtension];
        NSString *path = [[NSBundle mainBundle] pathForResource:[_imageName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",extension] withString:@""] ofType:extension];
        tempImage = [UIImage imageWithContentsOfFile:path];
    }
    else
    {
        int scale = (int)[UIScreen mainScreen].scale;
        if (scale<=2)
        {
            scale = 2;
        }
        else
        {
            scale = 3;
        }
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%dx",_imageName,scale] ofType:@"png"];
        tempImage = [UIImage imageWithContentsOfFile:path];
    }
    return tempImage;
}

+ (BOOL)isHaveAuthorForCamer
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if (authStatus == AVAuthorizationStatusDenied)
        {
            NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"相机相关权限被禁止了"
                                                             message:[NSString stringWithFormat:@"请在 设置 - 隐私 - 相机 中\n开启%@的访问权限",appName]
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
            [alert show];
            
            return NO;
        }
        return YES;
    }
    return YES;
}

+ (BOOL)isHaveAuthorForLibrary
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
    {
        //无权限
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"相册相关权限被禁止了"
                                                         message:[NSString stringWithFormat:@"请在 设置 - 隐私 - 相册 中\n开启%@的访问权限",appName]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    return YES;
}

+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+(int)getSysUTCTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSTimeZone *timeZone=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *tempString=[dateFormatter stringFromDate:[NSDate date]];
    
    int timestamp=[[NSDate date]timeIntervalSince1970];
    timestamp=[[dateFormatter dateFromString:tempString] timeIntervalSince1970];
    return timestamp;
}

+(NSString *)string2MD5
{
    /*
     String str4 = System.currentTimeMillis() + "";
     paramHashMap.put("apphash", DZStringUtil.stringToMD5(str4.substring(0, 5) + "appbyme_key").substring(8, 16));
     */
    NSString *ret = @"";
    int time0 = [CATCommon getSysUTCTime];
    NSString *timeString = [NSString stringWithFormat:@"%d000",time0];
    NSLog(@"1 timeString = %@",timeString);
    NSString *subTimeString = [timeString substringWithRange:NSMakeRange(0, 5)];
    NSLog(@"2 subTimeString = %@",subTimeString);
    NSString *newString = [NSString stringWithFormat:@"%@appbyme_key",subTimeString];
    
    NSString *urlEncode = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                             (CFStringRef)newString, nil,
                                                                                             (CFStringRef)@"~!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    NSString *mdString = [CATCommon md5:urlEncode];
    
    ret = [mdString substringWithRange:NSMakeRange(8, 8)];
    NSLog(@"ret = %@",ret);
    return ret;
}

//生成签名
+(NSString *)signWithParmString:(NSDictionary *)_parmDic
{
    NSString *signString = @"";
    NSArray *allKeys = [_parmDic allKeys];
    NSSortDescriptor*sd1 = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    allKeys = [allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];
    for (int i = 0; i < allKeys.count; i++) {
        signString = [NSString stringWithFormat:@"%@%@%@",signString,[allKeys objectAtIndex:i], [_parmDic valueForKey:[allKeys objectAtIndex:i]]];
    }
    signString = [NSString stringWithFormat:@"%@%@",signString, @"616568ac65c14465872b6a77c47b3367"];
    NSString *urlEncode=(NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                             (CFStringRef)signString, nil,
                                                                                             (CFStringRef)@"~!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    NSString *mdString=[CATCommon md5:urlEncode];
    //[urlEncode release];
    return mdString;
}

+(BOOL)isEmailAddress:(NSString*)email
{
    
    //NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}


+ (UIImage*)makeCircleCornerImage:(UIImage*)img
{
    UIImage *image = [img thumbnailImage:MIN(img.size.width, img.size.height)*[UIScreen mainScreen].scale transparentBorder:1 cornerRadius:MIN(img.size.width, img.size.height)*[UIScreen mainScreen].scale*.5 interpolationQuality:kCGInterpolationHigh];
    return image;
}




@end
