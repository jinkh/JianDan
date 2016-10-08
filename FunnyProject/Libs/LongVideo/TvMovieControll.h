//
//  TvMovieControll.h
//  DemoApp
//
//  Created by Zinkham on 15/11/2.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IJKMediaPlayback.h"

@interface TvMovieControll : UIView

@property(nonatomic,weak) id<IJKMediaPlayback> delegatePlayer;

@property (copy, nonatomic) void (^goBackBlock)(void);

@property (copy, nonatomic) void (^playControllBlock)(void);

@property (copy, nonatomic) void (^fullScreenBlock)(void);

@property (copy, nonatomic) void (^videoTypeBlock)(void);

-(void)setControllInterfaceOrientation:(UIInterfaceOrientation)orention;

-(void)setTitle:(NSString *)title;

- (void)refreshMediaControl;

-(void)resetVideoType:(int)typeValue;

-(void)setTypeBtnEnabled:(BOOL)enable;

@end
