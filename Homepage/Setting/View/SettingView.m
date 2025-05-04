//
//  SettingView.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/23.
//
#import "Macros.h"
#import "SettingView.h"

@implementation SettingView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.tableview];
    }
    return self;
}



#pragma mark - LazyLoad
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _tableview;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
