//
//  OptionCell.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/23.
//

#import "OptionCell.h"

@implementation OptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)configureWithTitle:(NSString *)title icon:(NSString *)iconName {
    self.textLabel.text = title;
    self.imageView.image = [UIImage imageNamed:iconName] ?: [UIImage imageNamed:@"default_icon"]; // 占位图
}

@end
