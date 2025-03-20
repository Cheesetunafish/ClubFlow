//
//  UserModel.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/10.
//

#import "UserModel.h"
#import <Firebase/Firebase.h>
#import <FirebaseFirestore/FirebaseFirestore.h>

@implementation UserModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _email = dict[@"email"];
        _displayName = dict[@"displayName"];
        _photoUrl = dict[@"photoUrl"];
    }
    return self;
}

- (instancetype)initWithFirebaseUser:(FIRUser *)firebaseUser {
    self = [super init];
    if (self) {
        _email = firebaseUser.email;
        _displayName = firebaseUser.displayName;
        _photoUrl = firebaseUser.photoURL.absoluteString;// 可能为nil
    }
    return self;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.email) {
        dict[@"email"] = self.email;
    }
    if (self.displayName) {
        dict[@"displayName"] = self.displayName;
    }
    if (self.photoUrl) {
        dict[@"photoUrl"] = self.photoUrl;
    }
    return [dict copy];
}

-(void)registerUserWithEmail:(NSString *)email password:(NSString *)password {
    if (email.length == 0 || password.length == 0) {
        NSLog(@"请填写完整的邮箱和密码");
        return;
    }
    [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if (error) {
            NSLog(@"注册失败:%@", error.localizedDescription);
            // 根据错误提示用户具体原因
            return;
        }
        NSLog(@"注册成功，用户邮箱：%@", authResult.user.email);
        
        // 用 Firebase 返回的 FIRUser 初始化 UserModel 对象
        UserModel *userModel = [[UserModel alloc] initWithFirebaseUser:authResult.user];
                
        // 如果需要，你可以将扩展的用户数据保存到 Firestore 或 Realtime Database
        [self saveUserData:userModel];
        
    }];
}


- (void)saveUserData:(UserModel *)user {
    // 使用 Firestore 存储用户扩展数据
    NSDictionary *userDict = [user toDictionary];
    
    [[[FIRFirestore firestore] collectionWithPath:@"users"] documentWithPath:user.uid]
    setData:userDict
    completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"保存用户数据失败: %@", error.localizedDescription);
        } else {
            NSLog(@"用户数据保存成功");
        }
    }];
}


@end
