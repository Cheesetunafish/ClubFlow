//
//  CommentViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/19.
//

#import "CommentViewController.h"
#import "CommentModel.h"
#import "CommentCell.h"

@interface CommentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CommentModel *> *comments;


@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"留言板";
    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"CommentCell"];
    [self.view addSubview:self.tableView];

    [self loadComments];
}

- (void)loadComments {
    CommentModel *comment1 = [[CommentModel alloc] initWithAuthor:@"陈美玲" content:@"今天的阳光真好，希望大家有美好的一天！" time:@"10分钟前" likes:23 replies:@[]];
    
    CommentModel *reply = [[CommentModel alloc] initWithAuthor:@"王小明" content:@"恭喜完成项目！期待下次合作。" time:@"20分钟前" likes:0 replies:@[]];

    CommentModel *comment2 = [[CommentModel alloc] initWithAuthor:@"张志远" content:@"刚刚完成了一个重要项目，团队合作真的很愉快。" time:@"30分钟前" likes:45 replies:@[reply]];

    self.comments = [NSMutableArray arrayWithArray:@[comment1, comment2]];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    [cell configureWithComment:self.comments[indexPath.row]];
    return cell;
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
