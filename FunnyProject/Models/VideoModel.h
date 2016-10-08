//
//  VideoModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/12.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface VideoModel : JSONModel
@property (strong, nonatomic) NSString<Optional> *id;

@property (strong, nonatomic) NSString<Optional> *create_time;
@property (strong, nonatomic) NSString<Optional> *hate;
@property (strong, nonatomic) NSString<Optional> *love;
@property (strong, nonatomic) NSString<Optional> *name;
@property (strong, nonatomic) NSString<Optional> *profile_image;
@property (strong, nonatomic) NSString<Optional> *text;
@property (strong, nonatomic) NSString<Optional> *video_uri;


@end
