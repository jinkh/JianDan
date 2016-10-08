//
//  LeftCell.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/13.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "LeftCell.h"

@interface LeftCell ()

{
    UIView *maskLine;
    UIView *hLine;
}

@end

@implementation LeftCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = COLORA(255, 255, 255, 1);
        self.textLabel.font = DefaultFont(17);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        maskLine = [[UIView alloc] initWithFrame:CGRectMake(2, 0, 3, [LeftCell heightForCell]-3)];
        maskLine.backgroundColor = ThemeColor;
        maskLine.hidden = YES;
        [self addSubview:maskLine];
        
        hLine = [[UIView alloc] initWithFrame:CGRectMake(0, [LeftCell heightForCell]-3, ScreenSize.width, 3)];
        hLine.backgroundColor = COLOR(30, 29, 29);
        [self addSubview:hLine];
    }
    return  self;
}

-(void)fillData:(id)data selected:(BOOL)isSel
{
    self.textLabel.text = data;
    if (isSel) {
        maskLine.hidden = NO;
        self.textLabel.textColor = ThemeColor;
    } else {
        maskLine.hidden = YES;
        self.textLabel.textColor = [UIColor whiteColor];
    }
}

+(CGFloat)heightForCell
{
    return 40;
}

@end
