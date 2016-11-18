//
//  SettingController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/13.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "SettingController.h"
#import "SettingCell.h"
#import "LeftMenuSortController.h"

#import "DonationController.h"
#import "ActionSheetStringPicker.h"
#import "AgreementController.h"
#import "AuthorController.h"
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import "FavMenuSortController.h"
#import "LTAlertView.h"

@interface SettingController ()<UITableViewDataSource, UITableViewDelegate>

{
    UITableView *myTableView;
    NSArray *sectionTitles;
    
    NSArray *dataArray;
}

@end

@implementation SettingController

-(void)dealloc
{
    ReleaseClass;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = Controller_Bg;
    self.zh_showCustomNav = YES;
    self.zh_title = @"设置";
    
    sectionTitles = @[@"捐赠计划", @"APP定制", @"存储", @"反馈", @"关于"];
    
    dataArray = @[@[@"帮助煎了个鸡蛋做的更好"], @[@"左侧菜单排序", @"收藏菜单排序", @"短视频自动播放", @"夜间模式"], @[@"清除图片缓存", @"图片缓存有效期", @"清空数据库"], @[@"我要评分", @"反馈或者建议"], @[@"用户协议", @"关于作者"],];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setTitle:@"\U0000e6b4" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = IconFont(20);
    [leftBtn addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.zh_customNav addSubview:leftBtn];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.scrollsToTop = NO;
    myTableView.showsVerticalScrollIndicator = YES;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.dk_separatorColorPicker = Sep_Bg_System;
    [self.view addSubview:myTableView];
    if ([myTableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        myTableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
    myTableView.tableFooterView = [UIView new];
    
    
    if (feedbackKit == nil) {
        feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:@"23422534"];
        feedbackKit.hideContactInfoView = YES;
        feedbackKit.customUIPlist = @{@"hideLoginSuccess": @(YES)};
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [myTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionTitles.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel  *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 35)];
    label.dk_backgroundColorPicker =  DKColorPickerWithColors(COLOR(236, 236, 236), COLOR(0, 0, 0));
    label.font = DefaultFont(14);
    label.text = [NSString stringWithFormat:@"     %@", [sectionTitles objectAtIndex:section]];
    label.textAlignment = NSTextAlignmentLeft;
    label.dk_textColorPicker  =Text_Title;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
       return 35;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [dataArray objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingCell";
    SettingCell *cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    NSArray *array = [dataArray objectAtIndex:indexPath.section];
    
    if (indexPath.section == 0) {
        [cell fillData:[array objectAtIndex:indexPath.row] withStyle:SettingCellRightStyleIndicator];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            [cell fillData:[array objectAtIndex:indexPath.row] withStyle:SettingCellRightStyleIndicator];
        } else {
            [cell fillData:[array objectAtIndex:indexPath.row] withStyle:SettingCellRightStyleSwitch];
        }
    } else if (indexPath.section == 2) {
       [cell fillData:[array objectAtIndex:indexPath.row] withStyle:SettingCellRightStyleDetail];
    } else if (indexPath.section == 3) {
        [cell fillData:[array objectAtIndex:indexPath.row] withStyle:SettingCellRightStyleIndicator];
    } else if (indexPath.section == 4) {
        [cell fillData:[array objectAtIndex:indexPath.row] withStyle:SettingCellRightStyleIndicator];
    }
    return cell;
}


static YWFeedbackKit *feedbackKit;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            DonationController *showCon = [[DonationController alloc] init];
            [TheAppDelegate.deckController.navigationController pushViewController:showCon animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            LeftMenuSortController *showCon = [[LeftMenuSortController alloc] init];
            [TheAppDelegate.deckController.navigationController pushViewController:showCon animated:YES];
        } else if (indexPath.row == 1) {
            FavMenuSortController *showCon = [[FavMenuSortController alloc] init];
            [TheAppDelegate.deckController.navigationController pushViewController:showCon animated:YES];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //清除缓存
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [myTableView reloadData];
                [[ToastHelper sharedToastHelper] toast:@"清除缓存成功"];
            }];
        } else if (indexPath.row == 1) {
            NSInteger index = [SettingManager getCachUsefulDateType];
            NSArray *data = [SettingManager getCachUsefulData];
            [ActionSheetStringPicker showPickerWithTitle:@"" rows:data initialSelection:index doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                [SettingManager setCachUsefulDateType:selectedIndex];
                [myTableView reloadData];
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:[myTableView cellForRowAtIndexPath:indexPath]];
        } else if (indexPath.row == 2) {
            LTAlertView *alertView = [[LTAlertView alloc] initWithTitle:@"煎蛋" contentText:@"清空数据库，会清除本地所有收藏数据及已读新鲜事标记，是否清除？" leftButtonTitle:@"取消" rightButtonTitle:@"清除"];
            [alertView show];
            alertView.rightBlock = ^{
                [SettingManager cleanUpDbWithcompletedBlock:^(BOOL result) {
                    [[ToastHelper sharedToastHelper] toast:@"清空数据成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Clear_Fav_Data_Change_Notify object:nil];
                }];
            };
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/jian-le-ge-ji-dan/id1150340986?ls=1&mt=8"]];
        } else if (indexPath.row == 1) {

            if (feedbackKit == nil) {
                feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:@"23422534"];
                feedbackKit.hideContactInfoView = YES;
                feedbackKit.customUIPlist = @{@"hideLoginSuccess": @(YES)};
            }
            
            __weak typeof(self) weakSelf = self;
            [feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWLightFeedbackViewController *viewController, NSError *error) {
                if (viewController != nil ) {
                    viewController.title = @"反馈界面";
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
                    nav.view.backgroundColor  =COLOR(246, 246, 246);
                    
                    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:weakSelf action:@selector(actionQuitFeedback)];
                    
                    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除缓存" style:UIBarButtonItemStylePlain
                                                                                                      target:weakSelf action:@selector(actionCleanMemory:)];
                    viewController.view.hidden = YES;
                    [viewController.view performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:NO] afterDelay:1.2];
    
                    [weakSelf presentViewController:nav animated:YES completion:^{
                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                    }];
                    

            
                } else {
                    NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
                    NSLog(@"feedbackKit error  =%@", title);
                }
            }];
        }
    }else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            AgreementController *showCon = [[AgreementController alloc] init];
            [TheAppDelegate.deckController.navigationController pushViewController:showCon animated:YES];
        } else if (indexPath.row == 1) {
            AuthorController *showCon = [[AuthorController alloc] init];
            [TheAppDelegate.deckController.navigationController pushViewController:showCon animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SettingCell heightForCell];
}

//feed back
-(void)showLeftMenu
{
    [TheAppDelegate.deckController openLeftView];
}

- (void)actionQuitFeedback
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

- (void)actionCleanMemory:(id)sender
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
