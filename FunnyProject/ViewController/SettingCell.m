//
//  SettingCell.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/28.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "SettingCell.h"

@interface SettingCell()

{
    SettingCellRightStyle rightStytle;
    
    UISwitch* mySwitch;
}
@end

@implementation SettingCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.frame = CGRectMake(0, 0, ScreenSize.width, [SettingCell heightForCell]);
        self.dk_backgroundColorPicker = Cell_Bg;
        self.textLabel.dk_textColorPicker  =Text_Title;
        self.textLabel.font = DefaultFont(17);
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.detailTextLabel.text = @"";
        self.detailTextLabel.dk_textColorPicker  =Text_Title;
        self.detailTextLabel.alpha = .6;
        self.detailTextLabel.font = DefaultFont(16);
        
        
        mySwitch = [[UISwitch alloc]init];
        [mySwitch addTarget: self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        mySwitch.center = CGPointMake(ScreenSize.width-40, [SettingCell heightForCell]*.5);
        [self addSubview:mySwitch];
    }
    return self;
}

-(void)fillData:(id)data withStyle:(SettingCellRightStyle)stytle
{
    self.textLabel.text = data;
    [self setCellRightStyle:stytle];
    if ([self.textLabel.text isEqualToString:@"清除图片缓存"]) {
        [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
            CGFloat cachSize = totalSize/1024.0f/1024.0f;
            self.detailTextLabel.text = [NSString stringWithFormat:@"%.2f M", cachSize];
        }];

    } else if ([self.textLabel.text isEqualToString:@"图片缓存有效期"]) {
       
        NSArray *data = [SettingManager getCachUsefulData];
        NSInteger index = [SettingManager getCachUsefulDateType];
        self.detailTextLabel.text = [data objectAtIndex:index];
    } else if ([self.textLabel.text isEqualToString:@"清空数据库"]) {
        self.detailTextLabel.text = @"本地非图片数据";
    }
    
    if ([self.textLabel.text isEqualToString:@"短视频自动播放"]) {
        [mySwitch setOn:[SettingManager getSortVideoShoulAuoPlay]];
    } else if ([self.textLabel.text isEqualToString:@"夜间模式"]){
        
        if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
            [mySwitch setOn:YES];
        } else {
            [mySwitch setOn:NO];
        }
    }
    
}

-(void)setCellRightStyle:(SettingCellRightStyle)stytle
{
    rightStytle= stytle;
    if (rightStytle == SettingCellRightStyleIndicator) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.detailTextLabel.hidden = YES;
        mySwitch.hidden = YES;
    } else if (rightStytle == SettingCellRightStyleDetail) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.detailTextLabel.hidden = NO;
        mySwitch.hidden = YES;
    } else if (rightStytle == SettingCellRightStyleSwitch) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.detailTextLabel.hidden = YES;
        mySwitch.hidden = NO;
    }
}

- (void)switchValueChanged:(id)sender{
    UISwitch* control = (UISwitch*)sender;
    if(control == mySwitch){
        BOOL on = control.on;
        if ([self.textLabel.text isEqualToString:@"短视频自动播放"]) {
            [SettingManager setSortVideoShoulAuoPlay:on];
        } else if ([self.textLabel.text isEqualToString:@"夜间模式"]) {
            if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
                [self.dk_manager dawnComing];
            } else {
                [self.dk_manager nightFalling];
            }
        }
    }
}


+(CGFloat)heightForCell
{
    return 50;
}

@end
