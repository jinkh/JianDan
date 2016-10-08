//
//  ArticleDetailModel.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/13.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ArticleDetailModel.h"

@implementation ArticleDetailModel

-(void)dealloc
{
    ReleaseClass;
}

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    if (self = [super initWithDictionary:dict error:err]) {
        
    }
    return self;
}

-(id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
