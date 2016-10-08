#import "UINavigationController+ZHCustomNav.h"
#import "NavigationInteractiveTransition.h"
#import <objc/runtime.h>
#import "TvMovieFullController.h"

@interface _ZHFullscreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation _ZHFullscreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // Disable when the active view controller doesn't allow interactive pop.
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.zh_interactivePopDisabled) {
        return NO;
    }

    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0 || fabs(translation.x) < fabs(translation.y)) {
        return NO;
    }
    
    //超出响应区域
    CGPoint location = [((UIPanGestureRecognizer *)gestureRecognizer) locationInView:gestureRecognizer.view];
    NSLog(@"self.navigationController.zh_fullscreenPopWidth = %f",self.navigationController.zh_fullscreenPopWidth);
    if (location.x > self.navigationController.zh_fullscreenPopWidth) {
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]] && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint trans = [((UIPanGestureRecognizer *)gestureRecognizer) translationInView:gestureRecognizer.view];
        CGPoint location = [((UIPanGestureRecognizer *)gestureRecognizer) locationInView:gestureRecognizer.view];
        if (trans.x > 0 && fabs(trans.x) > fabs(trans.y) && location.x < self.navigationController.zh_fullscreenPopWidth) {
            [otherGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
            return YES;
        }
    }
    return NO;
}

@end

typedef void (^_ZHViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (ZHFullscreenPopGesturePrivate)

@property (nonatomic, copy) _ZHViewControllerWillAppearInjectBlock zh_willAppearInjectBlock;

@end

@implementation UIViewController (ZHFullscreenPopGesturePrivate)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(zh_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        
        SEL originalSelector2 = @selector(viewDidLoad);
        SEL swizzledSelector2 = @selector(zh_viewDidLoad);
        
        Method originalMethod2 = class_getInstanceMethod(class, originalSelector2);
        Method swizzledMethod2 = class_getInstanceMethod(class, swizzledSelector2);
        
        BOOL success2 = class_addMethod(class, originalSelector2, method_getImplementation(swizzledMethod2), method_getTypeEncoding(swizzledMethod2));
        if (success2) {
            class_replaceMethod(class, swizzledSelector2, method_getImplementation(originalMethod2), method_getTypeEncoding(originalMethod2));
        } else {
            method_exchangeImplementations(originalMethod2, swizzledMethod2);
        }
    });
    
}

-(void)zh_viewDidLoad
{
    [self zh_viewDidLoad];
    [self reloadCustomNav];
}

- (void)zh_viewWillAppear:(BOOL)animated
{
    
    [self zh_viewWillAppear:animated];
    
    [self reloadCustomNav];
    
    if (self.zh_willAppearInjectBlock) {
        self.zh_willAppearInjectBlock(self, animated);
    }
}

