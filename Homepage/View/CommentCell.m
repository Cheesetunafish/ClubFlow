//
//  CommentCell.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/19.
//

#import "CommentCell.h"
#import "CommentModel.h"


@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.authorLabel = [[UILabel alloc] init];
        self.contentLabel = [[UILabel alloc] init];
        self.timeLabel = [[UILabel alloc] init];
        self.likeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [self.likeButton setTitle:@"👍" forState:UIControlStateNormal];

        [self.contentView addSubview:self.authorLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.likeButton];

        // 设置布局（可用AutoLayout）
    }
    return self;
}

- (void)configureWithComment:(CommentModel *)comment {
    self.authorLabel.text = comment.author;
    self.contentLabel.text = comment.content;
    self.timeLabel.text = comment.time;
    [self.likeButton setTitle:[NSString stringWithFormat:@"👍 %ld", (long)comment.likes] forState:UIControlStateNormal];
}

@end
