//
//  LoginViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/10.
//

#import "LoginViewController.h"
#import "SigninViewController.h"
#import "LoginView.h"


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
//    self.loginView.passwordField.alpha = 0;
    self.loginView.loginButton.alpha = 0;
    self.loginView.signinButton.alpha = 0;

    self.loginView.emailField.transform = CGAffineTransformMakeScale(0.5, 0.5);
//    self.loginView.passwordField.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.loginView.loginButton.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.loginView.signinButton.transform = CGAffineTransformMakeScale(0.5, 0.5);

    [UIView animateWithDuration:0.6 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.loginView.emailField.alpha = 1;
        self.loginView.emailField.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.6 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                self.loginView.passwordField.alpha = 1;
//                self.loginView.passwordField.transform = CGAffineTransformIdentity;
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
- (void)jumpToSignPage {
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
