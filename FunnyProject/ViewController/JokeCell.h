//
//  JokeCell.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/12.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JokeCell : UITableViewCell

-(void)fillData:(id)data;

+(CGFloat)heightForCellWithData:(id)data;

@end
