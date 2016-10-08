//
//  TvFastRewindView.m
//  BaoZouTV
//
//  Created by Zinkham on 15/4/18.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#import "TvFastRewindView.h"
#import <CoreMedia/CoreMedia.h>

@interface TvFastRewindView()
{
    UIView *bgView;
    
    UIImageView *iconView;
    
    UILabel *nowTimeLabel;
    
    UILabel *timeLabel;
}
@end

@implementation TvFastRewindView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width-130)*.5, (frame.size.height-100)*.5, 130, 90)];
        bgView.backgroundColor = COLORA(0, 0, 0, 0.8);
        bgView.layer.masksToBounds= YES;
        bgView.layer.shadowColor = COLORA(0, 0, 0, 0.8).CGColor;
        bgView.layer.shadowOffset = CGSizeMake(0, -3);
        bgView.layer.borderColor = COLORA(0, 0, 0, 0.09).CGColor;
        bgView.layer.borderWidth = 0.5;
        bgView.layer.cornerRadius = 8;
        [self addSubview:bgView];
        
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake((bgView.frame.size.width-45)*.5, 10, 45, 45)];
        iconView.image = [UIImage imageNamed:@"ic_media_ff"];
        [bgView addSubview:iconView];
        
        nowTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconView.frame.size.height+iconView.frame.origin.y
                                                            , bgView.frame.size.width*.5, 15)];
        nowTimeLabel.backgroundColor = [UIColor clearColor];
        nowTimeLabel.font = DefaultFont(14);
        nowTimeLabel.textAlignment = NSTextAlignmentRight;
        nowTimeLabel.text = @"--:--";
        nowTimeLabel.textColor = [UIColor whiteColor];
        [bgView addSubview:nowTimeLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width*.5, iconView.frame.size.height+iconView.frame.origin.y
                                                                 , bgView.frame.size.width*.5, 15)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = DefaultFont(14);
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.text = @"/--:--";
        [bgView addSubview:timeLabel];
    
    }
    return self;
}

-(void)fast
{
    self.initTime = self.initTime+2 > 0 ? self.initTime+2 : 2;
    
    if (self.initTime > self.duration) {
        self.initTime = self.initTime-2;
    }
    nowTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d/", (int)(self.initTime/60), (int)(self.initTime%60)];
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(self.duration / 60), (int)(self.duration % 60)];
    iconView.image = [UIImage imageNamed:@"ic_media_ff"];
}

-(void)rewind
{
    self.initTime = self.initTime-2 > 0 ? self.initTime-2 : 2;
    if (self.initTime > self.duration) {
        self.initTime = self.initTime-2;
    }
    nowTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d/", (int)(self.initTime/60), (int)(self.initTime%60)];
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(self.duration / 60), (int)(self.duration % 60)];
    iconView.image = [UIImage imageNamed:@"ic_media_rew"];
}

@end
