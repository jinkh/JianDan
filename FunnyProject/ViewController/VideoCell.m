//
//  VideoCell.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/12.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "VideoCell.h"
#import "ZHShortPlayerView.h"

#import "NSDate+Extension.h"
#import "NSDate+DateTools.h"
#import "ShareView.h"

@interface VideoCell()
{
    ZHShortPlayerView *videoView;
    
    UIView *bgView;
    
    UIImageView *coverImageView;
    
    UIView *coverMask;
    
    UIImageView *indictorImage;
    
    UILabel *nameLabel;
    
    UILabel *describLabel;
    
    UILabel *commentLabel;
    
    VideoModel *model;
}
@end

@implementation VideoCell

-(void)dealloc
{
    ReleaseClass;
    // 重要, 必须对videoView进行destory，否则内存无法释放
    [videoView destroy];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, MIN(ScreenSize.width, ScreenSize.height)-10, (MIN(ScreenSize.width, ScreenSize.height)-10)/16.0f*9.0f+40+30)];
        bgView.dk_backgroundColorPicker  = Cell_Bg;
        bgView.layer.borderColor = COLORA(0, 0, 0, .2).CGColor;
        bgView.layer.borderWidth = .6;
        [self addSubview:bgView];
    
        
        coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, (MIN(ScreenSize.width, ScreenSize.height)-10)/16.0f*9)];
        coverImageView.backgroundColor = [UIColor clearColor];
        coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        coverImageView.clipsToBounds = YES;
        [bgView addSubview:coverImageView];
        
        coverMask = [[UIView alloc] initWithFrame:coverImageView.bounds];
        coverMask.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.12];
        coverMask.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [bgView addSubview:coverMask];
        
        indictorImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"play_btn_icon"]];
        indictorImage.hidden = NO;
        indictorImage.frame = CGRectMake(coverMask.bounds.size.width*.5-12.5, coverMask.bounds.size.height*.5-12.5, 25, 25);
        indictorImage.backgroundColor = [UIColor clearColor];
        [bgView addSubview:indictorImage];
        
        videoView = [[ZHShortPlayerView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, (MIN(ScreenSize.width, ScreenSize.height)-10)/16.0f*9)
                                              withIdentifier:reuseIdentifier];
        [bgView addSubview:videoView];
        
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, videoView.frame.size.height+videoView.frame.origin.y, videoView.frame.size.width-10, 40)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = DefaultFont(15);
        nameLabel.dk_textColorPicker = Text_Title;
        nameLabel.numberOfLines = 1;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [bgView addSubview:nameLabel];
        
        
        
        describLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, nameLabel.frame.size.height+nameLabel.frame.origin.y, videoView.frame.size.width-10, 30)];
        describLabel.backgroundColor = [UIColor clearColor];
        describLabel.font = DefaultFont(12);
        describLabel.textColor = COLOR(153, 153, 153);
        describLabel.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:describLabel];
        
        commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, nameLabel.frame.size.height+nameLabel.frame.origin.y, videoView.frame.size.width-10, 30)];
        commentLabel.backgroundColor = [UIColor clearColor];
        commentLabel.font = IconFont(12);
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

-(void)fillData:(id)data
{
    model = data;
    [videoView setVideoUrl:model.video_uri];
    [coverImageView sd_setImageWithURL:[NSURL URLWithString:model.profile_image]];
    NSDate *date = [NSDate dateWithString:model.create_time format:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [date timeAgoSinceNow];
    describLabel.text = [NSString stringWithFormat:@"%@ @%@", model.name, time];
    commentLabel.text = [NSString stringWithFormat:@"\U0000e717 %@   |   \U0000e716 %@",model.love, model.hate  ];
    
    model.text = [model.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    model.text = [model.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    nameLabel.text = model.text;
}

+(CGFloat)heightForCell
{
    return (MIN(ScreenSize.width, ScreenSize.height)-10)/16.0f*9+40+30+10;
}
@end
