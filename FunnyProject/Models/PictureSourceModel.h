//
//  PictureSourceModel.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/18.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PictureSourceModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *url;

@property (strong, nonatomic) NSNumber<Optional> *picWidth;
@property (strong, nonatomic) NSNumber<Optional> *picHeight;

@end
