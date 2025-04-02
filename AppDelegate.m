//
//  AppDelegate.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/2/23.
//

#import "AppDelegate.h"
#import <Firebase/Firebase.h>
#import <FirebaseCore/FirebaseCore.h>
#import "LoginViewController.h"
#import "CommentViewController.h"
#import "ContactsViewController.h"
#import "EditViewController.h"
#import "DocumentViewController.h"

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
    
    
    if (currentUser) {
        // 用户已登录
        self.window.rootViewController = [self createTabBarController];
    } else {
        // 未登录
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (UITabBarController *)createTabBarController {
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    CommentViewController *homeVC = [[CommentViewController alloc] init];
    ContactsViewController *contactVC = [[ContactsViewController alloc] init];
    EditViewController *editVC = [[EditViewController alloc] init];
    DocumentViewController *documentVC = [[DocumentViewController alloc] init];
    
    // 将EditViewController包装在UINavigationController中
    UINavigationController *editNav = [[UINavigationController alloc] initWithRootViewController:editVC];
    UINavigationController *docNav = [[UINavigationController alloc] initWithRootViewController:documentVC];
    
    homeVC.tabBarItem.title = @"留言板";
    contactVC.tabBarItem.title = @"通讯录";
    editNav.tabBarItem.title = @"编辑";
    docNav.tabBarItem.title = @"我的文档";
    
    homeVC.tabBarItem.image = [UIImage imageNamed:@"HomeBar"];
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"HomeBar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [homeVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateSelected];
    
    contactVC.tabBarItem.image = [UIImage imageNamed:@"ContactsBar"];
    contactVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"ContactsBar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [contactVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateSelected];
    
    editNav.tabBarItem.image = [UIImage imageNamed:@"EditBar"];
    editNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"EditBar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [editNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateSelected];
    
    docNav.tabBarItem.image = [UIImage imageNamed:@"DocumentBar"];
    docNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"DocumentBar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [docNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateSelected];
    
    tabbarController.viewControllers = @[homeVC, contactVC, editNav, docNav];
    
    return tabbarController;
}





@end
