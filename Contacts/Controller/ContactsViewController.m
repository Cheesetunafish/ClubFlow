//
//  ContactsViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/21.
//

#import "ContactsViewController.h"
#import "ContactsView.h"
#import "Masonry.h"
@import FirebaseAuth;

@interface ContactsViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UILabel *contactLable;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加按钮
    [self.view addSubview:self.addButton];
    // 搜索栏
    [self.view addSubview:self.searchBar];
    // 标题
    [self.view addSubview:self.contactLable];
    
    // 表格视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    // 使用Masonry设置约束
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

- (void)addFriendButtonTapped {
    // 获取当前用户
    FIRUser *currentUser = [FIRAuth auth].currentUser;
    if (!currentUser) {
        [self showAlertWithTitle:@"提示" message:@"请先登录"];
        return;
    }
    
    // 创建邀请链接
    NSString *inviteLink = [NSString stringWithFormat:@"myapp://invite?inviter=%@", currentUser.uid];
    NSURL *url = [NSURL URLWithString:inviteLink];
    
    // 显示分享选项
    [self showShareOptionsWithURL:url];
}

- (void)showShareOptionsWithURL:(NSURL *)url {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"邀请好友"
                                                                 message:@"邀请链接已复制到剪贴板，您可以选择分享方式"
                                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"复制链接"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = url.absoluteString;
        [self showAlertWithTitle:@"提示" message:@"链接已复制到剪贴板"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"分享"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * _Nonnull action) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                            style:UIAlertActionStyleCancel
                                          handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
