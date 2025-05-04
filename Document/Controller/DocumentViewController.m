//
//  DocumentViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2024/3/23.
//

#import "DocumentViewController.h"
#import "DocumentCell.h"
#import "DocumentModel.h"
#import "EditViewController.h"
#import "Masonry.h"
@import FirebaseDatabase;
@import FirebaseAuth;

@interface DocumentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<DocumentModel *> *documents;
@property (nonatomic, strong) FIRDatabaseReference *databaseRef;
@property (nonatomic, strong) NSMutableArray<DocumentModel *> *pinnedDocuments;
@property (nonatomic, strong) NSMutableArray<DocumentModel *> *recentDocuments;
@property (nonatomic, strong) UIButton *addDocButton;

@end

@implementation DocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupDatabase];
    [self registerNotifications];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    // 设置导航栏标题
    self.navigationItem.title = @"我的文档";
    
    // 设置tableView
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addDocButton];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.addDocButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.right.equalTo(self.view).offset(-24);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-24);
    }];
}


- (void)setupDatabase {
    self.databaseRef = [[FIRDatabase database] reference];
    self.pinnedDocuments = [NSMutableArray array];
    self.recentDocuments = [NSMutableArray array];
    self.documents = [NSMutableArray array];
    [self loadDocuments];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleDocumentUpdate:)
                                               name:@"DocumentDidUpdateNotification"
                                             object:nil];
}

- (void)loadDocuments {
    NSString *userId = [FIRAuth auth].currentUser.uid;
    if (!userId) return;
    FIRDatabaseQuery *query = [[self.databaseRef child:@"documents"] queryOrderedByChild:@"userId"];
    [query queryEqualToValue:userId];
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [self.pinnedDocuments removeAllObjects];
        [self.recentDocuments removeAllObjects];
        for (FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *dict = child.value;
            if ([dict isKindOfClass:[NSDictionary class]]) {
                DocumentModel *document = [[DocumentModel alloc] initWithDictionary:dict];
                document.documentId = child.key;
                if (document.isPinned) {
                    [self.pinnedDocuments addObject:document];
                } else {
                    [self.recentDocuments addObject:document];
                }
            }
        }
        // 可选：置顶和非置顶都按时间排序
        [self.pinnedDocuments sortUsingComparator:^NSComparisonResult(DocumentModel *doc1, DocumentModel *doc2) {
            return [@(doc2.createTime) compare:@(doc1.createTime)];
        }];
        [self.recentDocuments sortUsingComparator:^NSComparisonResult(DocumentModel *doc1, DocumentModel *doc2) {
            return [@(doc2.createTime) compare:@(doc1.createTime)];
        }];
        [self.tableView reloadData];
    }];
}

- (UIButton *)addDocButton {
    if (!_addDocButton) {
        _addDocButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addDocButton setImage:[UIImage systemImageNamed:@"plus.circle.fill"] forState:UIControlStateNormal];
        _addDocButton.tintColor = [UIColor systemBlueColor];
        _addDocButton.backgroundColor = [UIColor whiteColor];
        _addDocButton.layer.cornerRadius = 30;
        _addDocButton.layer.shadowColor = [UIColor blackColor].CGColor;
        _addDocButton.layer.shadowOpacity = 0.2;
        _addDocButton.layer.shadowOffset = CGSizeMake(0, 2);
        _addDocButton.layer.shadowRadius = 4;
        [_addDocButton addTarget:self action:@selector(addButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addDocButton;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - Actions

- (void)addButtonTapped {
    EditViewController *editVC = [[EditViewController alloc] initWithTitle:nil content:nil documentId:nil];
    [editVC setNewDocumentMode];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)handleDocumentUpdate:(NSNotification *)notification {
    [self loadDocuments];
}

#pragma mark - UITableViewDataSource
// pinned and nonpinned are two seperate sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.pinnedDocuments.count > 0 ? 2 : 1;
}
// show pinned title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.pinnedDocuments.count > 0) {
        return section == 0 ? @"置顶文档" : @"最近文档";
    }
    return @"";
}
// section number
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.pinnedDocuments.count > 0) {
        return section == 0 ? self.pinnedDocuments.count : self.recentDocuments.count;
    } else {
        return self.recentDocuments.count;
    }
}

// tableviewcell is pinned or not
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:[DocumentCell identifier]];
    if (!cell) {
        cell = [[DocumentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[DocumentCell identifier]];
    }
    DocumentModel *document;
    if (self.pinnedDocuments.count > 0) {
        document = indexPath.section == 0 ? self.pinnedDocuments[indexPath.row] : self.recentDocuments[indexPath.row];
    } else {
        document = self.recentDocuments[indexPath.row];
    }
    cell.textLabel.text = document.title;
    cell.detailTextLabel.text = document.content;
    return cell;
}

// left swipe
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    DocumentModel *document;
    if (self.pinnedDocuments.count > 0) {
        document = indexPath.section == 0 ? self.pinnedDocuments[indexPath.row] : self.recentDocuments[indexPath.row];
    } else {
        document = self.recentDocuments[indexPath.row];
    }
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                               title:@"删除"
                                                                             handler:^(UIContextualAction * _Nonnull action, UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self deleteDocument:document];
        completionHandler(YES);
    }];
    NSString *pinTitle = document.isPinned ? @"取消置顶" : @"置顶";
    UIContextualAction *pinAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
                                                                            title:pinTitle
                                                                          handler:^(UIContextualAction * _Nonnull action, UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self togglePinDocument:document];
        completionHandler(YES);
    }];
    pinAction.backgroundColor = [UIColor systemOrangeColor];
    return [UISwipeActionsConfiguration configurationWithActions:@[deleteAction, pinAction]];
}
// select cell do action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DocumentModel *document;
    if (self.pinnedDocuments.count > 0) {
        document = indexPath.section == 0 ? self.pinnedDocuments[indexPath.row] : self.recentDocuments[indexPath.row];
    } else {
        document = self.recentDocuments[indexPath.row];
    }
    EditViewController *editVC = [[EditViewController alloc] initWithTitle:document.title
                                                                   content:document.content
                                                                documentId:document.documentId];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.databaseRef removeAllObservers];
}

// deleteDocument
- (void)deleteDocument:(DocumentModel *)document {
    if (!document.documentId) return;
    
    [[self.databaseRef child:[NSString stringWithFormat:@"documents/%@", document.documentId]]
     removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"删除失败：%@", error.localizedDescription);
        } else {
            NSLog(@"文档已删除");
            [self loadDocuments]; // 刷新列表
        }
    }];
}

// pinned document
- (void)togglePinDocument:(DocumentModel *)document {
    if (!document.documentId) return;
    
    BOOL newPinStatus = !document.isPinned;
    NSDictionary *update = @{@"isPinned": @(newPinStatus)};
    
    [[self.databaseRef child:[NSString stringWithFormat:@"documents/%@", document.documentId]]
     updateChildValues:update withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"置顶状态更新失败：%@", error.localizedDescription);
        } else {
            NSLog(@"置顶状态已更新");
            [self loadDocuments]; // 刷新列表
        }
    }];
}



@end
