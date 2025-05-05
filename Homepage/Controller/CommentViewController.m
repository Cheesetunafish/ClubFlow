//
//  CommentViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/19.
//

#import "CommentViewController.h"
#import "SettingViewController.h"
#import "CommentModel.h"
#import "CommentCell.h"
#import "TopView.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "Macros.h"
@import FirebaseAuth;
@import Firebase;

@interface CommentViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray<CommentModel *> *comments;
/// topview
@property (nonatomic, strong) TopView *topView;
/// user
@property (nonatomic, strong) UserModel *user;


@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [[UserModel alloc] initWithFirebaseUser:[FIRAuth auth].currentUser];
    [self setupUI];
}

-(void) setupUI {
    self.title = @"留言板";
    self.view.backgroundColor = [UIColor whiteColor];
    self.comments = [NSMutableArray array];
    // 顶部栏
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputBar];
    [self.inputBar addSubview:self.inputField];
    [self.inputBar addSubview:self.sendButton];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(STATUSBAR_HEIGHT + 15);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(73);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom).mas_offset(20);
        make.bottom.equalTo(self.inputBar.mas_top);
    }];
    [self.inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-TABBAR_HEIGHT);
        make.height.mas_equalTo(50);
    }];
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputBar).offset(16);
        make.centerY.equalTo(self.inputBar);
        make.height.mas_equalTo(36);
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputField.mas_right).offset(10);
        make.right.equalTo(self.inputBar).offset(-16);
        make.centerY.equalTo(self.inputBar);
        make.width.mas_equalTo(50);
    }];
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sendButton.mas_left).offset(-10);
    }];
    
    
    [self loadData];
}

#pragma mark - 数据加载与刷新
//- (void)setupRefresh {
//    __weak typeof(self) weakSelf = self;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf loadData];
//    }];
//}
#pragma mark - 拉取数据
- (void)loadData {
    // TODO: 从 Firebase 拉取数据，分页可选
     [self.comments removeAllObjects];
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
        [[ref child:@"comments"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSLog(@"load快照:%@", snapshot);
            [self.comments removeAllObjects];
            for (FIRDataSnapshot *child in snapshot.children) {
                NSDictionary *dict = child.value;
                CommentModel *model = [[CommentModel alloc] initWithDictionary:dict];
                model.commentID = child.key;
                NSMutableArray *replies = [NSMutableArray array];
                NSDictionary *replyDict = dict[@"replies"];
                for (NSString *replyKey in replyDict) {
                    NSDictionary *replyData = replyDict[replyKey];
                    CommentModel *replyModel = [[CommentModel alloc] initWithDictionary:replyData];
                    [replies addObject:replyModel];
                }
                model.replyArray = replies;
                [self.comments addObject:model];
            }
            // ... 拉取后
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }];
}



#pragma mark - 发送留言/回复
- (void)sendBtnClicked {
    NSString *text = self.inputField.text;
    if (text.length == 0) return;
    if (self.replyToComment) {
        // 回复
        // TODO: 写入 Firebase，更新 self.replyToComment.replyArray
        [self sendReplyToComment:text];
        self.replyToComment = nil;
    } else {
        // 新留言
        // TODO: 写入 Firebase，刷新数据
        [self sendNewCommentToFirebase:text];
    }
    self.inputField.text = @"";
    self.inputField.placeholder = @"写下你的留言...";
    [self.inputField resignFirstResponder];
}
/// 写入新留言
- (void)sendNewCommentToFirebase:(NSString *)text {
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    NSString *commentID = [[ref child:@"comments"] childByAutoId].key;
    NSDictionary *commentData = @{
        @"text": text,
        @"displayName": self.user.displayName,
        @"timestamp": @([[NSDate date] timeIntervalSince1970])
    };
    
    [[[ref child:@"comments"] child:commentID] setValue:commentData withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if (!error) {
                NSLog(@"留言发送成功!");
                [self loadData];
            } else {
                NSLog(@"留言失败：%@", error.localizedDescription);
            }
    }];
}
/// 回复
- (void)sendReplyToComment:(NSString *)text {
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
//    NSString *replyName = [[ref child:@"comments"] child:self.replyToComment.displayName].key;
    NSDictionary *replyData = @{
           @"text": text,
           @"displayName": [FIRAuth auth].currentUser.displayName ?: @"anonymous",
           @"timestamp": @([[NSDate date] timeIntervalSince1970])
       };
    [[[[ref child:@"comments"]
            child:self.replyToComment.commentID]
            child:@"replies"]
            updateChildValues:@{[[ref childByAutoId] key]: replyData}
            withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if (!error) {
                NSLog(@"回复成功！");
                [self loadData];
            } else {
                NSLog(@"回复失败：%@", error.localizedDescription);
            }
        }];
}

#pragma mark - 点击头像，进入设置页
- (void)tappedProfile {
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    settingVC.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:settingVC animated:YES completion:nil];
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"uitable数据:%@", self.comments);
    return self.comments.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    CommentModel *model = self.comments[indexPath.row];
    cell.commentModel = model;
    [cell setCommentModel:model];
    __weak typeof(self) weakSelf = self;
    cell.replyAction = ^(CommentModel *comment) {
        weakSelf.replyToComment = comment;
        [weakSelf.inputField becomeFirstResponder];
        weakSelf.inputField.placeholder = [NSString stringWithFormat:@"回复 %@", comment.displayName];
    };
    
    return cell;
}

#pragma mark - Lazy Load
- (TopView *)topView {
    if (!_topView) {
        _topView = [[TopView alloc] initWithUser:self.user];
        _topView.profileImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapProfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedProfile)];
        [_topView.profileImage addGestureRecognizer:tapProfile];
        NSLog(@"😍self.user:%@", [self.user toDictionary]);
    }
    return _topView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"CommentCell"];
        _tableView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    }
    return _tableView;
}
- (UIView *)inputBar {
    if (!_inputBar) {
        _inputBar = [[UIView alloc] init];
        _inputBar.backgroundColor = [UIColor whiteColor];
        _inputBar.layer.cornerRadius = 20;
        _inputBar.layer.masksToBounds = YES;
    }
    return _inputBar;
}
- (UITextField *)inputField {
    if (!_inputField) {
        _inputField = [[UITextField alloc] init];
        _inputField.placeholder = @"写下你的留言...";
        _inputField.font = [UIFont systemFontOfSize:15];
        _inputField.delegate = self;
    }
    return _inputField;
}
- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_sendButton addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
