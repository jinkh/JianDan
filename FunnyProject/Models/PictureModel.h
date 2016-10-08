//
//  PictureModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/11.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "PictureSourceModel.h"

@interface PictureModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *comment_ID;
@property (strong, nonatomic) NSString<Optional> *comment_post_ID;
@property (strong, nonatomic) NSString<Optional> *comment_author;
@property (strong, nonatomic) NSString<Optional> *comment_author_email;
@property (strong, nonatomic) NSString<Optional> *comment_author_url;
@property (strong, nonatomic) NSString<Optional> *comment_author_IP;
@property (strong, nonatomic) NSString<Optional> *comment_date;
@property (strong, nonatomic) NSString<Optional> *comment_date_gmt;
@property (strong, nonatomic) NSString<Optional> *comment_content;
@property (strong, nonatomic) NSString<Optional> *comment_karma;
@property (strong, nonatomic) NSString<Optional> *comment_approved;
@property (strong, nonatomic) NSString<Optional> *comment_agent;
@property (strong, nonatomic) NSString<Optional> *comment_type;
@property (strong, nonatomic) NSString<Optional> *comment_parent;
@property (strong, nonatomic) NSString<Optional> *user_id;
@property (strong, nonatomic) NSString<Optional> *comment_subscribe;
@property (strong, nonatomic) NSString<Optional> *comment_reply_ID;
@property (strong, nonatomic) NSString<Optional> *vote_positive;
@property (strong, nonatomic) NSString<Optional> *vote_negative;
@property (strong, nonatomic) NSString<Optional> *vote_ip_pool;
@property (strong, nonatomic) NSString<Optional> *text_content;

@property (strong, nonatomic) NSMutableArray<Optional> *pics;

@property (strong, nonatomic) NSString<Optional> *comment_count;

@end
