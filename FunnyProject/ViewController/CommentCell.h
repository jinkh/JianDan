//
//  CommentCell.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/14.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CommentCell : UITableViewCell

-(void)fillData:(id)data;

+(CGFloat)heightForCellWithData:(id)data;

@end
