//
//  ArticleModel.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/11.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ArticleModel.h"


@implementation ArticleModel

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    if (self = [super initWithDictionary:dict error:err]) {
        NSDictionary *dic = [dict getDicValueForKey:@"custom_fields" defaultValue:nil];
        NSArray *array = [dic getArrayValueForKey:@"thumb_c" defaultValue:nil];
        self.thumb_c = array.firstObject;
        NSDictionary *authorDic = [dict getDicValueForKey:@"author" defaultValue:nil];
        self.author_name = [authorDic getStringValueForKey:@"nickname" defaultValue:@""];
    }
    return self;
}

-(id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