- (_ZHViewControllerWillAppearInjectBlock)zh_willAppearInjectBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZh_willAppearInjectBlock:(_ZHViewControllerWillAppearInjectBlock)block
{
    objc_setAssociatedObject(self, @selector(zh_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UINavigationController (ZHFullscreenPopGesture)

+ (void)load
{
    // Inject "-pushViewController:animated:"
    Method originalMethod = class_getInstanceMethod(self, @selector(pushViewController:animated:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(zh_pushViewController:animated:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)zh_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.zh_fullscreenPopGestureRecognizer]) {
        
//        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
//        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.zh_fullscreenPopGestureRecognizer];
//
//        // Forward the gesture events to the private handler of the onboard gesture recognizer.
//        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
//        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
//        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
//        self.zh_fullscreenPopGestureRecognizer.delegate = self.zh_popGestureRecognizerDelegate;
//        [self.zh_fullscreenPopGestureRecognizer addTarget:internalTarget action:internalAction];
//
//        // Disable the onboard gesture recognizer.
//        self.interactivePopGestureRecognizer.enabled = NO;
        
        UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
        gesture.enabled = NO;
        UIView *gestureView = gesture.view;
        
        self.zh_fullscreenPopGestureRecognizer.delegate = self.zh_popGestureRecognizerDelegate;
        self.zh_fullscreenPopGestureRecognizer.maximumNumberOfTouches = 1;
        [gestureView addGestureRecognizer:self.zh_fullscreenPopGestureRecognizer];
        [self.zh_fullscreenPopGestureRecognizer addTarget:self.zh_navigationInteractiveTransition action:@selector(handleControllerPop:)];
    }

    
    // Forward to primary implementation.
    [self zh_pushViewController:viewController animated:animated];
}

- (_ZHFullscreenPopGestureRecognizerDelegate *)zh_popGestureRecognizerDelegate
{
    _ZHFullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);

    if (!delegate) {
        delegate = [[_ZHFullscreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIPanGestureRecognizer *)zh_fullscreenPopGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);

    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

-(NavigationInteractiveTransition *)zh_navigationInteractiveTransition
{
    NavigationInteractiveTransition *navigationInteractiveTransition = objc_getAssociatedObject(self, _cmd);
    
    if (!navigationInteractiveTransition) {
        navigationInteractiveTransition = [[NavigationInteractiveTransition alloc] initWithViewController:self];
        
        objc_setAssociatedObject(self, _cmd, navigationInteractiveTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return navigationInteractiveTransition;
}

-(CGFloat )zh_fullscreenPopWidth
{
    NSNumber *width = objc_getAssociatedObject(self, @"zh_fullscreenPopWidth");
    
    if (!width) {
        width = [NSNumber numberWithFloat:[UIScreen mainScreen].bounds.size.width];
        
        objc_setAssociatedObject(self, @"zh_fullscreenPopWidth", width, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [width floatValue];
}

-(void)setZh_fullscreenPopWidth:(CGFloat)zh_fullscreenPopWidth
{
    NSNumber *width = [NSNumber numberWithFloat:zh_fullscreenPopWidth];
    objc_setAssociatedObject(self, @"zh_fullscreenPopWidth", width, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return NO;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;

}


@end



@implementation UIViewController (ZHFullscreenPopGesture)


-(void)goBack
{
    if (self.navigationController == nil || self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)reloadCustomNav
{
    if (self.zh_customNav == nil) {
        UIImageView *navView = [[UIImageView alloc] initWithFrame:
                                CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 63)];
        navView.dk_backgroundColorPicker = Nav_Bg;
//        navView.image = [UIImage imageNamed:@"nav_bg"];
//        navView.contentMode = UIViewContentModeScaleAspectFill;
        navView.userInteractionEnabled = YES;
        navView.layer.masksToBounds = YES;
        
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
        backBtn.backgroundColor = [UIColor clearColor];
        backBtn.contentMode = UIViewContentModeCenter;
        backBtn.tag = 1000;
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [backBtn setImage:[UIImage imageNamed:@"nav_button_back_n"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"nav_button_back_h"] forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:backBtn];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20 , [UIScreen mainScreen].bounds.size.width-100, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        titleLabel.font = DefaultFont(19);  //设置文本字体与大小
        titleLabel.textColor = [UIColor whiteColor];  //设置文本颜色
        titleLabel.tag = 2000;
        titleLabel.textAlignment = UIBaselineAdjustmentAlignCenters;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [navView addSubview:titleLabel];
        
        self.zh_customNav = navView;
        
    }

    if (self.zh_showCustomNav) {
        
        self.navigationController.navigationBarHidden = YES;
        self.zh_customNav.hidden = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        UILabel *titleLabel = [self.zh_customNav viewWithTag:2000];
        if (titleLabel) {
            titleLabel.text = self.zh_title;
        }
        
        [self.zh_customNav removeFromSuperview];
        [self.view addSubview:self.zh_customNav];
        [self.view bringSubviewToFront:self.zh_customNav];
        
        UIButton *backBtn = [self.zh_customNav viewWithTag:2000];
        if (backBtn) {
            if (self.navigationController== nil || self.navigationController.viewControllers.count > 1) {
                [self.zh_customNav viewWithTag:1000].hidden = NO;
            } else {
                [self.zh_customNav viewWithTag:1000].hidden = YES;
            }
        }
        
    } else {
        
        self.navigationController.navigationBarHidden = NO;
        self.zh_customNav.hidden = YES;
    }
    
    if (self.navigationController == [UIApplication sharedApplication].keyWindow.rootViewController) {
        self.navigationController.navigationBarHidden = YES;
    }
}

-(UIView *)zh_customNav
{
    return objc_getAssociatedObject(self, @"navigationView");
}

-(void)setZh_customNav:(UIView *)navigationView
{
    objc_setAssociatedObject(self, @"navigationView", navigationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self reloadCustomNav];
}

-(NSString *)zh_title
{
    return objc_getAssociatedObject(self, @"title");
}

-(void)setZh_title:(NSString *)title
{
    objc_setAssociatedObject(self, @"title", title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self reloadCustomNav];
}


-(BOOL)zh_showCustomNav
{
    return [objc_getAssociatedObject(self, @"showCustomNav") boolValue];
}

-(void)setZh_showCustomNav:(BOOL)showCustomNav
{
    objc_setAssociatedObject(self, @"showCustomNav", [NSNumber numberWithBool:showCustomNav], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self reloadCustomNav];
}


- (BOOL)zh_interactivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZh_interactivePopDisabled:(BOOL)disabled
{
    objc_setAssociatedObject(self, @selector(zh_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
