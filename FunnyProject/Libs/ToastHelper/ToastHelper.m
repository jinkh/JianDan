

#import "ToastHelper.h"

@interface ToastHelper ()
{
    UIView *bgView;
    UILabel *label;
    
    BOOL isShowing;

}
@end

@implementation ToastHelper

+ (ToastHelper *)sharedToastHelper
{
    
    static ToastHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ToastHelper alloc] init];
    });
    return instance;
}

-(void)dealloc
{
    ReleaseClass;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(instancetype)init
{
    if (self = [super init]) {
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, [UIScreen mainScreen].bounds.size.width-10, 64-20)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.dk_textColorPicker = DKColorPickerWithColors(COLORA(0, 0, 0, .7), [UIColor whiteColor]);
        label.font = DefaultFont(18);
        label.numberOfLines = 1;
        isShowing = NO;
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
        bgView.dk_backgroundColorPicker = DKColorPickerWithColors(COLOR(236, 236, 236), [UIColor blackColor]);
        [bgView addSubview:label];
        
        UIView *dLine = [[UIView alloc] initWithFrame:CGRectMake(0, 63, [UIScreen mainScreen].bounds.size.width, 1)];
        dLine.backgroundColor =COLORA(0, 0, 0, .3);
        [bgView addSubview:dLine];
        
    }
    return self;
}

- (void)toast:(NSString *)textString afterDelay:(CGFloat)delay
{
    [self performSelector:@selector(toast:) withObject:textString afterDelay:delay];
}

- (void)toast:(NSString *)textString
{
    if (isShowing) {
        return;
    }
    isShowing = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        label.text = textString;
        label.center = CGPointMake(bgView.bounds.size.width*.5, bgView.bounds.size.height*.5+10);
        [TheAppDelegate.window addSubview:bgView];
        [self performSelector:@selector(dismissToast) withObject:nil afterDelay:.8 inModes:@[NSRunLoopCommonModes]];
        
        bgView.frame = CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, 64);
        [UIView animateWithDuration:.1 animations:^{
            bgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        } completion:^(BOOL finished) {
            
        }];
        
    });
}

-(void)dismissToast
{
    bgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    [UIView animateWithDuration:.1 animations:^{
        bgView.frame = CGRectMake(0,-64, [UIScreen mainScreen].bounds.size.width, 64);
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
        isShowing = NO;
    }];
}


@end
