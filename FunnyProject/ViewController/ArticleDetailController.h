//
//  ArticleDetailController.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/13.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Fetch_More_Article_Notify @"Fetch_More_Article_Notify"
#define Rest_Table_Position_Article_Notify @"Rest_Table_Position_Article_Notify"

@interface ArticleDetailController : UIViewController

-(instancetype)initWithData:(NSArray *)data withIndex:(NSInteger)index;

@end
