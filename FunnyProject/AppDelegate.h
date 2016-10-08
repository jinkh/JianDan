//
//  AppDelegate.h
//  FunnyProject
//
//  Created by Zinkham on 16/7/7.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewDeck/ViewDeck.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *rootNavigationController;

@property (strong, nonatomic) IIViewDeckController* deckController;


//- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;


-(void)reportWithArticleId:(NSString *)_id;

@end

