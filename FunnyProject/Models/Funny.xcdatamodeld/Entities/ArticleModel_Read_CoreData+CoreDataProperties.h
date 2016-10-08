//
//  ArticleModel_Read_CoreData+CoreDataProperties.h
//  
//
//  Created by Zinkham on 16/7/27.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ArticleModel_Read_CoreData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticleModel_Read_CoreData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *author_name;
@property (nullable, nonatomic, retain) NSNumber *comment_count;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSNumber *sortTime;
@property (nullable, nonatomic, retain) NSString *thumb_c;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *url;

@end

NS_ASSUME_NONNULL_END
