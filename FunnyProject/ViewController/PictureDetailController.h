//
//  PictureDetailController.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/13.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Fetch_More_Pictures_notify @"Fetch_More_Pictures_Notify"
#define Rest_Table_Position_Pictures_Notify @"Rest_Table_Position_Pictures_Notify"

@interface PictureDetailController : UIViewController

-(instancetype)initWithData:(id)data withIndex:(NSInteger)index withType:(NSString *)typeUrl;

@end
