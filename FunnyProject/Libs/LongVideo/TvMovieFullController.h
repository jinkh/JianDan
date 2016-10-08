

#import <UIKit/UIKit.h>
#import "TvMovieView.h"

@interface TvMovieFullController : UIViewController

-(instancetype)initWithUrl:(NSString *)url withTitle:(NSString *)title;

-(instancetype)initWithMoviePlayer:(TvMovieView *)player;

@end
