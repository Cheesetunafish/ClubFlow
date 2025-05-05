//
//  SelfpageViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/5/4.
//

#import "SelfpageViewController.h"
#import "Masonry.h"
#import <SDWebImage/SDWebImage.h>
#import <AFNetworking/AFNetworking.h>
#import "UserModel.h"
#import "CurrentUserManager.h"
#import "Macros.h"
@import FirebaseDatabase;
@import FirebaseAuth;
@import FirebaseStorage;

@interface SelfpageViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
/// profile picture
@property (nonatomic, strong) UIImageView *avatarImageView;
/// change btn
@property (nonatomic, strong) UILabel *changeAvatarLabel;
/// tableview
@property (nonatomic, strong) UITableView *tableView;
/// username
@property (nonatomic, copy) NSString *username;
/// email
@property (nonatomic, copy) NSString *email;
/// profile url
@property (nonatomic, copy) NSString *avatarURL;
/// userModel
@property (nonatomic, strong) UserModel *user;
@end

@implementation SelfpageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
//    [self fetchUserInfo];
    self.user = [[UserModel alloc] initWithFirebaseUser:[FIRAuth auth].currentUser];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    self.title = @"个人资料";
    
    [self.view addSubview:self.avatarImageView];
    [self.view addSubview:self.changeAvatarLabel];
    [self.view addSubview:self.tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAvatar)];
    [self.avatarImageView addGestureRecognizer:tap];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(30);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(90);
    }];
    [self.changeAvatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(8);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.changeAvatarLabel.mas_bottom);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.height.mas_equalTo(195);
    }];
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"InfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }

    // 默认状态
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.textColor = [UIColor blackColor];  // 恢复颜色防止复用问题

    if (indexPath.row == 0) {
        cell.textLabel.text = @"用户名";
        cell.detailTextLabel.text = self.user.displayName ?: @"";
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"邮箱";
        cell.detailTextLabel.text = self.user.email ?: @"";
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"UID";
        cell.detailTextLabel.text = self.user.uid ?: @"";
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    return cell;

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self showEditUsernameAlert];
    } else if (indexPath.row == 2) {
        [self pasteUID:self.user.uid];
    }
}

#pragma mark - 复制UID到剪贴板
- (void)pasteUID:(NSString *)uid {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = uid;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已复制"
                                                                 message:nil
                                                          preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 更换头像
- (void)changeAvatar {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];
    if (image) {
        self.avatarImageView.image = image;
        [self uploadAvatar:image];
        // TODO: 更新头像
//        [[CurrentUserManager sharedManager] updateWithDisplayName:nil photoURL:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// TODO: 修改上传代码
- (void)uploadAvatar:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    if (!imageData) return;
    NSString *uid = self.user.uid;
    NSString *fileName = [NSString stringWithFormat:@"avatar_%@.jpg", uid];
//    NSString *uploadURL = [NSString stringWithFormat:@"YOUR_FIREBASE_STORAGE_UPLOAD_URL/%@", fileName];
    // 1. 获取 Storage 引用
        FIRStorageReference *storageRef = [[FIRStorage storage] reference];
        FIRStorageReference *avatarRef = [[storageRef child:@"avatars"] child:fileName];

        // 2. 上传图片
        [avatarRef putData:imageData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
            if (error) {
                NSLog(@"头像上传失败: %@", error.localizedDescription);
                return;
            }
            // 3. 获取下载URL
            [avatarRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"获取头像URL失败: %@", error.localizedDescription);
                    return;
                }
                NSString *avatarURL = URL.absoluteString;
                [self updateUserInfo:@{@"avatarURL": avatarURL}];
                [self.avatarImageView sd_setImageWithURL:URL];
            }];
        }];
}

#pragma mark - 修改用户名
- (void)showEditUsernameAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改用户名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.username;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *newName = alert.textFields.firstObject.text;
        // 表单验证。防止重复提交
        if (newName.length == 0 || [newName isEqualToString:self.username]) {
            return;
        }
        if (newName.length > 0) {
            [self updateUserInfo:@{@"displayName": newName}];
            // 本地模型
            self.username = newName;
            self.user.displayName = newName;
            [[CurrentUserManager sharedManager] updateWithDisplayName:newName photoURL:nil];
            [self.tableView reloadData];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 更新用户信息到Firebase
- (void)updateUserInfo:(NSDictionary *)dict {
    NSString *uid = [FIRAuth auth].currentUser.uid;
    if (!uid) return;
    
    FIRDatabaseReference *userRef = [[[FIRDatabase database] reference] child:@"users"];
    [[userRef child:uid] updateChildValues:dict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"用户信息更新失败: %@", error.localizedDescription);
        }else {
            NSLog(@"✅ 用户信息已保存到数据库");
        }
    }];
    // 如果 dict 中包含 displayName，就更新 Firebase Auth 的 displayName
    NSString *newDisplayName = dict[@"displayName"];
    if (newDisplayName.length > 0) {
        FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
        changeRequest.displayName = newDisplayName;
        [changeRequest commitChangesWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"❌ 显示名更新失败: %@", error.localizedDescription);
            } else {
                NSLog(@"✅ 显示名更新成功");
            }
        }];
    }
}

#pragma mark - LazyLoad
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_avatar"]];
        self.avatarImageView.layer.cornerRadius = 45;
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.userInteractionEnabled = YES;
        self.avatarImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _avatarImageView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.layer.cornerRadius = 12;
        _tableView.clipsToBounds = YES;
    }
    return _tableView;
}
- (UILabel *)changeAvatarLabel {
    if (!_changeAvatarLabel) {
        _changeAvatarLabel = [[UILabel alloc] init];
        _changeAvatarLabel.text = @"更换头像";
        _changeAvatarLabel.textAlignment = NSTextAlignmentCenter;
        _changeAvatarLabel.font = [UIFont systemFontOfSize:15];
        _changeAvatarLabel.textColor = [UIColor darkGrayColor];
    }
    return _changeAvatarLabel;
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
