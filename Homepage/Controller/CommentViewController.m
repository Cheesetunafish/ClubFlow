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
#import "Masonry.h"
#import "Macros.h"
@import FirebaseAuth;

@interface CommentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];// 顶部栏
    [self masMakePosition];

}

- (void)masMakePosition {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(STATUSBAR_HEIGHT + 15);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(73);
    }];
}


#pragma mark - UITableViewDataSource



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


#pragma mark - Action
// 点击头像，进入设置页
- (void)tappedProfile {
    NSLog(@"😄按下头像");
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    settingVC.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:settingVC animated:YES completion:nil];
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
