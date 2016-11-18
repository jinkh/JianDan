//
//  ShareView.m
//  DemoApp
//
//  Created by jinkh on 15/12/17.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#import "ShareView.h"
#import "UMSocial.h"
#import "FLAnimatedImage.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "CommentBarView.h"
#import "AppStoreManager.h"

#define LineCount 5
#define ItemWidth ScreenSize.width/LineCount
#define ItemHeight 80

@interface ShareView ()<UMSocialUIDelegate>

{
    __weak id shareData;
    UIView *bgView;
}

@end

@implementation ShareView

-(void)dealloc
{
    NSLog(@"release class:%@",NSStringFromClass([self class]));
}
-(instancetype)initWithData:(id)data
{
    if (self = [super init]) {
        shareData = data;
        
        [UMSocialControllerService defaultControllerService].socialUIDelegate = self;

        NSMutableArray *titiles = [NSMutableArray arrayWithArray:@[@"微信好友",@"微信朋友圈",@"QQ",@"QQ空间",@"新浪微博",@"收藏"]];
        NSMutableArray *images = [NSMutableArray arrayWithArray:@[@"weixin",@"share_pengyou", @"QQ",@"QQZone", @"sinaWeibo",@"favorite"]];
        NSMutableArray *selectImages = [NSMutableArray arrayWithArray:@[@"weixin",@"share_pengyou", @"QQ",@"QQZone", @"sinaWeibo",@"favorited"]];
        
        if ([AppStoreManager isInReview] ) {
            [titiles removeLastObject];
            [images removeLastObject];
            [selectImages removeLastObject];
        }
        if ([shareData isKindOfClass:[ArticleModel class]]) {
            [titiles addObject:@"复制链接"];
            [images addObject:@"copyLink"];
            [selectImages addObject:@"copyLink"];
        } else if ([shareData isKindOfClass:[PictureModel class]]) {
            [titiles addObject:@"保存图片"];
            [images addObject:@"download"];
            [selectImages addObject:@"copyLink"];
        } else if ([shareData isKindOfClass:[JokeModel class]]) {
            [titiles addObject:@"复制文本"];
            [images addObject:@"copyLink"];
            [selectImages addObject:@"copyLink"];
        } else if ([shareData isKindOfClass:[VideoModel class]]) {
            [titiles addObject:@"复制链接"];
            [images addObject:@"copyLink"];
            [selectImages addObject:@"copyLink"];
        }
        
        [titiles addObject:@"举报"];
        [images addObject:@"report"];
        [selectImages addObject:@"copyLink"];
        
        self.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
        self.backgroundColor = COLORA(0, 0, 0, .5);
        self.userInteractionEnabled = YES;
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
//        [self addGestureRecognizer:tap];
        
        bgView = [[UIView alloc] initWithFrame:CGRectZero];
        bgView.dk_backgroundColorPicker  = Cell_Bg;
        [self addSubview:bgView];
        
        CGFloat offY = 10;
        CGFloat offX = 0;
        for (int i = 0; i < titiles.count; i++) {
            if (i > (LineCount-1)) {
                offY = ItemHeight+20;
            } else{
                offY = 10;
            }
        
            if (i > (LineCount-1)) {
                offX = ItemWidth*(i-LineCount);
            } else {
                offX = ItemWidth*i;
            }
            CGRect frame = CGRectMake(offX, offY, ItemWidth, ItemHeight);
            UIButton *btn = [[UIButton alloc] initWithFrame:frame];
            btn.tag = i;
            btn.clipsToBounds = YES;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = DefaultFont(12);
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn dk_setTitleColorPicker:Text_Title forState:UIControlStateNormal];
            [btn setTitle: [titiles objectAtIndex:i] forState:UIControlStateNormal];
            [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [btn setImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:[selectImages objectAtIndex:i]] forState:UIControlStateSelected];
            CGFloat titleLabelWidth = btn.titleLabel.frame.size.width;
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.frame.size.width, -60, 0)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, -titleLabelWidth)];
            btn.imageView.backgroundColor = COLOR(255, 255, 255);
            btn.imageView.layer.cornerRadius = btn.imageView.bounds.size.height*.5;
            btn.imageView.layer.masksToBounds = YES;
    
            
            [bgView addSubview:btn];
            
            //收藏
            if (i == 5) {
                if ([shareData isKindOfClass:[ArticleModel class]]) {
                    if ([ArticleViewModel isFavWithModel:shareData]) {
                        btn.selected = YES;
                    } else {
                        btn.selected = NO;
                    }
                } else if ([shareData isKindOfClass:[PictureModel class]]) {
                    if ([PictureViewModel isFavWithModel:shareData withType:((PictureModel*)data).comment_type]) {
                        btn.selected = YES;
                    } else {
                        btn.selected = NO;
                    }
                } else if ([shareData isKindOfClass:[JokeModel class]]) {
                    if ([JokeViewModel isFavWithModel:shareData]) {
                        btn.selected = YES;
                    } else {
                        btn.selected = NO;
                    }
                } else if ([shareData isKindOfClass:[VideoModel class]]) {
                    if ([VideoViewModel isFavWithModel:shareData]) {
                        btn.selected = YES;
                    } else {
                        btn.selected = NO;
                    }
                }
            }
        }
        
        offY = offY+ItemHeight+10+5;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, offY, ScreenSize.width-30, 1)];
        line.dk_backgroundColorPicker = Sep_Bg;
        [bgView addSubview:line];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, offY, ScreenSize.width, 50)];
        [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn dk_setTitleColorPicker:Text_Title forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = DefaultFont(18);
        [bgView addSubview:cancelBtn];
        
        offY = offY+50;
        
        bgView.frame = CGRectMake(0, offY, ScreenSize.width, offY);
    }
    return self;
}

