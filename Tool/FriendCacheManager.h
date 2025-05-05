//
//  FriendCasheManager.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/5/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendCacheManager : NSObject
@property (nonatomic, strong) NSArray *cachedFriends;

+ (instancetype)sharedManager;
@end

NS_ASSUME_NONNULL_END
