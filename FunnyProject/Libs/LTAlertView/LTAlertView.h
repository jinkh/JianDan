

#import <UIKit/UIKit.h>

@interface LTAlertView : UIView

#pragma mark 自定义View

- (id)initWithNib:(UIView *)view;

#pragma mark 默认的alert

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle;

- (void)show;

- (void)dismiss;

@property(nonatomic, copy) dispatch_block_t leftBlock;

@property(nonatomic, copy) dispatch_block_t rightBlock;

@end
