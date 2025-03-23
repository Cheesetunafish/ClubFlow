//
//  TopView.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/21.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TopView : UIView
///  头像
@property (nonatomic, strong) UIImageView *profileImage;
/// 用户名
@property (nonatomic, strong) UILabel *userName;
/// email
@property (nonatomic, strong) UILabel *userEmail;

- (instancetype)initWithUser:(UserModel *)user;
@end

NS_ASSUME_NONNULL_END
