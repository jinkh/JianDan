//
//  ArticleModel_CoreData+CoreDataProperties.h
//  
//
//  Created by Zinkham on 16/7/25.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ArticleModel_CoreData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticleModel_CoreData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *author_name;
@property (nullable, nonatomic, retain) NSNumber *comment_count;
@property (nullable, nonatomic, retain) NSString *thumb_c;
@property (nullable, nonatomic, retain) NSNumber *sortTime;

@end

NS_ASSUME_NONNULL_END
