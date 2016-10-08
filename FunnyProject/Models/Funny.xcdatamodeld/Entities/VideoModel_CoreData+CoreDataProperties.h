//
//  VideoModel_CoreData+CoreDataProperties.h
//  
//
//  Created by Zinkham on 16/7/25.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "VideoModel_CoreData.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoModel_CoreData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *create_time;
@property (nullable, nonatomic, retain) NSString *hate;
@property (nullable, nonatomic, retain) NSString *love;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *profile_image;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *video_uri;

@property (nullable, nonatomic, retain) NSNumber *sortTime;

@end

NS_ASSUME_NONNULL_END
