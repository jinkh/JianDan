//
//  PicCommentModel.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/14.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "PicCommentModel.h"

@implementation PicCommentModel

-(void)dealloc
{
    ReleaseClass;
}

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    if (self = [super initWithDictionary:dict error:err]) {
        NSDictionary *dic = [dict getDicValueForKey:@"author" defaultValue:nil];
        self.author_name = [dic getStringValueForKey:@"name" defaultValue:@""];
        self.author_avatar_url = [dic getStringValueForKey:@"avatar_url" defaultValue:@""];
    }
    return self;
}

-(id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
