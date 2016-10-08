//
//  ShareView.h
//  DemoApp
//
//  Created by jinkh on 15/12/17.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView


-(instancetype)initWithData:(id)data;

-(void)dismissAnimate:(BOOL)anim;

-(void)showAnimate:(BOOL)anim;

@end
