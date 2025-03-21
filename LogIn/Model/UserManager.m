//
//  UserManager.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/21.
//

#import "UserManager.h"
@import FirebaseAuth;
#import <FirebaseFirestore/FirebaseFirestore.h>

@implementation UserManager

+ (instancetype)sharedInstance {
    static UserManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)registerUserWithEmail:(NSString *)email
                     password:(NSString *)password
                   completion:(void (^)(UserModel *user, NSError *error))completion {
    [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        UserModel *userModel = [[UserModel alloc] initWithFirebaseUser:authResult.user];
        
        // 立即保存用户数据到 Firestore
        [self saveUserData:userModel completion:^(NSError *error) {
            if (error) {
                NSLog(@"用户数据保存失败: %@", error.localizedDescription);
            }
            completion(userModel, nil);
        }];
    }];
}

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
            completion:(void (^)(UserModel *user, NSError *error))completion {
    
    [[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        UserModel *userModel = [[UserModel alloc] initWithFirebaseUser:authResult.user];
        completion(userModel, nil);
    }];
}

- (void)saveUserData:(UserModel *)user completion:(void (^)(NSError *error))completion {
    NSDictionary *userDict = [user toDictionary];
    
    [[[[FIRFirestore firestore] collectionWithPath:@"users"] documentWithPath:user.uid]
    setData:userDict
    completion:^(NSError * _Nullable error) {
        completion(error);
    }];
}


@end
