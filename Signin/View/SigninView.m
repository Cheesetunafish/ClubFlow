//
//  SigninView.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/13.
//

#import "SigninView.h"
#import "MyTextField.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
@interface SigninView ()

@end

@implementation SigninView

#pragma mark - Instancetype
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

#pragma mark - methods
- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleImage];
    [self addSubview:self.emailField];
//    [self addSubview:self.firstPasswdField];
//    [self addSubview:self.confirmPasswdField];
    [self addSubview:self.verifyField];
    [self addSubview:self.sendVerityButton];
    [self addSubview:self.signInButton];
    [self addSubview:self.loginButton];
    
    [self masMakePosition];
}

#pragma mark - Masonry
- (void)masMakePosition {
    [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(327);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.mas_top).mas_offset(160);
    }];
    
    [self.emailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(327);
        make.height.mas_equalTo(48);
        make.top.equalTo(self.titleImage.mas_bottom).mas_offset(40);
    }];
    
//    [self.firstPasswdField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.width.mas_equalTo(327);
//        make.height.mas_equalTo(48);
//        make.top.equalTo(self.emailField.mas_bottom).mas_offset(20);
//    }];
    
//    [self.confirmPasswdField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.width.mas_equalTo(327);
//        make.height.mas_equalTo(48);
//        make.top.equalTo(self.firstPasswdField.mas_bottom).mas_offset(20);
//    }];
    
    [self.verifyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(213);
        make.height.mas_equalTo(48);
        make.left.equalTo(self.emailField);
        make.top.equalTo(self.emailField.mas_bottom).mas_offset(20);
    }];
    [self.sendVerityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.verifyField);
        make.width.mas_equalTo(102);
        make.height.mas_equalTo(48);
        make.left.equalTo(self.verifyField.mas_right).mas_offset(12);
    }];
    
    [self.signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(327);
        make.height.mas_equalTo(48);
        make.top.equalTo(self.sendVerityButton.mas_bottom).mas_offset(40);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(327);
        make.height.mas_equalTo(21);
        make.top.equalTo(self.signInButton.mas_bottom).mas_offset(20);
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

- (MyTextField *)emailField {
    if (_emailField == nil) {
        _emailField = [[MyTextField alloc] init];
        _emailField.placeholder = @"请输入邮箱地址";
        _emailField.rightViewMode = UITextFieldViewModeAlways;
        _emailField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SigninTextfieldEmail"]];
    }
    return _emailField;
}

//- (MyTextField *)firstPasswdField {
//    if (_firstPasswdField == nil) {
//        _firstPasswdField = [[MyTextField alloc] init];
//        _firstPasswdField.placeholder = @"请设置密码";
//        _firstPasswdField.rightViewMode = UITextFieldViewModeAlways;
//        _firstPasswdField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SigninTextfieldPassword"]];
//        [_firstPasswdField rightViewGesture:_firstPasswdField.rightView];
//    }
//    return _firstPasswdField;
//}

//- (MyTextField *)confirmPasswdField {
//    if (_confirmPasswdField == nil) {
//        _confirmPasswdField = [[MyTextField alloc] init];
//        _confirmPasswdField.placeholder = @"请确认密码";
//        _confirmPasswdField.rightViewMode = UITextFieldViewModeAlways;
//        _confirmPasswdField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SigninTextfieldPassword"]];
//        [_confirmPasswdField rightViewGesture:_confirmPasswdField.rightView];
//        
//    }
//    return _confirmPasswdField;
//}

- (MyTextField *)verifyField {
    if (_verifyField == nil) {
        _verifyField = [[MyTextField alloc] init];
        _verifyField.placeholder = @"请输入验证码";
        
    }
    return _verifyField;
}

- (UIButton *)sendVerityButton {
    if (_sendVerityButton == nil) {
        _sendVerityButton = [[UIButton alloc] init];
        _sendVerityButton.backgroundColor = [UIColor colorWithHexString:@"4F46E5"];
        [_sendVerityButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendVerityButton.layer.cornerRadius = 5;
        _sendVerityButton.titleLabel.font = [UIFont systemFontOfSize:15];
        //TODO: 按钮action：发送验证码
    }
    return _sendVerityButton;
}

- (UIButton *)signInButton {
    if (_signInButton == nil) {
        _signInButton = [[UIButton alloc] init];
        [_signInButton setTitle:@"立即注册" forState:UIControlStateNormal];
        _signInButton.backgroundColor = [UIColor colorWithHexString:@"4F46E5"];
        _signInButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _signInButton.layer.cornerRadius = 5;
        //TODO: 按钮action：注册
    }
    return _signInButton;
}

- (UIButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:@"已有账号？立即登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor colorWithHexString:@"4F46E5"] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:15];

    }
    return _loginButton;
}



@end
