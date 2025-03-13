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

/// 发送验证码按钮
@property (nonatomic, strong) UIButton *sendVerityButton;
/// 立即注册
@property (nonatomic, strong) UIButton *signInButton;
/// 已有账号，回到登录页按钮
@property (nonatomic, strong) UIButton *loginButton;
@end

NS_ASSUME_NONNULL_END
