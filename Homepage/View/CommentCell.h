//
//  CommentCell.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/19.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentCell : UITableViewCell
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *likeButton;

- (void)configureWithComment:(CommentModel *)comment;
@end

NS_ASSUME_NONNULL_END
