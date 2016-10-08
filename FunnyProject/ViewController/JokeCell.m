//
//  JokeCell.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/12.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "JokeCell.h"

#import "NSDate+Extension.h"
#import "NSDate+DateTools.h"
#import "NSString+Size.h"
#import "ShareView.h"

@interface JokeCell ()
{
    
    UIView *bgView;
    UILabel *contentLabel;
    
    UILabel *describLabel;
    
    UILabel *commentLabel;
    
    JokeModel *model;
    
}
@end

@implementation JokeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.drawsAsynchronously = YES;
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, ScreenSize.width-10, 0)];
        bgView.dk_backgroundColorPicker  = Cell_Bg;
        bgView.layer.borderColor = COLORA(0, 0, 0, .2).CGColor;
        bgView.layer.borderWidth = .6;
        [self addSubview:bgView];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, bgView.frame.size.width-10, 0)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = DefaultFont(16);
        contentLabel.dk_textColorPicker = Text_Title;
        contentLabel.numberOfLines = 0;
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [bgView addSubview:contentLabel];
        
        describLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, contentLabel.frame.size.height+contentLabel.frame.origin.y, bgView.frame.size.width-10, 30)];
        describLabel.backgroundColor = [UIColor clearColor];
        describLabel.font = DefaultFont(13);
        describLabel.textColor = COLOR(153, 153, 153);
        describLabel.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:describLabel];
        
        commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, contentLabel.frame.size.height+contentLabel.frame.origin.y, bgView.frame.size.width-10, 30)];
        commentLabel.backgroundColor = [UIColor clearColor];
        commentLabel.font = IconFont(13);
        commentLabel.textColor = COLOR(153, 153, 153);
        commentLabel.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:commentLabel];
        
        UILongPressGestureRecognizer *getsture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
        [bgView addGestureRecognizer:getsture];
        
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

+(CGFloat)heightForCellWithData:(id)data
{
    JokeModel *item = data;
    if (item.textHeight) {
        return [item.textHeight integerValue]+35+10;
    }
    return 35+10;
}

-(void)fillData:(id)data
{
    model = data;
    NSDate *date = [NSDate dateWithString:model.comment_date format:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [date timeAgoSinceNow];
    describLabel.text = [NSString stringWithFormat:@"%@ @%@", model.comment_author, time];
    commentLabel.text = [NSString stringWithFormat:@"\U0000e717 %@   |   \U0000e716 %@   |   \U0000e69f %@  ",model.vote_positive, model.vote_negative, model.comment_count];
    
    contentLabel.attributedText = model.attributedString;
    [commentLabel sizeToFit];
    
    

    bgView.frame = CGRectMake(5, 0, ScreenSize.width-10, [model.textHeight integerValue]+35);
    contentLabel.frame = CGRectMake(5, 5, bgView.frame.size.width-10, [model.textHeight integerValue]);
    describLabel.frame = CGRectMake(5, contentLabel.frame.size.height+contentLabel.frame.origin.y, bgView.frame.size.width-10, 30);
    commentLabel.frame = CGRectMake(5, contentLabel.frame.size.height+contentLabel.frame.origin.y, bgView.frame.size.width-10, 30);
}

@end
