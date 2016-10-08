//
//  PictureController.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/11.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureController : UIViewController

-(instancetype)initWithUrl:(NSString *)urlStr isRandom:(BOOL)random;


-(instancetype)initWithFavTypeAndUrl:(NSString *)urlStr;

@end
