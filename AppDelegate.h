//
//  AppDelegate.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/2/23.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

- (UITabBarController *)createTabBarController;

- (void)processFriendshipWithInviter:(NSString *)inviterUID;
@end

