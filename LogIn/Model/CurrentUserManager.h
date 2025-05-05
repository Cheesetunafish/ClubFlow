//
//  CurrentUserManager.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/5/4.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN
// 通知名：用于跨页面刷新
extern NSString * const UserProfileDidUpdateNotification;

@interface CurrentUserManager : NSObject

@property (nonatomic, strong, nullable) UserModel *currentUser;

+ (instancetype)sharedManager;

/// 更新当前用户信息（并发送通知）
- (void)updateWithDisplayName:(NSString *)displayName photoURL:(NSString *)photoURL;

/// 手动触发通知（例如登录后同步）
- (void)broadcastUserUpdate;
@end

NS_ASSUME_NONNULL_END
