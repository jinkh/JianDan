//
//  SettingCell.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/28.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SettingCellRightStyle) {
    SettingCellRightStyleIndicator,
    SettingCellRightStyleDetail,
    SettingCellRightStyleSwitch
};


@interface SettingCell : UITableViewCell

-(void)fillData:(id)data withStyle:(SettingCellRightStyle)stytle;


+(CGFloat)heightForCell;

@end
