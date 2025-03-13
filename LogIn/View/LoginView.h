//
//  LoginView.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/13.
//

#import <UIKit/UIKit.h>
#import "MyTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginView : UIView
/// Title
@property (nonatomic, strong) UIImageView *titleImage;
/// emailTitle
@property (nonatomic, strong) UITextView *subTitle;
/// 账号输入框
@property (nonatomic, strong) MyTextField *emailField;
/// 密码输入框
@property (nonatomic, strong) MyTextField *passwordField;
/// 登录按钮
@property (nonatomic, strong) UIButton *loginButton;
/// 注册按钮
@property (nonatomic, strong) UIButton *signinButton;

@end

NS_ASSUME_NONNULL_END
