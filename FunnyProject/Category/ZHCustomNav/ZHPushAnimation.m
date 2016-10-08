//
//  ZHPushAnimation.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/20.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ZHPushAnimation.h"

@interface ZHPushAnimation ()
@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;
@end

@implementation ZHPushAnimation

-(void)dealloc
{
    NSLog(@"release class %@", NSStringFromClass([self class]));
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    //这个方法返回动画执行的时间
    return 0.3;
}

/**
 *  transitionContext你可以看作是一个工具，用来获取一系列动画执行相关的对象，并且通知系统动画是否完成等功能。
 */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    /**
     *  获取动画来自的那个控制器
     */
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    /**
     *  获取转场到的那个控制器
     */
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    /**
     *  转场动画是两个控制器视图时间的动画，需要一个containerView来作为一个“舞台”，让动画执行。
     */
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    /**
     *  执行动画，我们让fromVC的视图移动到屏幕最右侧
     */
    CGFloat scale = 1-20.0f/[UIScreen mainScreen].bounds.size.width;
    toViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    toViewController.view.clipsToBounds = YES;
    fromViewController.view.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:duration animations:^{
        fromViewController.view.transform = CGAffineTransformMakeScale(scale, scale);
        toViewController.view.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        /**
         *  当你的动画执行完成，这个方法必须要调用，否则系统会认为你的其余任何操作都在动画执行过程中。
         */
         toViewController.view.transform = CGAffineTransformIdentity;
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)animationDidStop:(CATransition *)anim finished:(BOOL)flag {
    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
}

@end