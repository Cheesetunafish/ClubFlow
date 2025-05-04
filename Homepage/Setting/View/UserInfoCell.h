//
//  UserInfoCell.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoCell : UITableViewCell
/// image
@property (nonatomic, strong) UIImageView *profileImage;
/// nameLabel
@property (nonatomic, strong) UILabel *nameLabel;
/// emailLabel
@property (nonatomic, strong) UILabel *emailLabel;

- (void)configureWithName:(NSString *)name email:(NSString *)email avatar:(NSString *)avatarName;

@end

NS_ASSUME_NONNULL_END
