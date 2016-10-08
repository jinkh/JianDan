//
//  DonationController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/28.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "DonationController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface DonationController()

{
    UILabel *infoLabel;
    
    UIView *bgView;
    
    UIImageView *imageView;
    
    UIScrollView *bgScroll;
}

@end


@implementation DonationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = Controller_Bg;
    self.zh_showCustomNav = YES;
    self.zh_title = @"捐款计划";
    
    
    bgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenSize.width, ScreenSize.height-64)];
    bgScroll.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:bgScroll];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, bgScroll.frame.size.width-20, bgScroll.frame.size.height-20)];
    bgView.dk_backgroundColorPicker = Cell_Bg;
    bgView.layer.borderWidth  = .6;
    bgView.layer.borderColor = COLORA(0, 0, 0, .2).CGColor;
    [bgScroll addSubview:bgView];
    
    infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, bgView.frame.size.width-60, 150)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont systemFontOfSize:16];
    infoLabel.dk_textColorPicker  = Text_Title;
    infoLabel.numberOfLines = 0;
    [bgView addSubview:infoLabel];
    
    NSString *str = @"捐款方式（支付宝） \n 1、长按图片保存到相册 \n 2、打开手机支付宝 \n 3、选择扫一扫 \n 4、从相册选择二维码 \n  \n 注意事项 \n -捐赠计划基于自愿原则 \n -该捐赠计划和煎蛋网无关 \n -收到款项只用于APP继续开发";

    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.paragraphSpacing = 4;
    NSMutableDictionary *attDic = [NSMutableDictionary dictionary];
    [attDic setObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
    [attDic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:attDic];
    
    NSRange rangeTitleOne = [str rangeOfString:@"捐款方式（支付宝）"];
    if (rangeTitleOne.location != NSNotFound) {
        
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18]
                                       range:rangeTitleOne];
    }
    NSRange rangeTitleTwo = [str rangeOfString:@"注意事项"];
    if (rangeTitleTwo.location != NSNotFound) {
        
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18]
                             range:rangeTitleTwo];
    }
    
    
    infoLabel.attributedText = attributeStr;
    [infoLabel sizeToFit];
    infoLabel.center = CGPointMake(bgView.frame.size.width*.5, infoLabel.center.y);
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.frame.size.width*.5-75, infoLabel.frame.origin.y+infoLabel.frame.size.height+5, 150, 150)];
    imageView.image = [UIImage imageNamed:@"zhifubao"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [bgView addSubview:imageView];
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
    [imageView addGestureRecognizer:gesture];
    
    bgView.frame = CGRectMake(10, 10, bgView.frame.size.width, imageView.frame.origin.y+imageView.frame.size.height+10);
    
    CGFloat height = bgView.frame.origin.x+bgView.frame.size.height+10;
    if (height < bgScroll.bounds.size.height) {
        height = bgScroll.bounds.size.height+1;
    }
    bgScroll.contentSize = CGSizeMake(bgScroll.bounds.size.width, height);

}

-(void)saveImage:(UILongPressGestureRecognizer *)getsure
{
    if (getsure.state ==  UIGestureRecognizerStateBegan) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        NSData *imageData = UIImagePNGRepresentation(imageView.image);
        [library writeImageDataToSavedPhotosAlbum:imageData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            
            NSString *message = @"保存到相册失败";
            if (!error) {
                message = @"保存到相册成功";
            }
            [[ToastHelper sharedToastHelper] toast:message];
        }] ;
    }
}

@end
