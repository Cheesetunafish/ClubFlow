//
//  SettingViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/22.
//

#import "SettingViewController.h"
#import "SelfpageViewController.h"
#import "SettingView.h"
#import "USerInfoCell.h"
#import "OptionCell.h"
#import "UserModel.h"
@import FirebaseAuth;

// 定义组类型
typedef NS_ENUM(NSInteger, SectionType) {
    SectionTypeUserInfo, // 用户信息
    SectionTypeOptions,  // 选项
    SectionTypeLogout    // 退出登录
};


@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>
/// view
@property (nonatomic, strong) SettingView *settingView;
/// options
@property (nonatomic, strong) NSArray<NSDictionary *> *options;// 选项数据
/// userModel
@property (nonatomic, strong) UserModel *user;
@end

@implementation SettingViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view = self.settingView;
    self.user = [[UserModel alloc] initWithFirebaseUser:[FIRAuth auth].currentUser];
    self.options = @[
        @{@"title": @"修改密码", @"icon": @"lock_icon"},
        @{@"title": @"消息通知", @"icon": @"bell_icon"},
        @{@"title": @"隐私设置", @"icon": @"shield_icon"},
        @{@"title": @"关于我们", @"icon": @"info_icon"}
    ];
    
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SectionTypeUserInfo: return 1;
        case SectionTypeOptions: return self.options.count;
        case SectionTypeLogout: return 1;
        default:return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case SectionTypeUserInfo: {
            UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell" forIndexPath:indexPath];
            [cell configureWithName:self.user.displayName ?: @"userName" email:self.user.email avatar:self.user.photoUrl];
            return cell;
        }
        case SectionTypeOptions: {
            OptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionsCell" forIndexPath:indexPath];
            NSDictionary *option = self.options[indexPath.row];
            [cell configureWithTitle:option[@"title"] icon:option[@"icon"]];
            return cell;
        }
        case SectionTypeLogout: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogoutCell" forIndexPath:indexPath];
            cell.textLabel.text = @"退出登录";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor redColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }
        default: return nil;
    }
    
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == SectionTypeUserInfo ? 150 : 80;
}

// TODO: block处理方法。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SectionTypeUserInfo:
            [self selectUserInfo];
            NSLog(@"点击用户");
            break;
        case SectionTypeOptions:
            [self selectTypeOptions];
            NSLog(@"点击optioncell：%@", self.options[indexPath.row][@"title"]);
            break;
        case SectionTypeLogout:
            [self selectTypeLogout];
            NSLog(@"点击logout");
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10; // 组头间距
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10; // 组尾间距
}

#pragma mark - TODO: 点击Cell方法
// jump to selfie page
- (void)selectUserInfo {
    SelfpageViewController *selfpageVC = [[SelfpageViewController alloc] init];
    [self presentViewController:selfpageVC animated:YES completion:nil];
}
- (void)selectTypeOptions {
    
}
- (void)selectTypeLogout {
    
}

#pragma mark - Lazy Load
- (SettingView *)settingView {
    if (!_settingView) {
        _settingView = [[SettingView alloc] init];
        
        [_settingView.tableview registerClass:[UserInfoCell class] forCellReuseIdentifier:@"UserInfoCell"];
        [_settingView.tableview registerClass:[OptionCell class] forCellReuseIdentifier:@"OptionsCell"];
        [_settingView.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LogoutCell"];
        
        _settingView.tableview.delegate = self;
        _settingView.tableview.dataSource = self;
    }
    return _settingView;
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
