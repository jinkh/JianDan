//
//  JokeModel_CoreData+CoreDataProperties.h
//  
//
//  Created by Zinkham on 16/7/25.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JokeModel_CoreData.h"

NS_ASSUME_NONNULL_BEGIN

@interface JokeModel_CoreData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *comment_ID;
@property (nullable, nonatomic, retain) NSString *comment_post_ID;
@property (nullable, nonatomic, retain) NSString *comment_author;
@property (nullable, nonatomic, retain) NSString *comment_author_email;
@property (nullable, nonatomic, retain) NSString *comment_author_url;
@property (nullable, nonatomic, retain) NSString *comment_author_IP;
@property (nullable, nonatomic, retain) NSString *comment_date;
@property (nullable, nonatomic, retain) NSString *comment_date_gmt;
@property (nullable, nonatomic, retain) NSString *comment_content;
@property (nullable, nonatomic, retain) NSString *comment_karma;
@property (nullable, nonatomic, retain) NSString *comment_approved;
@property (nullable, nonatomic, retain) NSString *comment_agent;
@property (nullable, nonatomic, retain) NSString *comment_type;
@property (nullable, nonatomic, retain) NSString *comment_parent;
@property (nullable, nonatomic, retain) NSString *user_id;
@property (nullable, nonatomic, retain) NSString *comment_subscribe;
@property (nullable, nonatomic, retain) NSString *comment_reply_ID;
@property (nullable, nonatomic, retain) NSString *vote_positive;
@property (nullable, nonatomic, retain) NSString *vote_negative;
@property (nullable, nonatomic, retain) NSString *vote_ip_pool;
@property (nullable, nonatomic, retain) NSString *text_content;
@property (nullable, nonatomic, retain) NSString *comment_count;
@property (nullable, nonatomic, retain) NSNumber *textWidth;
@property (nullable, nonatomic, retain) NSNumber *textHeight;
@property (nullable, nonatomic, retain) NSData *attributedString;
@property (nullable, nonatomic, retain) NSNumber *sortTime;

@end

NS_ASSUME_NONNULL_END
