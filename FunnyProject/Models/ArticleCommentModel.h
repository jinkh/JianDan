//
//  ArticleCommentModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/14.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ArticleCommentModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *url;
@property (strong, nonatomic) NSString<Optional> *date;
@property (strong, nonatomic) NSString<Optional> *content;
@property (strong, nonatomic) ArticleCommentModel<Optional> *parentComment;
@property (strong, nonatomic) NSString<Optional> *vote_positive;
@property (strong, nonatomic) NSString<Optional> *vote_negative;
@property (strong, nonatomic) NSString<Optional> *index;


@property (strong, nonatomic) NSNumber<Optional> *msgWidth;
@property (strong, nonatomic) NSNumber<Optional> *msgHeight;
@property (strong, nonatomic) NSMutableAttributedString<Optional> *attributedString;

@end
