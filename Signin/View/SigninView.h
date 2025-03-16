//
//  SigninView.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/13.
//

#import <UIKit/UIKit.h>
#import "MyTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface SigninView : UIView
/// titile
@property (nonatomic, strong) UIImageView *titleImage;
/// 账号输入框
@property (nonatomic, strong) MyTextField *emailField;
/// 设置密码框
//@property (nonatomic, strong) MyTextField *firstPasswdField;
/// 确认密码
//@property (nonatomic, strong) MyTextField *confirmPasswdField;
/// 验证码
@property (nonatomic, strong) MyTextField *verifyField;
/// 发送验证码按钮
@property (nonatomic, strong) UIButton *sendVerityButton;
/// 立即注册
@property (nonatomic, strong) UIButton *signInButton;
/// 已有账号，回到登录页按钮
@property (nonatomic, strong) UIButton *loginButton;
@end

NS_ASSUME_NONNULL_END
