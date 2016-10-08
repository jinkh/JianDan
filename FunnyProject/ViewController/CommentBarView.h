//
//  CommentBarView.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/18.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Comment_Child_Notify @"Comment_Child_Notify"

#define Rerfresh_CommednBar_Notify @"Rerfresh_CommednBar_Notify"


@protocol CommentBarViewDelegate <NSObject>

@optional

- (void)shareAction;

- (void)favAction;

- (void)commentActionWithText:(NSString *)content withParent:(id)parent;

@end

@interface CommentBarView : UIView

@property (weak, nonatomic) id<CommentBarViewDelegate>delegate;

-(void)resetFavSate:(BOOL)isFav;

@end
