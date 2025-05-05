//
//  CommentCell.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/19.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@class CommentModel;

@interface CommentCell : UITableViewCell

@property (nonatomic, strong) CommentModel *commentModel;
@property (nonatomic, copy) void(^replyAction)(CommentModel *comment);

- (void)setCommentModel:(CommentModel *)commentModel;

@end
NS_ASSUME_NONNULL_END
