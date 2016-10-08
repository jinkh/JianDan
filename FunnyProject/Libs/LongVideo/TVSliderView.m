//
//  TVSliderView.m
//  FunnyProject
//
//  Created by Zinkham on 16/8/4.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "TVSliderView.h"

@implementation TVSliderView

- (CGRect)thumbRect
{
    CGRect trackRect = [self trackRectForBounds:self.bounds];
    CGRect thumbRect = [self thumbRectForBounds:self.bounds
                                      trackRect:trackRect
                                          value:self.value];
    return thumbRect;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect thumbFrame = [self thumbRect];
    
    // check if the point is within the thumb
    if (CGRectContainsPoint(thumbFrame, point))
    {
        // if so trigger the method of the super class
        NSLog(@"inside thumb");
        return [super hitTest:point withEvent:event];
    }
    else
    {
        return nil;
        // if not just pass the event on to your superview
    }


}

@end
