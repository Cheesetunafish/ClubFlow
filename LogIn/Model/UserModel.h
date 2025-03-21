//
//  UserModel.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/10.
//

#import <Foundation/Foundation.h>
#import <FirebaseAuth/FirebaseAuth.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject
/// uid
@property (nonatomic, copy) NSString *uid;
/// email
@property (nonatomic, copy) NSString *email;
/// 用户名
@property (nonatomic, copy) NSString *displayName;
/// 头像链接
@property (nonatomic, copy) NSString *photoUrl;

/// 通过字典初始化
- (instancetype)initWithDictionary:(NSDictionary *)dict;
/// 通过FIrebase用户对象初始化
- (instancetype)initWithFirebaseUser:(FIRUser *)firebaseUser;
/// 将UserModel对象转换成字典
- (NSDictionary *)toDictionary;

@end


NS_ASSUME_NONNULL_END
