//
//  EditViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/21.
//

#import "EditViewController.h"
#import "EditView.h"
@interface EditViewController ()
/// editView
@property (nonatomic, strong) EditView *editView;
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.editView];
}

- (EditView *)editView {
    if (!_editView) {
        _editView = [[EditView alloc] init];
    }
    return _editView;
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
