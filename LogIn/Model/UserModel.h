//
//  UserModel.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

/// email number
@property (nonatomic, strong) NSString *email;
/// password
@property (nonatomic, strong) NSString *password;

- (BOOL)isValidEmail;
@end


NS_ASSUME_NONNULL_END
