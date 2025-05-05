//
//  CommentCell.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/19.
//

#import "CommentCell.h"
#import "CommentModel.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

@interface CommentCell ()
//@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *replyButton;
//@property (nonatomic, strong) UIButton *likeButton;
//@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, strong) UIView *replyContainerView;
@end

@implementation CommentCell
#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.replyButton];
//        [self.contentView addSubview:self.likeButton];
//        [self.contentView addSubview:self.likeCountLabel];
        [self.contentView addSubview:self.replyContainerView];
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints {
//    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(self.contentView).offset(16);
//        make.width.height.mas_equalTo(40);
//    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.centerY.equalTo(self.nameLabel);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
        make.right.equalTo(self.contentView).offset(-16);
    }];
//    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.nameLabel);
//        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
//        make.width.height.mas_equalTo(24);
//    }];
//    [self.likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.likeButton.mas_right).offset(4);
//        make.centerY.equalTo(self.likeButton);
//    }];
    [self.replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeLabel.mas_right);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
    }];
    [self.replyContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.replyButton.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-16);
        make.bottom.equalTo(self.contentView).offset(-12);
        make.height.greaterThanOrEqualTo(@0);
    }];
}

#pragma mark - 数据绑定
- (void)setCommentModel:(CommentModel *)commentModel {
    _commentModel = commentModel;
//    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.nameLabel.text = commentModel.displayName;
    self.timeLabel.text = commentModel.timeString;
    self.contentLabel.text = commentModel.text;
//    [self.likeButton setSelected:commentModel.liked];
//    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld", (long)commentModel.likeCount];
    // 清空旧回复
    [self.replyContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *lastView = nil;
    for (CommentModel *reply in commentModel.replyArray) {
        UILabel *replyLabel = [[UILabel alloc] init];
        replyLabel.font = [UIFont systemFontOfSize:14];
        replyLabel.textColor = [UIColor darkGrayColor];
        replyLabel.numberOfLines = 0;
        replyLabel.text = [NSString stringWithFormat:@"%@：%@", reply.displayName, reply.text];
        
        [self.replyContainerView addSubview:replyLabel];
        [replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.replyContainerView).insets(UIEdgeInsetsMake(0, 8, 0, 8));
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(6);
            } else {
                make.top.equalTo(self.replyContainerView).offset(8);
            }
        }];
        lastView = replyLabel;
    }

    if (lastView) {
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.replyContainerView).offset(-8);
        }];
    }
}

#pragma mark - 回复按钮
- (void)replyBtnClicked {
    if (self.replyAction) {
        self.replyAction(self.commentModel);
    }
}
#pragma mark - 懒加载
//- (UIImageView *)avatarImageView {
//    if (!_avatarImageView) {
//        _avatarImageView = [[UIImageView alloc] init];
//        _avatarImageView.layer.cornerRadius = 20;
//        _avatarImageView.clipsToBounds = YES;
//    }
//    return _avatarImageView;
//}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _nameLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor grayColor];
    }
    return _timeLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (UIButton *)replyButton {
    if (!_replyButton) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
        _replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_replyButton addTarget:self action:@selector(replyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyButton;
}
//- (UIButton *)likeButton {
//    if (!_likeButton) {
//        _likeButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        [_likeButton setImage:[UIImage imageNamed:@"like_icon"] forState:UIControlStateNormal];
//        _likeButton.tintColor = [UIColor grayColor];
//    }
//    return _likeButton;
//}
//- (UILabel *)likeCountLabel {
//    if (!_likeCountLabel) {
//        _likeCountLabel = [[UILabel alloc] init];
//        _likeCountLabel.font = [UIFont systemFontOfSize:14];
//        _likeCountLabel.textColor = [UIColor grayColor];
//    }
//    return _likeCountLabel;
//}
- (UIView *)replyContainerView {
    if (!_replyContainerView) {
        _replyContainerView = [[UIView alloc] init];
        _replyContainerView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
        _replyContainerView.layer.cornerRadius = 6;
    }
    return _replyContainerView;
}



@end
