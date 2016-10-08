//
//  TvOrentionManager.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/21.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TvOrentionManager : NSObject

+ (instancetype)sharedInstance;

-(void)setOrentionLandscapeRight;

-(void)setOrentionPortrait;

@property (nonatomic) BOOL isOrientationLocked;

@end
