//
//  Urls.h
//  JianDan
//
//  Created by 刘献亭 on 15/8/29.
//  Copyright © 2015年 刘献亭. All rights reserved.
//

#ifndef Urls_h
#define Urls_h

//新鲜事列表
static NSString* const FreshNewUrl = @"http://i.jandan.net/?oxwlxojflwblxbsapi=get_recent_posts&include=url,date,tags,author,title,comment_count,custom_fields&custom_fields=thumb_c,views&dev=1";

//无聊图列表
static NSString* const BoredPicturesUrl = @"http://i.jandan.net/?oxwlxojflwblxbsapi=jandan.get_pic_comments&page=";

//妹子图
static NSString* const SisterPicturesUrl = @"http://i.jandan.net/?oxwlxojflwblxbsapi=jandan.get_ooxx_comments&page=";

//段子
static NSString* const JokeUrl = @"http://i.jandan.net/?oxwlxojflwblxbsapi=jandan.get_duan_comments&page=";

//小视频
static NSString* const LittleMovieUrl = @"http://i.jandan.net/?oxwlxojflwblxbsapi=jandan.get_video_comments&page=";

//评论数量
static NSString* const CommentCountUrl = @"http://jandan.duoshuo.com/api/threads/counts.json?threads=";

//新鲜事详情
static NSString* const FreshNewDetailUrl = @"http://i.jandan.net/?oxwlxojflwblxbsapi=get_post&include=content&id=";

//新鲜事评论
static NSString* const FreshNewCommentlUrl = @"http://i.jandan.net/?oxwlxojflwblxbsapi=get_post&include=comments&id=";

//发表评论接口
static NSString* const PushCommentlUrl = @"http://i.jandan.net/?oxwlxojflwblxbsapi=respond.submit_comment";

//投票
static NSString* const CommentVoteUrl=@"http://i.jandan.net/index.php?acv_ajax=true&option=%@&ID=%@";

//多说评论列表 无聊图
static NSString* const DuoShuoCommentListlUrl=@"http://jandan.duoshuo.com/api/threads/listPosts.json?thread_key=";

//多说发表评论 无聊图
static NSString* const DuoShuoPushCommentUrl=@"http://jandan.duoshuo.com/api/posts/create.json";

#endif /* Urls_h */
