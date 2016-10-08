//
//  TvFastRewindView.h
//  BaoZouTV
//
//  Created by Zinkham on 15/4/18.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TvFastRewindView : UIView

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, assign) NSInteger initTime;

-(id)initWithFrame:(CGRect)frame;

-(void)fast;

-(void)rewind;

@end
