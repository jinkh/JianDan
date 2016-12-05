//
//  CommentBarView.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/18.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "CommentBarView.h"
#import "UITextView+PlaceHolder.h"
#import "CenterController.h"
#import "LTAlertView.h"

@interface CommentBarView () <UITextViewDelegate>

{
    //normal
    UIView *normalView;
    
    //real
    UIButton *realBgBtn;
    UIView *realView;
    UITextView *inputTextView;
    
    UIButton *favBtn;
    
    BOOL keyboardIsShowing;
    
    id parentComment;
    
    BOOL isFaving;
    
}
@end

@implementation CommentBarView

-(void)dealloc
{
    ReleaseClass;
    [IQKeyboardManager sharedManager].enable = YES;
    [realView resignFirstResponder];
    [realBgBtn removeFromSuperview];
    realBgBtn = nil;
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initNormalBarView];
        [self initRealBarView];
        
        [IQKeyboardManager sharedManager].enable = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wpKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wpKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wpKeyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wpKeyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentChildAction:) name:Comment_Child_Notify object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction:) name:Rerfresh_CommednBar_Notify object:nil];
    }
    return self;
}

-(void)initRealBarView
{
    
    realBgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height)];
    realBgBtn.backgroundColor = COLORA(0, 0, 0, 0.4);
    realBgBtn.alpha = 1;
    [realBgBtn addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchDown];
    
    realView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenSize.height, ScreenSize.width, 110)];
    realView.dk_backgroundColorPicker  = Cell_Bg;
    [realBgBtn addSubview:realView];

    
    inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, realView.frame.size.width-20, realView.frame.size.height-40)];
    inputTextView.dk_backgroundColorPicker = Controller_Bg;
    inputTextView.dk_textColorPicker = Text_Title;
    inputTextView.font = DefaultFont(15);
    inputTextView.delegate = self;
    inputTextView.returnKeyType = UIReturnKeySend;
    [realView addSubview:inputTextView];
    inputTextView.scrollsToTop = NO;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, realView.frame.size.height-30, realView.frame.size.width-20, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font =DefaultFont(10);
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"*提交后不会即时显示，请等待审核和缓存更新";
    [realView addSubview:label];
}

-(void)initNormalBarView
{
    normalView = [[UIView alloc] initWithFrame:self.bounds];
    normalView.dk_backgroundColorPicker  = Cell_Bg;
    [self addSubview:normalView];
    
    
    CGFloat barHeight = self.frame.size.height;
    CGFloat barWidth = self.frame.size.width;
    
    UIView *dLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, barWidth, .6)];
    dLine.dk_backgroundColorPicker = Sep_Bg;
    [normalView addSubview:dLine];
    
    
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, barHeight, barHeight)];
    leftView.backgroundColor = [UIColor clearColor];
    leftView.text = @"\U0000e69e";
    leftView.font = IconFont(21);
    leftView.textColor = COLOR(119, 119, 119);
    leftView.textAlignment = NSTextAlignmentCenter;
    leftView.backgroundColor = [UIColor clearColor];
    [normalView addSubview:leftView];
    
    UILabel *contentText = [[UILabel alloc] initWithFrame:CGRectMake(barHeight, 5, barWidth-barHeight*2-10, barHeight-10)];
    contentText.backgroundColor = [UIColor clearColor];
    contentText.font = DefaultFont(14);
    contentText.text = @"请输入内容";
    contentText.userInteractionEnabled = YES;
    contentText.textColor = [UIColor grayColor];
    [normalView addSubview:contentText];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyBoard)];
    [contentText addGestureRecognizer:tap];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(barWidth-barHeight*2.4-6, 8, 1, barHeight-16)];
    line.dk_backgroundColorPicker = Sep_Bg;
    [normalView addSubview:line];
    
    favBtn = [[UIButton alloc] initWithFrame:CGRectMake(barWidth-barHeight*2.4-5, 0, barHeight*1.2, barHeight)];
    favBtn.backgroundColor = [UIColor clearColor];
    [favBtn setTitle:@"\U0000e6a0" forState:UIControlStateNormal];
    favBtn.titleLabel.font = IconFont(20);
    [favBtn addTarget:self action:@selector(favAction:) forControlEvents:UIControlEventTouchUpInside];
    [favBtn setTitleColor:COLOR(119, 119, 119) forState:UIControlStateNormal];
    [normalView addSubview:favBtn];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(barWidth-barHeight*1.2-5, 0, barHeight*1.2, barHeight)];
    shareBtn.backgroundColor = [UIColor clearColor];
    [shareBtn setTitle:@"\U0000e718" forState:UIControlStateNormal];
    shareBtn.titleLabel.font = IconFont(20);
    [shareBtn setTitleColor:COLOR(119, 119, 119) forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [normalView addSubview:shareBtn];
}

