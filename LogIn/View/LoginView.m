//
//  LoginView.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/13.
//

#import "LoginView.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "MyTextField.h"

@interface LoginView ()

@end
@implementation LoginView
#pragma mark - Instancetype
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

#pragma mark - methods
- (void)setUpViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleImage];
    [self addSubview:self.subTitle];
    [self addSubview:self.subTitle2];
    [self addSubview:self.imageView];
    [self addSubview:self.emailField];
    [self addSubview:self.passwordField];
    [self addSubview:self.loginButton];
    [self addSubview:self.signinButton];
    [self masMakePosition];
}

#pragma mark - Masonry
// Masonry布局和视图加载
- (void)masMakePosition {
    [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(42);
        make.width.mas_equalTo(327);
        make.top.equalTo(self.mas_top).mas_offset(120);
    }];
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(20);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.titleImage.mas_bottom).mas_offset(20);
    }];
    [self.subTitle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self.subTitle);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.subTitle.mas_bottom).mas_offset(10);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.right.equalTo(self).mas_offset(-100);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(200);
        make.top.equalTo(self.subTitle2.mas_bottom).mas_offset(50);
    }];
    [self.emailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subTitle);
        make.right.offset(-20);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.imageView.mas_bottom).mas_offset(20);
    }];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.emailField);
        make.right.equalTo(self.emailField);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.emailField.mas_bottom).mas_offset(20);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.passwordField.mas_bottom).mas_offset(40);
        make.width.mas_equalTo(60.02);
        make.height.mas_equalTo(44);
    }];
    [self.signinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(335);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.loginButton.mas_bottom).mas_offset(10);
    }];
}


#pragma mark - Lazy Load
- (UIImageView *)titleImage {
    if (_titleImage == nil) {
        _titleImage = [[UIImageView alloc] init];
        _titleImage.image = [UIImage imageNamed:@"ClubFlowTitle"];
    }
    return _titleImage;
}

- (UITextView *)subTitle {
    if (_subTitle == nil) {
        _subTitle = [[UITextView alloc] init];
        _subTitle.text = @"Think it.Make it.";
        _subTitle.textColor = [UIColor blackColor];
        _subTitle.font = [UIFont boldSystemFontOfSize:25];
    }
    return _subTitle;
}
- (UITextView *)subTitle2 {
    if (_subTitle2 == nil) {
        _subTitle2 = [[UITextView alloc] init];
        _subTitle2.text = @"登入你的ClubFlow账号";
        _subTitle2.textColor = [UIColor grayColor];
        _subTitle2.font = [UIFont systemFontOfSize:20];
    }
    return _subTitle2;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginImage"]];
    }
    return _imageView;
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
        _loginButton.layer.cornerRadius = 10;
        _loginButton.layer.masksToBounds = YES;
        //TODO: 登录，验证用户
    }
    return _loginButton;
}

- (UIButton *)signinButton {
    if (_signinButton == nil) {
        _signinButton = [[UIButton alloc] init];
        [_signinButton setTitle:@"还没有账号？立即注册" forState:UIControlStateNormal];
        [_signinButton setTitleColor:[UIColor colorWithHexString:@"007AFF"] forState:UIControlStateNormal];
        _signinButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _signinButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _signinButton;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