-(void)shareAction:(UIButton *)sender
{
    [ShareView goShareWithData:shareData withIndex:sender.tag];
    [self dismissAnimate:YES];
}

-(void)showAnimate:(BOOL)anim
{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    if (anim) {
        self.alpha = 0;
        bgView.frame = CGRectMake(0, ScreenSize.height, ScreenSize.width, bgView.bounds.size.height);
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1;
            bgView.frame = CGRectMake(0, ScreenSize.height-bgView.bounds.size.height, ScreenSize.width, bgView.bounds.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
    }

}

-(void)dismissAnimate:(BOOL)anim
{
    if (anim) {
        self.alpha = 1;
        bgView.frame = CGRectMake(0, ScreenSize.height-bgView.bounds.size.height, ScreenSize.width, bgView.bounds.size.height);
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 0;
            bgView.frame = CGRectMake(0, ScreenSize.height, ScreenSize.width, bgView.bounds.size.height);
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [bgView removeFromSuperview];
        }];
    } else {
        [self removeFromSuperview];
        [bgView removeFromSuperview];
    }
}

-(void)dismiss
{
    [self dismissAnimate:YES];
}

+(void)goShareWithData:(id)data withIndex:(NSInteger)index
{
    if (data == nil) {
        return;
    }
    UMSocialUrlResource *urlResource = nil;
    NSString *content = nil;
    UIImage *image = nil;
    NSData *imageData;
    NSString *copyUrl = @"";
    NSString *copyContent = @"";
    NSString *reportId = @"";
    
    if ([data isKindOfClass:[ArticleModel class]]) {
        
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
        
        [UMSocialData defaultData].extConfig.qqData.url = ((ArticleModel *)data).url;
        [UMSocialData defaultData].extConfig.qzoneData.url = ((ArticleModel *)data).url;
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url =((ArticleModel *)data).url;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url =  ((ArticleModel *)data).url;
        
        
        urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:((ArticleModel *)data).url];
        content = ((ArticleModel *)data).title;
        image = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:((ArticleModel *)data).thumb_c];
        if (image == nil) {
            image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:((ArticleModel *)data).thumb_c];
        }
        if (image == nil) {
            image = [UIImage imageNamed:@"user_icon_default"];
        }
        copyUrl = ((ArticleModel *)data).url;
        reportId = ((ArticleModel *)data).id;
        
        
        if (index == 4) {
            content = [NSString stringWithFormat:@"%@ %@", content, ((ArticleModel *)data).url];
        }
        
    } else if ([data isKindOfClass:[PictureModel class]]) {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
        
        [UMSocialData defaultData].extConfig.qqData.url = nil;
        [UMSocialData defaultData].extConfig.qzoneData.url = nil;
        
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = nil;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = nil;
        
        NSArray *pictures = ((PictureModel *)data).pics;
        if (pictures.count > 1) {
            //多图和合成
            CGSize size = CGSizeZero;
            for (PictureSourceModel *item in pictures) {
                size.width = [item.picWidth integerValue];
                size.height =  size.height+[item.picHeight integerValue];
            }
            
            UIGraphicsBeginImageContext(size);
            CGFloat offY = 0;
            for (PictureSourceModel *item in pictures) {
                UIImage *img = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:item.url];
                if (img == nil) {
                    img = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:item.url];
                }
                if (img) {
                    [img drawInRect:CGRectMake(0, offY, size.width, [item.picHeight integerValue])];
                    offY = offY+[item.picHeight integerValue];
                }
            }
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:nil];
        } else {
            UIImage *img = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:((PictureSourceModel *)pictures.firstObject).url];
            if (img == nil) {
                img = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:((PictureSourceModel *)pictures.firstObject).url];
            }
            image = img;
            
            if ([image isKindOfClass:[FLAnimatedImage class]]) {
                //朋友圈不支持gif
                if (index == 0) {
                    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeEmotion;
                }
            }
        }
        
        content = nil;
        reportId = ((PictureModel *)data).comment_ID;
        
    } else if ([data isKindOfClass:[JokeModel class]]) {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
        
        [UMSocialData defaultData].extConfig.qqData.url = nil;
        [UMSocialData defaultData].extConfig.qzoneData.url = nil;
        
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = nil;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = nil;
        
        urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:nil];
        content = ((JokeModel *)data).comment_content;
        if (index == 4) {
            //微博限制140汉字
            NSInteger length = content.length;
            if (length > 140) {
                content = [content substringToIndex:137];
                content = [NSString stringWithFormat:@"%@...", content];
            }
        }
        image = nil;
        copyContent = ((JokeModel *)data).comment_content;
        reportId = ((JokeModel *)data).comment_ID;
    } else if ([data isKindOfClass:[VideoModel class]]) {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
        
        [UMSocialData defaultData].extConfig.qqData.url = ((VideoModel *)data).video_uri;
        [UMSocialData defaultData].extConfig.qzoneData.url = ((VideoModel *)data).video_uri;
        
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = ((VideoModel *)data).video_uri;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = ((VideoModel *)data).video_uri;
        
        urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:nil];
        content = [NSString stringWithFormat:@"%@", ((VideoModel *)data).text];
        UIImage *img = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:((VideoModel *)data).profile_image];
        if (img == nil) {
            img = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:((VideoModel *)data).profile_image];
        }
        if (img == nil) {
            img = [UIImage imageNamed:@"user_icon_default"];
        }
        image = img;
        
        copyContent = @"";
        reportId = ((VideoModel *)data).id;
        copyUrl = ((VideoModel *)data).video_uri;
        
        if (index == 4) {
            content = [NSString stringWithFormat:@"%@ %@", content, ((VideoModel *)data).video_uri];
        }
    }
    
    if ([image isKindOfClass:[FLAnimatedImage class]]) {
        imageData = ((FLAnimatedImage*)image).data;
    } else {
        imageData = UIImageJPEGRepresentation(image, 1);
    }
    
    if (index == 3) {
        if (image == nil) {
            image = [UIImage imageNamed:@"user_icon_default"];
            imageData = UIImageJPEGRepresentation(image, 1);
        }
    }
    
    switch (index) {
        case 0:
        {
            //微信好友
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:imageData location:nil urlResource:urlResource  presentedController:[UIApplication sharedApplication].keyWindow.rootViewController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [[ToastHelper sharedToastHelper] toast:@"分享成功" afterDelay:1];
                } else {
                    [[ToastHelper sharedToastHelper] toast:@"分享失败" afterDelay:1];
                }
            }];
        }
            break;
        case 1:
        {
            //微信朋友圈
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:imageData location:nil urlResource:urlResource presentedController:[UIApplication sharedApplication].keyWindow.rootViewController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [[ToastHelper sharedToastHelper] toast:@"分享成功" afterDelay:1];
                } else {
                    [[ToastHelper sharedToastHelper] toast:@"分享失败" afterDelay:1];
                }
            }];
        }
            break;
        case 2:
        {
            //QQ
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:imageData location:nil urlResource:urlResource  presentedController:[UIApplication sharedApplication].keyWindow.rootViewController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [[ToastHelper sharedToastHelper] toast:@"分享成功" afterDelay:1];
                } else {
                    [[ToastHelper sharedToastHelper] toast:@"分享失败" afterDelay:1];
                }
            }];
        }
            break;
        case 3:
        {
            //QQ空间
            if (image == nil) {
                image = [UIImage imageNamed:@"user_icon_default"];
            }
            if (content == nil) {
                content = @"煎蛋，地球上没有新鲜事";
            }
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image:imageData location:nil urlResource:urlResource  presentedController:[UIApplication sharedApplication].keyWindow.rootViewController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [[ToastHelper sharedToastHelper] toast:@"分享成功" afterDelay:1];
                } else {
                    [[ToastHelper sharedToastHelper] toast:@"分享失败" afterDelay:1];
                }
            }];
        }
            break;
        case 4:
        {
            //新浪微博
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:content image:imageData location:nil urlResource:urlResource presentedController:[UIApplication sharedApplication].keyWindow.rootViewController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [[ToastHelper sharedToastHelper] toast:@"分享成功" afterDelay:1];
                } else {
                    [[ToastHelper sharedToastHelper] toast:@"分享失败" afterDelay:1];
                }
            }];
        }
            break;
        case 5:
        {
            if ([data isKindOfClass:[ArticleModel class]]) {
                if ([ArticleViewModel isFavWithModel:data]) {
                    [ArticleViewModel deleteFavWithModel:data];
                    [[ToastHelper sharedToastHelper] toast:@"取消收藏"];
                } else {
                    BOOL result = [ArticleViewModel saveFavWithModel:data];
                    if (result) {
                        [[ToastHelper sharedToastHelper] toast:@"收藏成功"];
                    } else {
                        [[ToastHelper sharedToastHelper] toast:@"收藏失败"];
                    }
                }
            } else if ([data isKindOfClass:[PictureModel class]]) {
                if ([PictureViewModel isFavWithModel:data withType:((PictureModel*)data).comment_type]) {
                    [PictureViewModel deleteFavWithModel:data withType:((PictureModel*)data).comment_type];
                    [[ToastHelper sharedToastHelper] toast:@"取消收藏"];
                } else {
                    BOOL result = [PictureViewModel saveFavWithModel:data withType:((PictureModel*)data).comment_type];
                    if (result) {
                        [[ToastHelper sharedToastHelper] toast:@"收藏成功"];
                    } else {
                        [[ToastHelper sharedToastHelper] toast:@"收藏失败"];
                    }
                }
            } else if ([data isKindOfClass:[JokeModel class]]) {
                if ([JokeViewModel isFavWithModel:data]) {
                    [JokeViewModel deleteFavWithModel:data];
                    [[ToastHelper sharedToastHelper] toast:@"取消收藏"];
                } else {
                   BOOL result = [JokeViewModel saveFavWithModel:data];
                    if (result) {
                        [[ToastHelper sharedToastHelper] toast:@"收藏成功"];
                    } else {
                        [[ToastHelper sharedToastHelper] toast:@"收藏失败"];
                    }
                }
            } else if ([data isKindOfClass:[VideoModel class]]) {
                if ([VideoViewModel isFavWithModel:data]) {
                    [VideoViewModel deleteFavWithModel:data];
                    [[ToastHelper sharedToastHelper] toast:@"取消收藏"];
                } else {
                    BOOL result = [VideoViewModel saveFavWithModel:data];
                    if (result) {
                        [[ToastHelper sharedToastHelper] toast:@"收藏成功"];
                    } else {
                        [[ToastHelper sharedToastHelper] toast:@"收藏失败"];
                    }
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:Rerfresh_CommednBar_Notify object:data];
        }
            break;
        case 6:
        {
            
            if ([data isKindOfClass:[ArticleModel class]]) {
                //复制链接
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = copyUrl;
                [[ToastHelper sharedToastHelper] toast:@"复制成功"];
            } else if ([data isKindOfClass:[PictureModel class]]) {
                //保存图片
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library writeImageDataToSavedPhotosAlbum:imageData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                    
                    NSString *message = @"保存到相册失败";
                    if (!error) {
                        message = @"保存到相册成功";
                    }
                    [[ToastHelper sharedToastHelper] toast:message];
                }] ;
                
                //UIImageWriteToSavedPhotosAlbum(image, TheAppDelegate, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
                
            } else if ([data isKindOfClass:[JokeModel class]]) {
                //复制文本
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = copyContent;
                [[ToastHelper sharedToastHelper] toast:@"复制成功"];
            } else if ([data isKindOfClass:[VideoModel class]]) {
                //复制链接
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = copyUrl;
                [[ToastHelper sharedToastHelper] toast:@"复制成功"];
            }
        }
            break;
        case 7:
        {
            //举报
            [TheAppDelegate reportWithArticleId:reportId];
        }
            break;
        default:
            break;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissAnimate:YES];
}



@end
