//
//  ViewBaseModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/11.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetReturnValue.h"

typedef void (^ReturnBlock) (NetReturnValue *returnValue);

@interface ViewBaseModel : NSObject


+(void)changeModel:(id)toModel  withModel:(id)fromModel;

@end
