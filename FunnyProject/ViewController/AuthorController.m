//
//  AuthorController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/29.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "AuthorController.h"

@interface AuthorController ()

{
    UIImageView *iconView;
    
    UILabel *nameLabel;
    
    
    UILabel *infoLabel;
    
    UILabel *contactLabel;
    
    
    UIScrollView *bgScroll;
}

@end

@implementation AuthorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = Controller_Bg;
    self.zh_showCustomNav = YES;
    self.zh_title = @"关于作者";
    
    
    bgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenSize.width, ScreenSize.height-64)];
    bgScroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgScroll];
    
    iconView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenSize.width*.5-25, 20, 50, 50)];
    iconView.backgroundColor = [UIColor clearColor];
    iconView.image = [UIImage imageNamed:@"user_icon_default"];
    iconView.layer.cornerRadius = 25;
    iconView.layer.masksToBounds = YES;
    [bgScroll addSubview:iconView];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 76, ScreenSize.width, 30)];
    nameLabel.text = @"金子";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.dk_textColorPicker  =Text_Title;
    nameLabel.font = FONT(17);
    [bgScroll addSubview:nameLabel];
    
    
    UIView *bg1 = [[UIView alloc] initWithFrame:CGRectMake(-1, 116, ScreenSize.width+2, 100)];
    bg1.dk_backgroundColorPicker = Cell_Bg;
    bg1.layer.borderWidth = 1;
    bg1.layer.borderColor  =COLORA(0, 0, 0, .2).CGColor;
    [bgScroll addSubview:bg1];
    
    infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, bg1.frame.size.width-30, bg1.frame.size.height)];
    infoLabel.text = @"\n程序员一只，从事移动开发多年，现全职于iOS开发，利用业余时间写了这个作品，希望大家能够喜欢  \n感谢shenhualxt@Github，此项目参考了他的作品  \n感谢线上作品\"煎了个蛋\"，此项目参考了其UI设计\n";
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.textColor = COLOR(100, 100, 100);
    infoLabel.font = DefaultFont(16);
    infoLabel.numberOfLines = 0;
    infoLabel.dk_textColorPicker  =Text_Title;
    [bg1 addSubview:infoLabel];
    
    [infoLabel sizeToFit];
    bg1.frame = CGRectMake(-1, nameLabel.frame.origin.y+nameLabel.frame.size.height+20, ScreenSize.width+2, infoLabel.bounds.size.height);
    

    
    UIView *bg2 = [[UIView alloc] initWithFrame:CGRectMake(-1, bg1.frame.size.height+bg1.frame.origin.y+20, ScreenSize.width+2, 60)];
    bg2.dk_backgroundColorPicker = Cell_Bg;
    bg2.layer.borderWidth = 1;
    bg2.layer.borderColor  =COLORA(0, 0, 0, .2).CGColor;
    [bgScroll addSubview:bg2];
    
    contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, bg2.frame.size.width-30, bg2.frame.size.height)];
    contactLabel.text = @"\n本项目即将在Github上开源 \n未来开源地址：https://github.com/jinkh\n";
    contactLabel.textAlignment = NSTextAlignmentLeft;
    contactLabel.textColor = COLOR(100, 100, 100);
    contactLabel.font = DefaultFont(16);
    contactLabel.numberOfLines = 0;
    contactLabel.dk_textColorPicker  =Text_Title;
    [bg2 addSubview:contactLabel];
    
    [contactLabel sizeToFit];
    bg2.frame = CGRectMake(-1, bg1.frame.size.height+bg1.frame.origin.y+20, ScreenSize.width+2, contactLabel.bounds.size.height);
    
    
    CGFloat height = bg2.frame.origin.x+bg2.frame.size.height+10;
    if (height < bgScroll.bounds.size.height) {
        height = bgScroll.bounds.size.height+1;
    }
    bgScroll.contentSize = CGSizeMake(bgScroll.bounds.size.width, height);
    
    
}



@end
