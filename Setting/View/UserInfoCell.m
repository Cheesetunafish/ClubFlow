//
//  UserInfoCell.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/23.
//

#import "UserInfoCell.h"
#import "Masonry.h"
#import "UIColor+Hex.h"

@implementation UserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        self.backgroundColor = [UIColor colorWithHexString:@"9CA3AF"];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.profileImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.emailLabel];
    
    [self.profileImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(64);
        make.left.equalTo(self.contentView).mas_offset(16);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileImage);
        make.left.equalTo(self.profileImage.mas_right).mas_offset(15);
        make.width.mas_equalTo(327);
        make.height.mas_equalTo(34);
    }];
    [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.profileImage);
        make.left.equalTo(self.profileImage.mas_right).mas_offset(15);
        make.width.mas_equalTo(327);
        make.height.mas_equalTo(30);
    }];
    
}

- (UIImageView *)profileImage {
    if (!_profileImage) {
        _profileImage = [[UIImageView alloc] init];
    }
    return _profileImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"测试nameLabel";
        _nameLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    return _nameLabel;
}

- (UILabel *)emailLabel {
    if (!_emailLabel) {
        _emailLabel = [[UILabel alloc] init];
        _emailLabel.text = @"测试email.com";
        _emailLabel.textColor = [UIColor colorWithHexString:@"6B7280"];
    }
    return _emailLabel;
}


- (void)configureWithName:(nonnull NSString *)name email:(nonnull NSString *)email avatar:(nonnull NSString *)avatarName {
    self.nameLabel.text = name;
    self.emailLabel.text = email;
    self.profileImage.image = [UIImage imageNamed:avatarName] ?: [UIImage imageNamed:@"default_avatar"]; // 占位图
}

@end
