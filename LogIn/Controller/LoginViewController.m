//
//  LoginViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/10.
//

#import "LoginViewController.h"
#import "SigninViewController.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "MyTextField.h"


@interface LoginViewController ()
/// Title
@property (nonatomic, strong) UITextView *Title;
/// subTitle
@property (nonatomic, strong) UITextView *subTitle;
/// 账号输入框
@property (nonatomic, strong) MyTextField *emailField;
/// 密码输入框
@property (nonatomic, strong) MyTextField *passwordField;
/// 登录按钮
@property (nonatomic, strong) UIButton *loginButton;
/// 注册按钮
@property (nonatomic, strong) UIButton *signinButton;
/// signinPage
@property (nonatomic, strong) SigninViewController *signinPage;


@end

@implementation LoginViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.Title];
    [self.view addSubview:self.subTitle];
    [self.view addSubview:self.emailField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.signinButton];
    
    [self masMakePosition];
    [self showUpAnimation];
    
}

#pragma mark - Masonry
// Masonry布局和视图加载
- (void)masMakePosition {
    [self.Title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(42);
        make.width.mas_equalTo(200);
        make.top.equalTo(self.view.mas_top).mas_offset(160);
    }];
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.Title.mas_bottom).mas_offset(60);
    }];
    [self.emailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subTitle);
        make.right.offset(-20);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.subTitle.mas_bottom).mas_offset(20);
    }];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.emailField);
        make.right.equalTo(self.emailField);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.emailField.mas_bottom).mas_offset(20);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.passwordField.mas_bottom).mas_offset(40);
        make.width.mas_equalTo(60.02);
        make.height.mas_equalTo(44);
    }];
    [self.signinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(335);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.loginButton.mas_bottom).mas_offset(10);
    }];
}

#pragma mark - Animation
- (void)showUpAnimation {
    self.emailField.alpha = 0;
    self.passwordField.alpha = 0;
    self.loginButton.alpha = 0;
    self.signinButton.alpha = 0;

    self.emailField.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.passwordField.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.loginButton.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.signinButton.transform = CGAffineTransformMakeScale(0.5, 0.5);

    [UIView animateWithDuration:0.6 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.emailField.alpha = 1;
            self.emailField.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.6 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.passwordField.alpha = 1;
                self.passwordField.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.6 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.loginButton.alpha = 1;
                    self.loginButton.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.6 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        self.signinButton.alpha = 1;
                        self.signinButton.transform = CGAffineTransformIdentity;
                    } completion:nil];
                }];
            }];
        }];
    
}

#pragma mark - Lazy Load
- (UITextView *)Title {
    if (_Title == nil) {
        _Title = [[UITextView alloc] init];
        _Title.text = @"ClubFlow";
        _Title.textAlignment = NSTextAlignmentCenter;
        _Title.textColor = [UIColor blackColor];
        _Title.font = [UIFont boldSystemFontOfSize:20];
    }
    return _Title;
}

- (UITextView *)subTitle {
    if (_subTitle == nil) {
        _subTitle = [[UITextView alloc] init];
        _subTitle.text = @"从邮箱";
        _subTitle.textColor = [UIColor blackColor];
        _subTitle.font = [UIFont systemFontOfSize:15];
    }
    return _subTitle;
}

- (MyTextField *)emailField {
    if (_emailField == nil) {
        _emailField = [[MyTextField alloc] init];
        _emailField.placeholder = @"请输入邮箱账号...";
        _emailField.leftViewMode = UITextFieldViewModeAlways;
        _emailField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginTextfieldEmail"]];
    }
    return _emailField;
}

- (MyTextField *)passwordField {
    if (_passwordField == nil) {
        _passwordField = [[MyTextField alloc] init];
        _passwordField.placeholder = @"请输入密码...";
        _passwordField.secureTextEntry = YES;
        _passwordField.leftViewMode = UITextFieldViewModeAlways;
        _passwordField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginTextfieldPassword"]];
        _passwordField.rightViewMode = UITextFieldViewModeAlways;
        _passwordField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginTextfieldPasswordRight"]];
        [_passwordField rightViewGesture:_passwordField.rightView];
    }
    return _passwordField;
}


- (UIButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [[UIButton alloc] init];
        _loginButton.backgroundColor = [UIColor colorWithHexString:@"0066FF"];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _loginButton.layer.cornerRadius = 20;
        _loginButton.layer.masksToBounds = YES;
    }
    return _loginButton;
}

- (UIButton *)signinButton {
    if (_signinButton == nil) {
        _signinButton = [[UIButton alloc] init];
        [_signinButton setTitle:@"还没有账号？立即注册" forState:UIControlStateNormal];
        [_signinButton setTitleColor:[UIColor colorWithHexString:@"007AFF"] forState:UIControlStateNormal];
        _signinButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_signinButton addTarget:self action:@selector(jumpToSignPage) forControlEvents:UIControlEventTouchUpInside];
        _signinButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _signinButton;
}

- (SigninViewController *)signinPage {
    if (_signinPage == nil) {
        _signinPage = [[SigninViewController alloc] init];
    }
    return _signinPage;
}

#pragma mark - action
- (void)jumpToSignPage {
    NSLog(@"jumpready");
    NSLog(@"navigationController: %@", self.navigationController);

    if (self.signinPage) {
        [self.navigationController pushViewController:self.signinPage animated:YES];
    } else {
        NSLog(@"self.signinPage is nil!");
    }

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
