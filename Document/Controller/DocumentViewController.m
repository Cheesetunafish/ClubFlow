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

@interface DocumentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FIRDatabaseReference *databaseRef;
@property (nonatomic, strong) NSMutableArray<DocumentModel *> *pinnedDocuments;
@property (nonatomic, strong) NSMutableArray<DocumentModel *> *recentDocuments;

@end

@implementation DocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的文档";
    [self setupViews];
    [self setupFirebase];
    [self loadDocuments];
}

#pragma mark - Setup Methods

- (void)setupViews {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupFirebase {
    self.databaseRef = [[FIRDatabase database] reference];
    self.pinnedDocuments = [NSMutableArray array];
    self.recentDocuments = [NSMutableArray array];
}

#pragma mark - Data Loading

- (void)loadDocuments {
    // 监听文档变化
    [[self.databaseRef child:@"documents"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [self.pinnedDocuments removeAllObjects];
        [self.recentDocuments removeAllObjects];
        
        for (FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *dict = child.value;
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *documentDict = [dict mutableCopy];
                documentDict[@"documentId"] = child.key;
                
                DocumentModel *document = [DocumentModel documentWithDictionary:documentDict];
                if (document.isPinned) {
                    [self.pinnedDocuments addObject:document];
                } else {
                    [self.recentDocuments addObject:document];
                }
            }
        }
        // 按时间排序
        [self sortDocuments];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)sortDocuments {
    // 置顶文档按时间降序排序
    [self.pinnedDocuments sortUsingComparator:^NSComparisonResult(DocumentModel *obj1, DocumentModel *obj2) {
        return obj1.createTime < obj2.createTime;
    }];
    
    // 最近文档按时间降序排序
    [self.recentDocuments sortUsingComparator:^NSComparisonResult(DocumentModel *obj1, DocumentModel *obj2) {
        return obj1.createTime < obj2.createTime;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 0;
    if (self.pinnedDocuments.count > 0) sections++;
    if (self.recentDocuments.count > 0) sections++;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.pinnedDocuments.count > 0) {
        if (section == 0) return self.pinnedDocuments.count;
        return self.recentDocuments.count;
    } else {
        return self.recentDocuments.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DocumentCell *cell = [tableView dequeueReusableCellWithIdentifier:[DocumentCell identifier]];
    
    DocumentModel *document;
    if (self.pinnedDocuments.count > 0) {
        document = indexPath.section == 0 ? self.pinnedDocuments[indexPath.row] : self.recentDocuments[indexPath.row];
    } else {
        document = self.recentDocuments[indexPath.row];
    }
    
    [cell configureWithDocument:document];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.pinnedDocuments.count > 0) {
        return section == 0 ? @"置顶" : @"昨天";
    } else {
        return @"昨天";
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DocumentModel *document;
    if (self.pinnedDocuments.count > 0) {
        document = indexPath.section == 0 ? self.pinnedDocuments[indexPath.row] : self.recentDocuments[indexPath.row];
    } else {
        document = self.recentDocuments[indexPath.row];
    }
    
    [self editDocument:document];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    DocumentModel *document;
    if (self.pinnedDocuments.count > 0) {
        document = indexPath.section == 0 ? self.pinnedDocuments[indexPath.row] : self.recentDocuments[indexPath.row];
    } else {
        document = self.recentDocuments[indexPath.row];
    }
    
    // 删除操作
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                            title:@"删除"
                                                                          handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self deleteDocument:document];
        completionHandler(YES);
    }];
    
    // 置顶/取消置顶操作
    NSString *pinTitle = document.isPinned ? @"取消置顶" : @"置顶";
    UIContextualAction *pinAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
                                                                         title:pinTitle
                                                                       handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self togglePinDocument:document];
        completionHandler(YES);
    }];
    pinAction.backgroundColor = [UIColor systemOrangeColor];
    
    return [UISwipeActionsConfiguration configurationWithActions:@[deleteAction, pinAction]];
}

#pragma mark - LazyLoad

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DocumentCell class] forCellReuseIdentifier:[DocumentCell identifier]];
    }
    return _tableView;
}

#pragma mark - Document Actions

- (void)editDocument:(DocumentModel *)document {
    EditViewController *editVC = [[EditViewController alloc] initWithTitle:document.title 
                                                                content:document.content 
                                                            documentId:document.documentId];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)deleteDocument:(DocumentModel *)document {
    [[self.databaseRef child:[NSString stringWithFormat:@"documents/%@", document.documentId]] removeValue];
}

- (void)togglePinDocument:(DocumentModel *)document {
    document.isPinned = !document.isPinned;
    [[self.databaseRef child:[NSString stringWithFormat:@"documents/%@", document.documentId]] updateChildValues:@{@"isPinned": @(document.isPinned)}];
}

@end