-(void)resetFavSate:(BOOL)isFav
{
    if (isFaving) {
        return;
    }
    if (isFav) {
        [favBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    } else {
        [favBtn setTitleColor:COLOR(119, 119, 119) forState:UIControlStateNormal];
    }
    [self performSelector:@selector(resetFavBtnState) withObject:nil afterDelay:.5];
    isFaving = YES;
}

-(void)resetFavBtnState
{
    isFaving = NO;
}

-(void)showKeyBoard
{
    if (keyboardIsShowing) {
        return;
    }
    if ([UserManager isUserLogin] == NO) {
        LTAlertView *alertView = [[LTAlertView alloc] initWithTitle:@"煎蛋" contentText:@"评论前需要设置昵称和邮箱，是否设置？" leftButtonTitle:@"取消" rightButtonTitle:@"设置"];
        [alertView show];
        alertView.rightBlock = ^{
            CenterController *center = [[CenterController alloc] init];
            [TheAppDelegate.rootNavigationController pushViewController:center animated:YES];
        };
        return;
    }
    if (!inputTextView.isFirstResponder) {
        [inputTextView becomeFirstResponder];
        [TheAppDelegate.window addSubview:realBgBtn];
    }
}
-(void)dismissKeyboard
{
    if (inputTextView.isFirstResponder) {
        [inputTextView resignFirstResponder];
        [realBgBtn removeFromSuperview];
    }
}

-(void)dismissKeyboardAndClear
{
    [self dismissKeyboard];
    inputTextView.text = @"";
}

- (void)wpKeyboardDidShow{
    keyboardIsShowing = YES;
}

- (void)wpKeyboardDidHide{
    keyboardIsShowing = NO;
    [realBgBtn removeFromSuperview];
    parentComment = nil;
}

-(void)wpKeyboardWillShow:(NSNotification *)note
{
    float duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat shouldScrollTo = ScreenSize.height-realView.bounds.size.height-keyboardHeight;
    if(keyboardHeight == 0){
        return;
    }
    realBgBtn.alpha = 0;
    __weak typeof(realView) weakView = realView;
    __weak typeof(realBgBtn) weakBgView = realBgBtn;
    [UIView animateWithDuration:duration animations:^{
        CGRect bounds = weakView.bounds;
        weakView.frame = CGRectMake(0, shouldScrollTo, bounds.size.width, bounds.size.height);
        weakBgView.alpha = 1;
    }];
}

-(void)wpKeyboardWillHide:(NSNotification *)note
{
    float duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    realBgBtn.alpha = 1;
    __weak typeof(realView) weakView = realView;
    __weak typeof(realBgBtn) weakBgView = realBgBtn;
    [UIView animateWithDuration:duration*.7 animations:^{
        CGRect bounds = weakView.bounds;
        weakView.frame = CGRectMake(0, ScreenSize.height, bounds.size.width, bounds.size.height);
        weakBgView.alpha = 0;
    } completion:^(BOOL finished) {
        [realBgBtn removeFromSuperview];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        //发送
        NSLog(@"textView.text = %@", textView.text);
        if (textView.text == nil || textView.text.length <= 0) {
            return NO;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(commentActionWithText:withParent:)]) {
            id parent = nil;
            if ([parentComment isKindOfClass:[PicCommentModel class]]) {
                parent = ((PicCommentModel *)parentComment).post_id;
            } else if ([parentComment isKindOfClass:[ArticleCommentModel class]]) {
                parent = parentComment;
            }
            
            [self.delegate commentActionWithText:textView.text withParent:parent];
        }
        [self dismissKeyboardAndClear];
        return NO;
    }
    return YES;
}


-(void)favAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(favAction)]) {
        [self.delegate favAction];
    }
}

-(void)shareAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareAction)]) {
        [self.delegate shareAction];
    }
}


-(void)commentChildAction:(NSNotification *)notify
{
    id object = notify.object;
    if (self.window != nil && object) {
        parentComment = object;
        [self showKeyBoard];
    }
}

-(void)refreshAction:(NSNotification *)notify
{
    id data = notify.object;
    if (self.window != nil && data) {
        BOOL isFav = NO;
        if ([data isKindOfClass:[ArticleModel class]]) {
            if ([ArticleViewModel isFavWithModel:data]) {
                isFav = YES;
            }
        } else if ([data isKindOfClass:[PictureModel class]]) {
            if ([PictureViewModel isFavWithModel:data withType:((PictureModel*)data).comment_type]) {
                isFav = YES;
            }
        } else if ([data isKindOfClass:[JokeModel class]]) {
            if ([JokeViewModel isFavWithModel:data]) {
                isFav = YES;
            }
        } else if ([data isKindOfClass:[VideoModel class]]) {
            if ([VideoViewModel isFavWithModel:data]) {
                isFav = YES;
            }
        }
        [self resetFavSate:isFav];
    }
}



@end
