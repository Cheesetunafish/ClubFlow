//
//  FriendpageViewController.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/5/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface FriendPageViewController : UIViewController

@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *remarkName; // 备注名称
@property (nonatomic, copy) NSString *avatarUrl;  // 头像URL

@end

NS_ASSUME_NONNULL_END
