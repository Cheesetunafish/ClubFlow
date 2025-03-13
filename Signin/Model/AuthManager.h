//
//  AuthManager.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthManager : NSObject

+ (void)sendVerificationCodeToEmail:(NSString *)email completion:(void (^)(BOOL success, NSString *_Nullable errorMessage))completion;

@end

NS_ASSUME_NONNULL_END
