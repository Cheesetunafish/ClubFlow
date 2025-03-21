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
///  标语1
@property (nonatomic, strong) UITextView *subTitle;
/// 标语2
@property (nonatomic, strong) UITextView *subTitle2;
/// 图片
@property (nonatomic, strong) UIImageView *imageView;
/// 账号输入框
@property (nonatomic, strong) MyTextField *emailField;
/// 密码输入框
@property (nonatomic, strong) MyTextField *passwordField;
/// 错误提示
@property (nonatomic, strong) UITextView *errorText;
/// 登录按钮
@property (nonatomic, strong) UIButton *loginButton;
/// 注册按钮
@property (nonatomic, strong) UIButton *signinButton;

@end

NS_ASSUME_NONNULL_END
