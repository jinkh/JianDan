//
//  JokeDetailController.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/18.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Fetch_More_Joke_notify @"Fetch_More_Joke_Notify"
#define Rest_Table_Position_Joke_Notify @"Rest_Table_Position_Joke_Notify"

@interface JokeDetailController : UIViewController

@property (assign, nonatomic) BOOL isFavType;

-(instancetype)initWithData:(NSArray *)data withIndex:(NSInteger)index;

@end
