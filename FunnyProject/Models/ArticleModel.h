//
//  ArticleModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/11.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ArticleModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *url;
@property (strong, nonatomic) NSString<Optional> *title;
@property (strong, nonatomic) NSString<Optional> *date;
@property (strong, nonatomic) NSString<Optional> *author_name;
@property (assign, nonatomic) NSInteger comment_count;
@property (strong, nonatomic) NSString<Optional> *thumb_c;

@property (strong, nonatomic) NSNumber<Optional> *isRead;

@end
