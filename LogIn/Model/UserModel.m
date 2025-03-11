//
//  UserModel.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/10.
//

#import "UserModel.h"

@implementation UserModel

- (BOOL)isValidEmail {
    // 邮箱格式验证
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-0.-]+\\.[A-Za-z]{2,}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.email];
}


@end
