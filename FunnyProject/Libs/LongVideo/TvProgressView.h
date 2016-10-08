
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import "AppKitCompatibility.h"
#endif

@interface TvProgressView : UIView
{
@private
	float progress ;
	UIColor *innerColor ;
	UIColor *outerColor ;
    UIColor *emptyColor ;
}

@property (nonatomic,retain) UIColor *innerColor ;
@property (nonatomic,retain) UIColor *outerColor ;
@property (nonatomic,retain) UIColor *emptyColor ;
@property (nonatomic,assign) float progress ;

@end
