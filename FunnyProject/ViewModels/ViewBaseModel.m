//
//  ViewBaseModel.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/11.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ViewBaseModel.h"
#import "AFNetworkClient.h"
#import "NSManagedObject+DictionaryExport.h"

@implementation ViewBaseModel

+(void)changeModel:(id)toModel  withModel:(id)fromModel
{
    
    ///只用于当前工程，只支持特殊的nsdata和array互转
    NSArray *properties = [self getAllPropertiesWith:toModel];
    for (NSString *str in properties) {
        id value = [fromModel valueForKeyPath:str];
        if (value) {
            if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSAttributedString class]]) {
                value = [NSKeyedArchiver archivedDataWithRootObject:value];
            } else if ([value isKindOfClass:[NSData class]]) {
                value =  [NSKeyedUnarchiver unarchiveObjectWithData:value];
            }
            [toModel setValue:value forKeyPath:str];
        } else {
            if ([str isEqualToString:@"sortTime"]) {
                UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
                value = [NSNumber numberWithUnsignedLongLong:recordTime];
            }
            
            [toModel setValue:value forKeyPath:str];
        }
    }
    
}


+ (NSArray *)getAllPropertiesWith:(id)object
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([object class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject:[NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

@end
