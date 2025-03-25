//
//  DocumentCell.m
//  ClubFlow
//
//  Created by Shea Cheese on 2024/3/23.
//

#import "DocumentCell.h"
#import "Masonry.h"

@interface DocumentCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *pinnedImageView;

@end

@implementation DocumentCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    // 标题标签
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    
    // 时间标签
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.timeLabel];
    
    // 置顶图标
    self.pinnedImageView = [[UIImageView alloc] init];
    self.pinnedImageView.image = [UIImage systemImageNamed:@"pin.fill"];
    self.pinnedImageView.tintColor = [UIColor systemRedColor];
    self.pinnedImageView.hidden = YES;
    [self.contentView addSubview:self.pinnedImageView];
    
    // 布局
    [self.pinnedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.pinnedImageView.mas_right).offset(8);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.contentView).offset(-12);
    }];
}

- (void)configureWithDocument:(DocumentModel *)document {
    self.document = document;
    
    self.titleLabel.text = document.title;
    self.timeLabel.text = [self formatDate:document.createTime];
    self.pinnedImageView.hidden = !document.isPinned;
    
    // 如果是置顶的文档，调整标题标签的位置
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pinnedImageView.mas_right).offset(document.isPinned ? 8 : 16);
    }];
}

- (NSString *)formatDate:(NSTimeInterval)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd";
    return [formatter stringFromDate:date];
}

@end 