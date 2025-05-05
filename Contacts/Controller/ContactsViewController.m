//
//  ContactsViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/21.
//

#import "ContactsViewController.h"
#import "FriendPageViewController.h"
#import "ContactsView.h"
#import "Masonry.h"
#import "UserModel.h"
#import "Macros.h"
@import FirebaseAuth;
@import FirebaseDatabase;

@interface ContactsViewController ()<UITableViewDelegate, UITableViewDataSource>
/// 搜索栏
@property (nonatomic, strong) UISearchBar *searchBar;
/// 表格视图
@property (nonatomic, strong) UITableView *tableView;
/// 添加按钮
@property (nonatomic, strong) UIButton *addButton;
/// 标题
@property (nonatomic, strong) UILabel *contactLable;
/// usermodel
@property (nonatomic, strong) UserModel *user;

@property (nonatomic, strong) NSMutableArray *friendsArray;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.user = [[UserModel alloc] initWithFirebaseUser:[FIRAuth auth].currentUser];
    [self getFirendsUID];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.contactLable];
    [self.view addSubview:self.tableView];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        make.right.equalTo(self.view).offset(-20);
        make.width.height.mas_equalTo(30);
    }];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addButton.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    [self.contactLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addButton);
        make.left.equalTo(self.view).offset(20);
        make.height.mas_equalTo(30);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identify" forIndexPath:indexPath];
    UserModel *user = self.friendsArray[indexPath.row];
    cell.textLabel.text = user.displayName.length > 0 ? user.displayName : user.uid;
    cell.detailTextLabel.text = user.email;
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UserModel *friend = self.friendsArray[indexPath.row];
//    FriendPageViewController *vc = [[FriendPageViewController alloc] init];
//    vc.modalPresentationStyle = UIModalPresentationPageSheet;
//    vc.displayName = friend.displayName;
//    vc.email = friend.email;
//    vc.avatarUrl = friend.photoUrl;    // 头像
//    [self presentViewController:vc animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 访问好友UID
- (void)getFirendsUID {
    self.friendsArray = [NSMutableArray array];
    NSString *uid = self.user.uid;
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    [[ref child:[NSString stringWithFormat:@"users/%@/friends", uid]]
     observeSingleEventOfType:FIRDataEventTypeValue
     withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            NSDictionary *friendsDict = snapshot.value;
            NSArray *friendUIDs = friendsDict.allKeys;
            NSLog(@"好友 UID 列表: %@", friendUIDs);
            // 继续加载每个好友的详细信息
            [self fetchFriendDetailsFromUIDs:friendUIDs];
        } else {
            NSLog(@"该用户没有好友");
        }
    }];
}

#pragma mark - 访问好友资料
- (void)fetchFriendDetailsFromUIDs:(NSArray<NSString *> *)friendUIDs {
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    [self.friendsArray removeAllObjects]; // 清空旧数据
    dispatch_group_t group = dispatch_group_create(); // 并发处理多个好友请求
    for (NSString *fid in friendUIDs) {
        dispatch_group_enter(group);
        [[[ref child:@"users"] child:fid] observeSingleEventOfType:FIRDataEventTypeValue
                                                         withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if (snapshot.exists) {
                NSLog(@"snapshot.value:%@", snapshot.value);
                NSDictionary *userDict = snapshot.value;
                UserModel *friend = [[UserModel alloc] initWithDictionary:userDict];
                [self.friendsArray addObject:friend];
                NSLog(@"好友：%@ (%@), arrray:(%@)", friend.displayName, friend.email, self.friendsArray);
            }
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [self.tableView reloadData]; // 数据加载完成，刷新表格
        });
}


#pragma mark - 点击按钮逻辑
- (void)addFriendButtonTapped {
    // 获取当前用户
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    if (!currentUser) {
        [self showAlertWithTitle:@"提示" message:@"请先登录"];
        return;
    }
    
    // 创建邀请链接
    NSString *inviteLink = [NSString stringWithFormat:@"https://clubflow.com/invite?uid=%@", currentUser.uid];
    NSURL *url = [NSURL URLWithString:inviteLink];
    
    // 显示分享选项
    [self showShareOptionsWithURL:url];
}
#pragma mark - 提示框功能
- (void)showShareOptionsWithURL:(NSURL *)url {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"邀请好友"
                                                                 message:@"邀请链接已复制到剪贴板，您可以选择分享方式"
                                                          preferredStyle:UIAlertControllerStyleActionSheet];
    // 复制到剪贴板
    [alert addAction:[UIAlertAction actionWithTitle:@"复制链接"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = url.absoluteString;
        [self showAlertWithTitle:@"提示" message:@"链接已复制到剪贴板"];
    }]];
    // 分享链接
    [alert addAction:[UIAlertAction actionWithTitle:@"分享"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * _Nonnull action) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }]];
    // 搜索uid
        [alert addAction:[UIAlertAction actionWithTitle:@"通过 UID 添加好友"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
            [self promptForFriendUID];
        }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                            style:UIAlertActionStyleCancel
                                          handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 添加框
- (void)promptForFriendUID {
    UIAlertController *uidAlert = [UIAlertController alertControllerWithTitle:@"添加好友"
                                                                      message:@"请输入好友的 UID"
                                                               preferredStyle:UIAlertControllerStyleAlert];
    
    [uidAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"好友 UID";
    }];
    
    [uidAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [uidAlert addAction:[UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *friendUID = uidAlert.textFields.firstObject.text;
        if (friendUID.length > 0) {
            [self addFriendWithUID:friendUID];
        }
    }]];
    
    [self presentViewController:uidAlert animated:YES completion:nil];
}
#pragma mark - 添加好友逻辑
- (void)addFriendWithUID:(NSString *)friendUID {
    NSString *myUID = [FIRAuth auth].currentUser.uid;
    if (!myUID || [friendUID isEqualToString:myUID]) {
        [self showAlertWithTitle:@"错误" message:@"不能添加自己为好友"];
        return;
    }

    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    NSDictionary *updates = @{
        [NSString stringWithFormat:@"users/%@/friends/%@", myUID, friendUID]: @YES,
        [NSString stringWithFormat:@"users/%@/friends/%@", friendUID, myUID]: @YES
    };

    [ref updateChildValues:updates withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            [self showAlertWithTitle:@"错误" message:@"添加好友失败"];
        } else {
            [self showAlertWithTitle:@"成功" message:@"好友添加成功"];
            [self.tableView reloadData];
        }
    }];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Lazy load
- (UIButton *)addButton {
    if (!_addButton) {
        // 添加按钮
        _addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_addButton setImage:[UIImage systemImageNamed:@"plus"] forState:UIControlStateNormal];
        _addButton.tintColor = [UIColor systemBlueColor];
        [_addButton addTarget:self action:@selector(addFriendButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜索";
        _searchBar.backgroundColor = [UIColor clearColor];
    }
    return _searchBar;
}

- (UILabel *)contactLable {
    if (!_contactLable) {
        _contactLable = [[UILabel alloc] init];
        _contactLable.text = @"联系人";
        _contactLable.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
        _contactLable.textColor = [UIColor blackColor];
    }
    return _contactLable;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identify"];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
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
