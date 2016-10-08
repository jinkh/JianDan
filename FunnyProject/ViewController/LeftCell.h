//
//  LeftCell.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/13.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftCell : UITableViewCell

-(void)fillData:(id)data selected:(BOOL)isSel;

+(CGFloat)heightForCell;

@end
