//
//  AppDelegate.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/2/23.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <Firebase/Firebase.h>
#import <FirebaseCore/FirebaseCore.h>
#import "CommentViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Firebase认证
    [FIRApp configure];
    
    
    // 登录状态判断rootVC
        // 获取当前登录用户
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    CommentViewController *homeVC = [[CommentViewController alloc] init];
    if (currentUser) {
        // 用户已登录
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:homeVC];
    } else {
        // 未登录
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    }
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}






@end
