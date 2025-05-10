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
    
    // 设置动态链接处理
    [self setupDynamicLinks];
    
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
// 处理应用启动时的动态链接
- (void)setupDynamicLinks {
    
    FIRDynamicLink *dynamicLink = [[FIRDynamicLinks dynamicLinks] dynamicLinkFromCustomSchemeURL:[NSURL URLWithString:@"com.clubflow.app"]];
    if (dynamicLink) {
        [self handleDynamicLink:dynamicLink];
    }
}
// 处理通用链接
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    
    return [[FIRDynamicLinks dynamicLinks] handleUniversalLink:userActivity.webpageURL
                                                    completion:^(FIRDynamicLink * _Nullable dynamicLink, NSError * _Nullable error) {
        if (dynamicLink) {
            [self handleDynamicLink:dynamicLink];
        }
    }];
}
// 处理自定义URL scheme
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.scheme isEqualToString:@"myapp"]) {
        if ([url.host isEqualToString:@"invite"]) {
            // 解析URL参数
            NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
            NSArray *queryItems = components.queryItems;
            
            NSString *inviterUID = nil;
            for (NSURLQueryItem *item in queryItems) {
                if ([item.name isEqualToString:@"inviter"]) {
                    inviterUID = item.value;
                    break;
                }
            }
            
            if (inviterUID) {
                // 保存邀请者UID到UserDefaults，等待用户登录后处理
                [[NSUserDefaults standardUserDefaults] setObject:inviterUID forKey:@"pendingInviterUID"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // 如果用户已登录，直接处理好友关系
                if ([FIRAuth auth].currentUser) {
                    [self processFriendshipWithInviter:inviterUID];
                }
            }
        }
        return YES;
    }
    return NO;
}

- (void)handleDynamicLink:(FIRDynamicLink *)dynamicLink {
    NSURL *url = dynamicLink.url;
    if (!url) return;
    
    // 解析URL参数
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSArray *queryItems = components.queryItems;
    
    NSString *inviterUID = nil;
    for (NSURLQueryItem *item in queryItems) {
        if ([item.name isEqualToString:@"inviter"]) {
            inviterUID = item.value;
            break;
        }
    }
    
    if (inviterUID) {
        // 保存邀请者UID到UserDefaults，等待用户登录后处理
        [[NSUserDefaults standardUserDefaults] setObject:inviterUID forKey:@"pendingInviterUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 如果用户已登录，直接处理好友关系
        if ([FIRAuth auth].currentUser) {
            [self processFriendshipWithInviter:inviterUID];
        }
    }
}

- (void)processFriendshipWithInviter:(NSString *)inviterUID {
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    if (!currentUser) return;
    
    // 确保uidA < uidB，以保持一致性
    NSString *uidA = [currentUser.uid compare:inviterUID] == NSOrderedAscending ? currentUser.uid : inviterUID;
    NSString *uidB = [currentUser.uid compare:inviterUID] == NSOrderedAscending ? inviterUID : currentUser.uid;
    
    // 创建好友关系记录
    NSString *friendshipID = [NSString stringWithFormat:@"%@_%@", uidA, uidB];
    NSDictionary *friendshipData = @{
        @"user1": uidA,
        @"user2": uidB,
        @"createdAt": [FIRServerValue timestamp]
    };
    
    // 保存到Firestore
    FIRFirestore *db = [FIRFirestore firestore];
    [[[db collectionWithPath:@"friendships"] documentWithPath:friendshipID] setData:friendshipData
                                                                        completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error adding friendship: %@", error);
        } else {
            // 清除待处理的邀请者UID
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pendingInviterUID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 显示成功提示
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加好友成功"
                                                                             message:@"您已成功添加好友"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            });
        }
    }];
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
    
    homeVC.tabBarItem.title = @"首页";
    contactVC.tabBarItem.title = @"通讯录";
    editNav.tabBarItem.title = @"编辑";
    docNav.tabBarItem.title = @"共享文档";
    
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
    
    tabbarController.viewControllers = @[homeVC, contactVC, docNav];
    
    return tabbarController;
}





@end
