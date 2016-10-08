//
//  ArticleDetailModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/13.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ArticleDetailModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *id;
@property (strong, nonatomic) NSString<Optional> *content;
@property (strong, nonatomic) NSString<Optional> *previous_url;
@property (strong, nonatomic) NSString<Optional> *htmlStr;

@end
