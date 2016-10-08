//
//  PicCommentModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/14.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PicCommentModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *post_id;
@property (strong, nonatomic) NSString<Optional> *thread_id;
@property (strong, nonatomic) NSString<Optional> *status;
@property (strong, nonatomic) NSString<Optional> *source;
@property (strong, nonatomic) NSString<Optional> *type;
@property (strong, nonatomic) NSString<Optional> *message;
@property (strong, nonatomic) NSString<Optional> *created_at;
@property (strong, nonatomic) NSString<Optional> *ip;
@property (strong, nonatomic) NSString<Optional> *iplocation;
@property (strong, nonatomic) NSString<Optional> *likes;
@property (strong, nonatomic) NSString<Optional> *agent;
@property (strong, nonatomic) NSString<Optional> *comments;
@property (strong, nonatomic) NSString<Optional> *reposts;
@property (strong, nonatomic) NSString<Optional> *root_id;
@property (strong, nonatomic) NSString<Optional> *parent_id;
@property (strong, nonatomic) NSMutableArray<Optional> *parents;

@property (strong, nonatomic) PicCommentModel<Optional> *parentComment;

@property (strong, nonatomic) NSString<Optional> *author_id;
@property (strong, nonatomic) NSString<Optional> *author_name;
@property (strong, nonatomic) NSString<Optional> *author_avatar_url;


@property (strong, nonatomic) NSNumber<Optional> *msgWidth;
@property (strong, nonatomic) NSNumber<Optional> *msgHeight;

@property (strong, nonatomic) NSMutableAttributedString<Optional> *attributedString;

@end
