
#import <UIKit/UIKit.h>
#import "NavigationInteractiveTransition.h"

@interface UINavigationController (ZHFullscreenPopGesture)

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *zh_fullscreenPopGestureRecognizer;
@property (nonatomic, strong, readonly) NavigationInteractiveTransition *zh_navigationInteractiveTransition;

//手势响应的宽度
@property (nonatomic, assign) CGFloat zh_fullscreenPopWidth;

@end


@interface UIViewController (ZHFullscreenPopGesture)

@property (nonatomic, assign) BOOL zh_interactivePopDisabled;

@property (strong, nonatomic) UIView *zh_customNav;

@property (assign, nonatomic) BOOL zh_showCustomNav;

@property (strong, nonatomic) NSString *zh_title;

-(void)reloadCustomNav;


@end
