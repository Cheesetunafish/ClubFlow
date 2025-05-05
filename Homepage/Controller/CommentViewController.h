//
//  CommentViewController.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/19.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentViewController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CommentModel *> *dataArray;
@property (nonatomic, strong) UIView *inputBar;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) CommentModel *replyToComment;
@end

NS_ASSUME_NONNULL_END
