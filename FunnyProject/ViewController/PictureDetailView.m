//
//  PictureDetailView.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/15.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "PictureDetailView.h"

#import "NSDate+Extension.h"
#import "NSDate+DateTools.h"
#import "FLAnimatedImageView+WebCache.h"
#import "CommentCell.h"
#import "ShareView.h"
#import "JTSImageInfo.h"
#import "JTSImageViewController.h"

@interface PictureDetailView ()<UITableViewDataSource, UITableViewDelegate>
{
    
    PictureModel *myData;
    
    UIView *headerView;
    UIView *footerView;
    NSMutableArray *commentArray;
    UITableView *myTableView;
    UIActivityIndicatorView *indicatorView;
    PicCommentViewModel *commentViewModel;
    NSMutableArray *picViewArray;
}

@end

@implementation PictureDetailView

-(void)dealloc
{
    ReleaseClass;
    for (FLAnimatedImageView *picView in picViewArray) {
        [picView sd_cancelCurrentImageLoad];
        [picView sd_cancelCurrentAnimationImagesLoad];
    }
}

-(instancetype)initWithFrame:(CGRect)frame withData:(id)data
{
    if (self = [super initWithFrame:frame]) {
        
        myData = data;
        
        picViewArray = [[NSMutableArray alloc] init];
        
        myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.scrollsToTop = NO;
        myTableView.showsVerticalScrollIndicator = YES;
        myTableView.backgroundColor = [UIColor clearColor];
        [self addSubview:myTableView];
        
        [self initHeaderAndFooter];
        
        commentArray = [[NSMutableArray alloc] init];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.frame = CGRectMake(0, headerView.bounds.size.height+5, ScreenSize.width, 30);
        indicatorView.hidesWhenStopped = YES;
        [indicatorView startAnimating];
        [myTableView addSubview:indicatorView];
        
        
        __weak typeof(self) weakSelf = self;
        commentViewModel = [[PicCommentViewModel alloc] initWithId:myData.comment_ID];
        [commentViewModel fetchCommentList:^(NetReturnValue *returnValue) {
            [weakSelf dealCommentWithValue:returnValue];
        }];
    }
    return self;
}

-(void)dealCommentWithValue:(NetReturnValue *)returnValue
{
    if (returnValue.finishType != REQUEST_FAILED) {
        commentArray = [NSMutableArray arrayWithArray:returnValue.data];
        [myTableView reloadData];
    }
    [indicatorView stopAnimating];
}

-(void)initHeaderAndFooter
{
    CGFloat offY = 0;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 0+40+15)];
    headerView.dk_backgroundColorPicker  = Cell_Bg;
    headerView.userInteractionEnabled = YES;
    for (PictureSourceModel *item in myData.pics) {
        NSInteger height = [item.picHeight integerValue]*ScreenSize.width/[item.picWidth integerValue];
        FLAnimatedImageView *picView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, offY, headerView.frame.size.width, height)];
        picView.dk_backgroundColorPicker  = Controller_Bg;
        picView.clipsToBounds = YES;
        picView.userInteractionEnabled = YES;
        picView.contentMode = UIViewContentModeScaleAspectFill;
        [headerView addSubview:picView];
        
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureClicked:)];
        [picView addGestureRecognizer:gesture];
        
        
        [picViewArray addObject:picView];
        
        MRCircularProgressView *circularProgressView = [[MRCircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        circularProgressView.backgroundColor = [UIColor clearColor];
        circularProgressView.tag = 23456;
        circularProgressView.hidden = YES;
        circularProgressView.tintColor = ThemeColor;
        circularProgressView.center = CGPointMake(picView.frame.size.width*.5, picView.frame.size.height*.5);
        [picView addSubview:circularProgressView];
        
        
        __weak typeof(picView) weakPicView = picView;
        NSURL *url = [NSURL URLWithString:item.url];
        [picView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            MRCircularProgressView *progressView = [weakPicView viewWithTag:23456];
            if (progressView) {
                CGFloat progress = receivedSize/(CGFloat)expectedSize;
                if (progress < 0) {
                    progress = 0;
                }
                [progressView setProgress:progress animated:YES];
                progressView.hidden = NO;
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            MRCircularProgressView *progressView = [weakPicView viewWithTag:23456];
            if (progressView) {
                [progressView setProgress:1 animated:YES];
                progressView.hidden = YES;
                
            }
        }];
        
        offY = offY+height;
    }
    headerView.frame = CGRectMake(0, 0, ScreenSize.width, headerView.frame.size.height+offY);
    
    UILabel *describLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, offY, headerView.frame.size.width-10, 40)];
    describLabel.backgroundColor = [UIColor clearColor];
    describLabel.font = DefaultFont(14);
    describLabel.textColor = COLOR(153, 153, 153);
    describLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:describLabel];
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, offY, headerView.frame.size.width-10, 40)];
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.font = IconFont(14);
    commentLabel.textColor = COLOR(153, 153, 153);
    commentLabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:commentLabel];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, commentLabel.frame.size.height+commentLabel.frame.origin.y, ScreenSize.width, 15)];
    lineView.dk_backgroundColorPicker  = Controller_Bg;
    [headerView addSubview:lineView];

    NSDate *date = [NSDate dateWithString:myData.comment_date format:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [date timeAgoSinceNow];
    describLabel.text = [NSString stringWithFormat:@"%@ @%@", myData.comment_author, time];
//    commentLabel.text = [NSString stringWithFormat:@"\U0000e717 %@   |   \U0000e716 %@   |   \U0000e69f %@",myData.vote_positive, myData.vote_negative, myData.comment_count];
        commentLabel.text = [NSString stringWithFormat:@"\U0000e717 %@   |   \U0000e716 %@   ",myData.vote_positive, myData.vote_negative];
    
    
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 50)];
    footerView.backgroundColor  = [UIColor clearColor];
    
    myTableView.tableHeaderView = headerView;
    myTableView.tableFooterView = footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row < commentArray.count) {
        [cell fillData:[commentArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommentCell heightForCellWithData:[commentArray objectAtIndex:indexPath.row]];
}

-(void)pictureClicked:(UITapGestureRecognizer *)gesture
{
    FLAnimatedImageView *sender =  (FLAnimatedImageView *)gesture.view;
    if (sender.animatedImage == nil && sender.image == nil) {
        return;
    }
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    if (sender.animatedImage) {
        imageInfo.image = (UIImage *)sender.animatedImage;
    } else if (sender.image) {
        imageInfo.image = sender.image;
    }
    imageInfo.referenceRect = sender.frame;
    imageInfo.referenceView = sender.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:TheAppDelegate.rootNavigationController transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

-(void)pushCommentWithText:(NSString *)content withParentId:(NSString *)pId
{
    [commentViewModel pushCommentWithContent:content  withParentId:pId withBlock:^(NetReturnValue *returnValue) {
        if (returnValue.finishType == REQUEST_SUCESS) {
            [[ToastHelper sharedToastHelper] toast:@"评论成功，有延迟请稍后查看"];
        } else {
            [[ToastHelper sharedToastHelper] toast:@"评论失败"];
        }
    }];
}

@end
