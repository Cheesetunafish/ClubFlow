//
//  AppDelegate.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/2/23.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
@import FirebaseCore;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Firebase认证
    [FIRApp configure];
    
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];

    [self.window makeKeyAndVisible];
    
    return YES;
}






@end
