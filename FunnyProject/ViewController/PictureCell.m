//
//  PictureCell.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/11.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "PictureCell.h"

#import "NSDate+Extension.h"
#import "NSDate+DateTools.h"
#import "NSString+Size.h"
#import "FLAnimatedImageView+WebCache.h"
#import "ShareView.h"

@interface PictureCell ()
{
    FLAnimatedImageView *picView;
    
    UIView *bgView;
    
    UILabel *describLabel;
    
    UILabel *commentLabel;
    
    MRCircularProgressView *circularProgressView;
    
    PictureModel *model;

}
@end

@implementation PictureCell

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
        
        picView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, 0)];
        picView.dk_backgroundColorPicker  = Controller_Bg;
        picView.clipsToBounds = YES;
        picView.contentMode = UIViewContentModeScaleAspectFill;
        [bgView addSubview:picView];
        
        circularProgressView = [[MRCircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        circularProgressView.backgroundColor = [UIColor clearColor];
        circularProgressView.tag = 23456;
        circularProgressView.tintColor = ThemeColor;
        circularProgressView.center = CGPointMake(picView.frame.size.width*.5, picView.frame.size.height*.5);
        [picView addSubview:circularProgressView];

        
        describLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, picView.frame.size.height+picView.frame.origin.y, bgView.frame.size.width-10, 30)];
        describLabel.backgroundColor = [UIColor clearColor];
        describLabel.font = DefaultFont(13);
        describLabel.textColor = COLOR(153, 153, 153);
        describLabel.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:describLabel];
        
        commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, picView.frame.size.height+picView.frame.origin.y, bgView.frame.size.width-15, 30)];
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
    PictureModel *model = data;
    PictureSourceModel *item = model.pics.firstObject;
    if (item.picHeight && item.picWidth) {
        return [item.picHeight integerValue]+30+10;
    }
    return 30+10;
}

-(void)fillData:(id)data
{
    model = data;

    PictureSourceModel *item = model.pics.firstObject;
    
    circularProgressView.hidden = YES;
    __weak typeof(circularProgressView) weakCircularProgressView = circularProgressView;
    NSURL *url = [NSURL URLWithString:item.url];
    [picView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat progress = receivedSize/(CGFloat)expectedSize;
        if (progress < 0) {
            progress = 0;
        }
        weakCircularProgressView.hidden = NO;
        [weakCircularProgressView setProgress:progress animated:YES];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakCircularProgressView setProgress:1 animated:YES];
        weakCircularProgressView.hidden = YES;
    }];
    
    NSDate *date = [NSDate dateWithString:model.comment_date format:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [date timeAgoSinceNow];
    describLabel.text = [NSString stringWithFormat:@"%@ @%@", model.comment_author, time];
//    commentLabel.text = [NSString stringWithFormat:@"\U0000e717 %@   |   \U0000e716 %@   |   \U0000e69f %@  ",model.vote_positive, model.vote_negative, model.comment_count];
    commentLabel.text = [NSString stringWithFormat:@"\U0000e717 %@   |   \U0000e716 %@   ",model.vote_positive, model.vote_negative];
    
    bgView.frame = CGRectMake(5, 0, ScreenSize.width-10, [item.picHeight integerValue]+30);
    picView.frame = CGRectMake(0, 0, ScreenSize.width-10, [item.picHeight integerValue]);
    describLabel.frame = CGRectMake(5, picView.frame.size.height+picView.frame.origin.y, bgView.frame.size.width-10, 30);
    commentLabel.frame = CGRectMake(5, picView.frame.size.height+picView.frame.origin.y, bgView.frame.size.width-10, 30);
    circularProgressView.center = CGPointMake(picView.frame.size.width*.5, picView.frame.size.height*.5);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

@end
