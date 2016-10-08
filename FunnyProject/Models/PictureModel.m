//
//  PictureModel.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/11.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "PictureModel.h"


@implementation PictureModel

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    if (self = [super initWithDictionary:dict error:err]) {
        NSArray *array = [dict getArrayValueForKey:@"pics" defaultValue:nil];
        NSMutableArray *pictures = [[NSMutableArray alloc] init];
        if (pictures.count > 1) {
            
        }
        for (NSString *str in array) {
            PictureSourceModel *item = [[PictureSourceModel alloc] init];
            item.url = str;
            [pictures addObject:item];
        }
        self.pics = pictures;
    }
    return self;
}


-(id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
