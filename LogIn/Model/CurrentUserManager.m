//
//  CurrentUserManager.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/5/4.
//

#import "CurrentUserManager.h"
#import "UserModel.h"
@import FirebaseAuth;

NSString * const UserProfileDidUpdateNotification = @"UserProfileDidUpdateNotification";

@implementation CurrentUserManager
+ (instancetype)sharedManager {
    static CurrentUserManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CurrentUserManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        FIRUser *firebaseUser = [FIRAuth auth].currentUser;
        if (firebaseUser) {
            _currentUser = [[UserModel alloc] initWithFirebaseUser:firebaseUser];
        }
    }
    return self;
}

- (void)updateWithDisplayName:(NSString *)displayName photoURL:(NSString *)photoURL {
    // 更新 Auth 用户
    FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
    changeRequest.displayName = displayName;
    changeRequest.photoURL = [NSURL URLWithString:photoURL];
    
    [changeRequest commitChangesWithCompletion:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"✅ Firebase Auth 更新成功");
            // 更新本地用户数据
            self.currentUser.displayName = displayName;
            self.currentUser.photoUrl = photoURL;
            [self broadcastUserUpdate];
        } else {
            NSLog(@"❌ Firebase Auth 更新失败: %@", error.localizedDescription);
        }
    }];
}

- (void)broadcastUserUpdate {
    [[NSNotificationCenter defaultCenter] postNotificationName:UserProfileDidUpdateNotification object:nil];
}


@end
