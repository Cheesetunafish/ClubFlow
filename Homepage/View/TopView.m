//
//  TopView.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/21.
//

#import "TopView.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "Macros.h"

@implementation TopView
- (instancetype)initWithUser:(UserModel *)user {
    self = [super init];
    if (self) {
        [self setUpViews];
        self.userName.text = user.displayName;
        self.userEmail.text = user.email;
    }
    return self;
}

- (void)setUpViews {
    [self addSubview:self.profileImage];
    [self addSubview:self.userName];
    [self addSubview:self.userEmail];
    
    [self masMakePosition];
}

- (void)masMakePosition {
    [self.profileImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(16);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(68);
        make.top.equalTo(self).mas_offset(10);
    }];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.profileImage.mas_right).mas_offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(38);
        make.top.mas_equalTo(self.profileImage);
    }];
    [self.userEmail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userName);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.profileImage);
    }];
}

- (UIImageView *)profileImage {
    if (!_profileImage) {
        _profileImage = [[UIImageView alloc] init];
        _profileImage.layer.cornerRadius = 20;
        _profileImage.backgroundColor = [UIColor lightGrayColor];
    }
    return _profileImage;
}

- (UITextView *)userName {
    if (!_userName) {
        _userName = [[UITextView alloc] init];
        _userName.textColor = [UIColor blackColor];
        _userName.font = [UIFont systemFontOfSize:20];
    }
    return _userName;
}

- (UITextView *)userEmail {
    if (!_userEmail) {
        _userEmail = [[UITextView alloc] init];
        _userEmail.textColor = [UIColor colorWithHexString:@"6B7280"];
        _userEmail.font = [UIFont systemFontOfSize:15];
    }
    return _userEmail;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
