//
//  FriendpageViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/5/5.
//

#import "FriendpageViewController.h"
#import "Masonry.h"
#import "SDWebImage.h"

@interface FriendPageViewController ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *displayNameLabel;
@property (nonatomic, strong) UILabel *emailTitleLabel;
@property (nonatomic, strong) UILabel *emailValueLabel;
@property (nonatomic, strong) UILabel *remarkTitleLabel;
@property (nonatomic, strong) UILabel *remarkValueLabel;

@end

@implementation FriendPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人资料";
    [self setupUI];
}


- (void)setupUI {
    [self.view addSubview:self.avatarImageView];
    [self.view addSubview:self.displayNameLabel];
    [self.view addSubview:self.emailTitleLabel];
    [self.view addSubview:self.emailValueLabel];
    [self.view addSubview:self.remarkTitleLabel];
    [self.view addSubview:self.remarkValueLabel];

    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(90);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(90);
    }];

    [self.displayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(16);
        make.centerX.equalTo(self.view);
    }];

    [self.emailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.displayNameLabel.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(24);
        make.width.mas_equalTo(80);
    }];
    [self.emailValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.emailTitleLabel);
        make.right.equalTo(self.view).offset(-24);
        make.left.equalTo(self.emailTitleLabel.mas_right).offset(10);
    }];

    [self.remarkTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailTitleLabel.mas_bottom).offset(32);
        make.left.equalTo(self.view).offset(24);
        make.width.mas_equalTo(80);
    }];
    [self.remarkValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.remarkTitleLabel);
        make.right.equalTo(self.view).offset(-24);
        make.left.equalTo(self.remarkTitleLabel.mas_right).offset(10);
    }];
}

#pragma mark - lazy load
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 45;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        if (self.avatarUrl) {
            [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.avatarUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        } else {
            _avatarImageView.image = [UIImage imageNamed:@"default_avatar"];
        }
    }
    return _avatarImageView;
}
- (UILabel *)displayNameLabel {
    if (!_displayName) {
        _displayNameLabel = [[UILabel alloc] init];
        _displayNameLabel.font = [UIFont boldSystemFontOfSize:22];
        _displayNameLabel.textAlignment = NSTextAlignmentCenter;
        _displayNameLabel.text = self.displayName ?: @"";
    }
    return _displayName;
}
- (UILabel *)emailTitleLabel {
    if (!_emailTitleLabel) {
        _emailTitleLabel = [[UILabel alloc] init];
        _emailTitleLabel.text = @"邮箱";
        _emailTitleLabel.font = [UIFont systemFontOfSize:16];
        _emailTitleLabel.textColor = [UIColor darkGrayColor];
    }
    return _emailTitleLabel;
}
- (UILabel *)emailValueLabel {
    if (!_emailValueLabel) {
        _emailValueLabel = [[UILabel alloc] init];
        _emailValueLabel.text = self.email ?: @"";
        _emailValueLabel.font = [UIFont systemFontOfSize:16];
        _emailValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _emailValueLabel;
}
- (UILabel *)remarkTitleLabel {
    if (!_remarkTitleLabel) {
        _remarkTitleLabel = [[UILabel alloc] init];
        _remarkTitleLabel.text = @"备注名称";
        _remarkTitleLabel.font = [UIFont systemFontOfSize:16];
        _remarkTitleLabel.textColor = [UIColor darkGrayColor];
    }
    return _remarkTitleLabel;
}
- (UILabel *)remarkValueLabel {
    if (!_remarkValueLabel) {
        _remarkValueLabel = [[UILabel alloc] init];
        _remarkValueLabel.text = self.remarkName ?: @"";
        _remarkValueLabel.font = [UIFont systemFontOfSize:16];
        _remarkValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _remarkValueLabel;
}

@end
