//
//  ArticleCell.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/11.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ArticleCell.h"
#import "NSDate+Extension.h"
#import "NSDate+DateTools.h"
#import "NSString+Size.h"
#import "ShareView.h"

@interface ArticleCell ()
{
    UIImageView *iconView;
    
    UILabel *nameLabel;
    
    UILabel *describLabel;
    
    UILabel *commentLabel;
    
    UIView *lineView;
    
    ArticleModel *model;
}
@end

@implementation ArticleCell

-(void)dealloc
{
    ReleaseClass;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.drawsAsynchronously = YES;
        self.dk_backgroundColorPicker  = Cell_Bg;
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 55, 55)];
        [iconView setBackgroundColor:[UIColor lightGrayColor]];
        iconView.clipsToBounds = YES;
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:iconView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, ScreenSize.width-80, 25)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = DefaultFont(16);
        nameLabel.dk_textColorPicker = Text_Title;
        nameLabel.numberOfLines = 1;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:nameLabel];
        
        describLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 50, ScreenSize.width-80, 15)];
        describLabel.backgroundColor = [UIColor clearColor];
        describLabel.font = DefaultFont(13);
        describLabel.textColor = COLOR(153, 153, 153);
        describLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:describLabel];
        
        commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 50, ScreenSize.width-85, 15)];
        commentLabel.backgroundColor = [UIColor clearColor];
        commentLabel.font = DefaultFont(13);
        commentLabel.textColor = COLOR(153, 153, 153);
        commentLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:commentLabel];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 75-1, ScreenSize.width-20, 1)];
        lineView.dk_backgroundColorPicker = Sep_Bg;
        [self addSubview:lineView];
        
        UILongPressGestureRecognizer *getsture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
        [self addGestureRecognizer:getsture];
    }
    return self;
}

-(void)longAction:(UILongPressGestureRecognizer *)getsure
{
    if (getsure.state == UIGestureRecognizerStateBegan) {
        ShareView *share = [[ShareView alloc] initWithData:model];
        [share showAnimate:YES];
    }
    
}

+(CGFloat)heightForCell
{
    return 75;
}

-(void)fillData:(id)data
{
    model = data;
    [iconView sd_setImageWithURL:[NSURL URLWithString:model.thumb_c]];
    nameLabel.text = model.title;
    NSDate *date = [NSDate dateWithString:model.date format:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [date timeAgoSinceNow];
    describLabel.text = [NSString stringWithFormat:@"%@ @%@", model.author_name, time];
    commentLabel.text = [NSString stringWithFormat:@"%ld评论", model.comment_count];
    
//    CGSize cSize = [nameLabel.text sizeWithFont:nameLabel.font constrainedToWidth:nameLabel.frame.size.width];
//    CGSize oneLineSize = [@"一行高度" sizeWithFont:nameLabel.font constrainedToWidth:nameLabel.frame.size.width];
//    if (cSize.height > oneLineSize.height*2) {
//        cSize.height = oneLineSize.height*2;
//    }
//    nameLabel.frame = CGRectMake(70, 10, ScreenSize.width-80, cSize.height);
    if ([model.isRead integerValue]) {
        nameLabel.alpha = .6;
        commentLabel.alpha = .6;
        describLabel.alpha = .6;
    } else {
        nameLabel.alpha = 1;
        commentLabel.alpha = 1;
        describLabel.alpha = 1;
    }
}

@end
