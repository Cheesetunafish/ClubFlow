//
//  UserManager.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/21.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject

+ (instancetype) sharedInstance;

/// 注册用户
- (void)registerUserWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(UserModel *user, NSError *error))completion;

/// 登录用户
- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
            completion:(void (^)(UserModel *user, NSError *error))completion;

/// 保存用户数据到 Firestore
- (void)saveUserData:(UserModel *)user completion:(void (^)(NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
