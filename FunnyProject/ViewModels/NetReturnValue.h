//
//  ReturnValue.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/11.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworkClient.h"

@protocol NetReturnValue <NSObject>

@end

@interface NetReturnValue: NSObject

@property (strong, nonatomic) id data;
@property (assign, nonatomic) FinishRequestType finishType;
@property (strong, nonatomic) NSError *error;

@end
