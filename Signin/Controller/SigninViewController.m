//
//  SigninViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/12.
//

#import "SigninViewController.h"
#import "SigninView.h"
@interface SigninViewController ()

/// view
@property (nonatomic, strong) SigninView *signinView;

@end

@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"注册账号";
    self.view = self.signinView;
    
}


#pragma mark - Lazy Load
- (SigninView *)signinView {
    if (_signinView == nil) {
        _signinView = [[SigninView alloc] initWithFrame:self.view.frame];
        [_signinView.loginButton addTarget:self action:@selector(backToLoginPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signinView;
}

#pragma mark - action
- (void)backToLoginPage {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
