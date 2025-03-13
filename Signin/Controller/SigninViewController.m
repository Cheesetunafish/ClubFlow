//
//  SigninViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/12.
//

#import "SigninViewController.h"
#import "SigninView.h"
#import "AuthManager.h"

@interface SigninViewController ()

/// view
@property (nonatomic, strong) SigninView *signinView;
/// 计时器
@property (nonatomic, strong) NSTimer *timer;
/// 计数
@property (nonatomic, assign) NSInteger countdown;
@end

@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册账号";
    self.view = self.signinView;
    
    self.countdown = 60;
}


#pragma mark - count
- (void)startCountdown {
    self.countdown = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountDown) userInfo:nil repeats:YES];// MARK: 👀
}

- (void)updateCountDown {
    if (self.countdown > 0) {
        self.countdown--;
        [self.signinView.sendVerityButton setTitle:[NSString stringWithFormat:@"%lds", (long)self.countdown] forState:UIControlStateDisabled];
    } else {
        [self.timer invalidate];
        self.signinView.sendVerityButton.enabled = YES;
        [self.signinView.sendVerityButton setTitle:@"重新发送" forState:UIControlStateNormal];
    }
}

#pragma mark - Lazy Load
- (SigninView *)signinView {
    if (_signinView == nil) {
        _signinView = [[SigninView alloc] initWithFrame:self.view.frame];
        [_signinView.loginButton addTarget:self action:@selector(backToLoginPage) forControlEvents:UIControlEventTouchUpInside];
        [_signinView.sendVerityButton addTarget:self action:@selector(sendCodeonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signinView;
}

#pragma mark - action
- (void)backToLoginPage {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendCodeonTapped {
    NSString *email = self.signinView.emailField.text;
    
    if (email.length == 0) {
        NSLog(@"请输入邮箱");
        return;
    }
    self.signinView.sendVerityButton.enabled = NO;
    [self startCountdown];
    
    [AuthManager sendVerificationCodeToEmail:email completion:^(BOOL success, NSString * _Nullable errorMessage) {
            if (success) {
                NSLog(@"验证码已发送，请检查邮箱📮");
            } else {
                NSLog(@"发送失败:%@", errorMessage);
                self.signinView.sendVerityButton.enabled = YES;
                [self.timer invalidate];
                self.signinView.sendVerityButton.titleLabel.text = @"重新发送";//MARK: 👀
            }
    }];
}



@end
