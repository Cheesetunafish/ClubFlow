//
//  SigninViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/12.
//

#import "SigninViewController.h"
#import "MyTextField.h"

@interface SigninViewController ()

/// 账号输入框
@property (nonatomic, strong) MyTextField *emailField;
/// 设置密码框
@property (nonatomic, strong) MyTextField *firstPasswdField;
/// 确认密码
@property (nonatomic, strong) MyTextField *confirmPasswdField;


@end

@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"注册账号";
    
    // Do any additional setup after loading the view.
}

#pragma mark - Lazy Load


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
