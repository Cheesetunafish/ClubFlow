//
//  LoginViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/10.
//

#import "LoginViewController.h"
#import "Masonry.h"
#import "UIColot+Hex.h"

@interface LoginViewController ()
/// Title
@property (nonatomic, strong) UITextView *Title;
/// subTitle
@property (nonatomic, strong) UITextView *subTitle;
/// 账号输入
@property (nonatomic, strong) UITextField *emailField;
/// 密码输入
@property (nonatomic, strong) UITextField *passwordField;
/// 登录按钮
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.Title];
    [self.view addSubview:self.subTitle];
    [self.view addSubview:self.emailField];
    self.view.backgroundColor = [UIColor whiteColor];
    [self masMakePosition];
    
}


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

- (UITextField *)emailField {
    if (_emailField == nil) {
        _emailField = [[UITextField alloc] init];
        _emailField.backgroundColor = [UIColor colorWithHexString:@"F3F4F6"];
        _emailField.placeholder = @"请输入邮箱账号...";
        _emailField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginTextfieldEmail"]];
    }
    return _emailField;
}

- (UITextField *)passwordField {
    if (_passwordField == nil) {
        _passwordField = [[UITextField alloc] init];
        _passwordField.backgroundColor = [UIColor colorWithHexString:@"F3F4F6"];
        _passwordField.placeholder = @"请输入密码...";
        _passwordField.secureTextEntry = YES;
        _passwordField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginTextfieldPassword"]];
    }
    return _passwordField;
}

#pragma mark - Masonry

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
