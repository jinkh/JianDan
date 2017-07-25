//
//  JokeDetailView.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/18.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "JokeDetailView.h"


#import "NSDate+Extension.h"
#import "NSDate+DateTools.h"
#import "FLAnimatedImageView+WebCache.h"
#import "CommentCell.h"
#import "ShareView.h"

@interface JokeDetailView ()<UITableViewDataSource, UITableViewDelegate>
{
    
    JokeModel *myData;
    
    UIView *headerView;
    UIView *footerView;
    NSMutableArray *commentArray;
    UITableView *myTableView;
    UIActivityIndicatorView *indicatorView;
    PicCommentViewModel *commentViewModel;
}

@end

@implementation JokeDetailView

-(void)dealloc
{
    ReleaseClass;
}

-(instancetype)initWithFrame:(CGRect)frame withData:(id)data
{
    if (self = [super initWithFrame:frame]) {
        
        myData = data;
        
        myTableView = [[UITableView alloc] initWithFrame:self.bounds];
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
        //[myTableView addSubview:indicatorView];
        
        
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

    NSInteger height = [myData.textHeight integerValue];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, offY, headerView.frame.size.width-10, height)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = DefaultFont(16);
    contentLabel.dk_textColorPicker = Text_Title;
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    contentLabel.clipsToBounds = YES;
    contentLabel.attributedText = myData.attributedString;
    [headerView addSubview:contentLabel];
    
    offY = offY+height;
    
    headerView.frame = CGRectMake(0, 0, ScreenSize.width, headerView.frame.size.height+offY);
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerClicked:)];
    [headerView addGestureRecognizer:gesture];
    
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

-(void)headerClicked:(id)sender
{
    ShareView *share = [[ShareView alloc] initWithData:myData];
    [share showAnimate:YES];
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
