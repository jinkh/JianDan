//
//  ArticleDetailView.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/15.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleDetailView : UIView

-(instancetype)initWithFrame:(CGRect)frame withData:(id)data;

-(void)pushCommentWithText:(NSString *)content withParentComment:(ArticleCommentModel *)pComment;

@end
