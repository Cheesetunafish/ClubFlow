//
//  AuthManager.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/13.
//

#import "AuthManager.h"
@import FirebaseAuth;


@implementation AuthManager

+ (void)sendVerificationCodeToEmail:(NSString *)email completion:(void (^)(BOOL, NSString * _Nullable))completion {
    [[FIRAuth auth] sendSignInLinkToEmail:email actionCodeSettings:[self getActionCodeSettings] completion:^(NSError * _Nullable) {
        
    }];
}

+ (FIRActionCodeSettings *)getActionCodeSettings {
    FIRActionCodeSettings *settings = [[FIRActionCodeSettings alloc] init];
    settings.URL = [NSURL URLWithString:@"https://clubflow.com"];
    settings.handleCodeInApp = YES;
    settings.iOSBundleID = [[NSBundle mainBundle] bundleIdentifier];
    return settings;
}

@end
