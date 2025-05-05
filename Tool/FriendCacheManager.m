//
//  FriendCasheManager.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/5/5.
//

#import "FriendCacheManager.h"

@implementation FriendCacheManager

+ (instancetype)sharedManager {
    static FriendCacheManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
@end
