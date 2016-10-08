//
//  JokeDetailView.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/18.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JokeDetailView : UIView

-(instancetype)initWithFrame:(CGRect)frame withData:(id)data;

-(void)pushCommentWithText:(NSString *)content withParentId:(NSString *)pId;

@end
