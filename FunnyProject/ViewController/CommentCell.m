//
//  CommentCell.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/14.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "CommentCell.h"
#import "MWPhotoBrowser.h"
#import "QBPopupMenu.h"
#import "QBPlasticPopupMenu.h"
#import "CommentBarView.h"
#import "CATCommon.h"


@interface CommentCell ()

{
    UIImageView *iconView;
    
    UILabel *nameLabel;
    
    UILabel *commentLabel;
    
    UIView *lineView;
    
    UIImage *userHoldImg;
    
    __weak id myData;
}

@end


@implementation CommentCell

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
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [iconView setBackgroundColor:[UIColor clearColor]];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:iconView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, ScreenSize.width-60, 20)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = FONT(14);
        nameLabel.dk_textColorPicker  =Text_Title;
        nameLabel.numberOfLines = 1;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:nameLabel];
        
        commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 35, ScreenSize.width-60, 20)];
        commentLabel.backgroundColor = [UIColor clearColor];
        commentLabel.font = DefaultFont(14);
        commentLabel.numberOfLines = 0;
        commentLabel.textAlignment = NSTextAlignmentLeft;
        commentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        commentLabel.textColor = COLORA(34, 34, 34, .7);
        commentLabel.textAlignment = NSTextAlignmentLeft;
        commentLabel.userInteractionEnabled  =YES;
        [self addSubview:commentLabel];
        
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 80-1, ScreenSize.width-60, 1)];
        lineView.dk_backgroundColorPicker = Sep_Bg;
        [self addSubview:lineView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickComment:)];
        [commentLabel addGestureRecognizer:gesture];
        
        UIImage *img = [UIImage imageNamed:@"user_icon_default"];
        userHoldImg = [CATCommon makeCircleCornerImage:img];
    }
    return self;
}

-(void)fillData:(id)data
{
    myData = data;
    if ([data isKindOfClass:[PicCommentModel class]]) {
        PicCommentModel *model = data;
        nameLabel.text = model.author_name;
        commentLabel.text = nil;
        commentLabel.attributedText = model.attributedString;
  
        //优化圆角卡顿
        UIImage *img = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:model.author_avatar_url];
        if (img) {
            iconView.image = img;
        } else {
            __weak typeof(iconView) weakIconView = iconView;
            [iconView sd_setImageWithURL:[NSURL URLWithString:model.author_avatar_url] placeholderImage:userHoldImg options:SDWebImageCacheMemoryOnly|SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    image = [CATCommon makeCircleCornerImage:image];
                    weakIconView.image = image;
                    [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL.absoluteString toDisk:YES];
                }
            }];
        }
        
        lineView.frame = CGRectMake(50, [CommentCell heightForCellWithData:data]-1, ScreenSize.width-60, 1);
        commentLabel.frame = CGRectMake(50, 35, ScreenSize.width-60, [model.msgHeight integerValue]);
        [commentLabel sizeToFit];
         commentLabel.frame = CGRectMake(commentLabel.frame.origin.x, commentLabel.frame.origin.y, ScreenSize.width-60, commentLabel.frame.size.height);
    } else {
         ArticleCommentModel *model = data;
        nameLabel.text = model.name;
        commentLabel.text = nil;
        commentLabel.attributedText = model.attributedString;
        
        //文章评论没有头像，使用默认的头像
        iconView.image = userHoldImg;
  
        lineView.frame = CGRectMake(50, [CommentCell heightForCellWithData:data]-1, ScreenSize.width-60, 1);
        commentLabel.frame = CGRectMake(50, 35, ScreenSize.width-60, [model.msgHeight integerValue]);
        [commentLabel sizeToFit];
        commentLabel.frame = CGRectMake(commentLabel.frame.origin.x, commentLabel.frame.origin.y, ScreenSize.width-60, commentLabel.frame.size.height);
    }
}

+(CGFloat)heightForCellWithData:(id)data
{
    if ([data isKindOfClass:[PicCommentModel class]]) {
        PicCommentModel *model = data;
        return [model.msgHeight integerValue]+20+25;
    } else {
        ArticleCommentModel *model = data;
        return [model.msgHeight integerValue]+20+25;
    }

}

-(void)clickComment:(UITapGestureRecognizer *)gesture
{
    __block BOOL haveResponsed = NO;
    __weak typeof(self) weakSelf = self;
    
    CGPoint pos = [gesture locationInView:gesture.view];
    
    __weak typeof(commentLabel) wealCommentLabel = commentLabel;
    
    [commentLabel.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, commentLabel.attributedText.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            NSTextAttachment *ment = value;
            NSString *beforeStr = [wealCommentLabel.attributedText.string substringWithRange:NSMakeRange(0, range.location)];
            CGSize strSize =  [beforeStr boundingRectWithSize:CGSizeMake(wealCommentLabel.bounds.size.width, CGFLOAT_MAX)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                                      attributes:[wealCommentLabel.attributedText attributesAtIndex:0 effectiveRange:NULL]
                                                                         context:nil].size;
            CGRect mentRect = CGRectMake(0, strSize.height-20, 100, 100);
            
            if (CGRectContainsPoint(mentRect, pos)) {
                
                NSData *data = ment.fileWrapper.regularFileContents;
                UIImage *img = [UIImage imageWithData:data];
                
                NSMutableArray *arry = [NSMutableArray arrayWithObject:img];
                [weakSelf showPhotoBrowserWithImages:arry];
                haveResponsed = YES;
                *stop = YES;
            }
        }
    }];
    
    //不是查看大图，就是点击显示菜单
    if (haveResponsed == NO) {
        QBPopupMenuItem *item = [QBPopupMenuItem itemWithTitle:@"复制" target:self action:@selector(copyAction:)];
        QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"回复"  target:self action:@selector(replyAction:)];
        
        CGRect rectInSuperview = [self convertRect:commentLabel.frame toView:[UIApplication sharedApplication].keyWindow];
        
        CGPoint location = [gesture locationInView:gesture.view];
        
        QBPlasticPopupMenu *plasticPopupMenu = [[QBPlasticPopupMenu alloc] initWithItems:@[item, item2]];
        plasticPopupMenu.height = 40;
        [plasticPopupMenu showInView:[UIApplication sharedApplication].keyWindow targetRect:CGRectMake(location.x+commentLabel.frame.origin.x-50, rectInSuperview.origin.y, 100, rectInSuperview.size.height) animated:YES];
    }
    
}
-(void)copyAction:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:commentLabel.attributedText.string];
    [[ToastHelper sharedToastHelper] toast:@"复制成功"];
}

-(void)replyAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Comment_Child_Notify object:myData userInfo:nil];
}

-(void)showPhotoBrowserWithImages:(NSArray *)images
{
    NSMutableArray *array = [NSMutableArray array];
    for (UIImage *img in images) {
        MWPhoto *photo = [[MWPhoto alloc] initWithImage:img];
        [array addObject:photo];
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:array];
    browser.displayActionButton = YES;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    [browser setCurrentPhotoIndex:0];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [TheAppDelegate.rootNavigationController presentViewController:nc animated:YES completion:nil];
}

@end
