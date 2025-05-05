//
//  UserModel.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/10.
//

#import "UserModel.h"
#import <Firebase/Firebase.h>


@implementation UserModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _uid = dict[@"uid"];
        _email = dict[@"email"];
        _displayName = dict[@"displayName"];
        _photoUrl = dict[@"photoUrl"];
    }
    return self;
}

- (instancetype)initWithFirebaseUser:(FIRUser *)firebaseUser {
    self = [super init];
    if (self) {
        _uid = firebaseUser.uid;
        _email = firebaseUser.email;
        _displayName = firebaseUser.displayName;
        _photoUrl = firebaseUser.photoURL.absoluteString;// 可能为nil
    }
    return self;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.uid) {
        dict[@"uid"] = self.uid;
    }
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


@end
