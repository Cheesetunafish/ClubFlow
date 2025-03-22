//
//  LoginViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/10.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SigninViewController.h"
#import "CommentViewController.h"
#import "LoginView.h"
#import "UserModel.h"
@import FirebaseAuth;


@interface LoginViewController ()
/// loginView
@property (nonatomic, strong) LoginView *loginView;
/// signinPage
@property (nonatomic, strong) SigninViewController *signinPage;

@end

@implementation LoginViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = self.loginView;
    [self showUpAnimation];
    
}


#pragma mark - Animation
- (void)showUpAnimation {
    self.loginView.emailField.alpha = 0;
    self.loginView.passwordField.alpha = 0;
    self.loginView.loginButton.alpha = 0;
    self.loginView.signinButton.alpha = 0;

    self.loginView.emailField.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.loginView.passwordField.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.loginView.loginButton.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.loginView.signinButton.transform = CGAffineTransformMakeScale(0.5, 0.5);

    [UIView animateWithDuration:0.6 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.loginView.emailField.alpha = 1;
        self.loginView.emailField.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.6 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.loginView.passwordField.alpha = 1;
                self.loginView.passwordField.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.6 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.loginView.loginButton.alpha = 1;
                    self.loginView.loginButton.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.6 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        self.loginView.signinButton.alpha = 1;
                        self.loginView.signinButton.transform = CGAffineTransformIdentity;
                    } completion:nil];
                }];
            }];
        }];
    
}


#pragma mark - Lazy Load
- (LoginView *)loginView {
    if (_loginView == nil) {
        _loginView = [[LoginView alloc] initWithFrame:self.view.frame];
        [_loginView.signinButton addTarget:self action:@selector(jumpToSignPage) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.loginButton addTarget:self action:@selector(logInToHome) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginView;
}
- (SigninViewController *)signinPage {
    if (_signinPage == nil) {
        _signinPage = [[SigninViewController alloc] init];
    }
    return _signinPage;
}


#pragma mark - action
// 注册按钮点击
- (void)jumpToSignPage {
    if (self.signinPage) {
        [self.navigationController pushViewController:self.signinPage animated:YES];
    } else {
        NSLog(@"self.signinPage is nil!");
    }
}
// 登录按钮点击方法
- (void)logInToHome {
    NSString *email = self.loginView.emailField.text;
    NSString *password = self.loginView.passwordField.text;
    // 1.验证邮箱是否正确
    BOOL isValid = [self isValidEmail:email];
    if (email.length == 0 || password.length == 0) {
        // 错误提示
        [self showErrorHint:@"请输入完整的邮箱和密码"];
        NSLog(@"请输入完整的邮箱和密码");
        return;
    }
    if (isValid == YES) {
        // 2.Firebase验证用户账号密码
        [[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if (error) {
                // 错误提示
                [self showErrorHint:@"登录失败"];
                NSLog(@"登录失败:%@", error.localizedDescription);// 错误提示
                return;
            }
            NSLog(@"登录成功");
            
            // 使用Firebase返回的FIRUser对象创建UserModel实例
            FIRUser *firebaseUser = authResult.user;
            UserModel *userModel = [[UserModel alloc] initWithFirebaseUser:firebaseUser];
            // 3.进入主页
            [self proceedToMainScreenWithUser:userModel];
        }];
  
    } else {
        [self showErrorHint:@"邮箱格式错误"];
        NSLog(@"邮箱格式错误");
        return;
    }
}

// 邮箱格式验证
- (BOOL)isValidEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-0.-]+\\.[A-Za-z]{2,}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
// 登录成功进入主页
- (void)proceedToMainScreenWithUser:(UserModel *)user {
    NSLog(@"用户数据：%@", [user toDictionary]);
    
    // 获取 AppDelegate 实例
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *tabBarController = [appDelegate createTabBarController];
    tabBarController.modalPresentationStyle = UIModalPresentationFullScreen;// 全屏模式
    [self presentViewController:tabBarController animated:YES completion:nil];// 模块弹出首页
}
// 展示错误提示
- (void)showErrorHint:(NSString *)errorText {
    if (self.loginView.errorText.hidden == YES) {
        self.loginView.errorText.hidden = NO;
    }
    self.loginView.errorText.text = errorText;
    return;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
