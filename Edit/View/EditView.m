//
//  EditView.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/22.
//

#import "EditView.h"
#import "Macros.h"
#import "Masonry.h"

@interface EditView () <UITextViewDelegate>
@end

@implementation EditView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor systemBackgroundColor];
        [self setUpViews];
        [self setUpConstraints];
    }
    return self;
}

- (void)setUpViews {
    [self addSubview:self.titleTextView];
    [self addSubview:self.titlePlaceholderLabel];
    [self addSubview:self.contentTextView];
    [self addSubview:self.contentPlaceholderLabel];
    
    // 设置代理
    self.titleTextView.delegate = self;
    self.contentTextView.delegate = self;
    
    // 添加文本变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(textDidChange:)
                                               name:UITextViewTextDidChangeNotification
                                             object:nil];
    
    // 设置分隔线
    UIView *separatorLine = [[UIView alloc] init];
    separatorLine.backgroundColor = [UIColor systemGrayColor];
    separatorLine.alpha = 0.3;
    [self addSubview:separatorLine];
    
    // 使用Masonry设置分隔线约束
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleTextView);
        make.right.equalTo(self.titleTextView);
        make.top.equalTo(self.titleTextView.mas_bottom);
        make.height.equalTo(@(1));
    }];
}

- (void)setUpConstraints {
    // 标题输入框约束
    [self.titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(NAVBAR_STATUSBAR_HEIGHT + 16);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.height.equalTo(@44);
    }];
    
    // 标题占位符约束
    [self.titlePlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.titleTextView);
    }];
    
    // 内容输入框约束
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleTextView.mas_bottom).offset(16);
        make.left.equalTo(self.titleTextView);
        make.right.equalTo(self.titleTextView);
        make.bottom.equalTo(self).offset(-16);
    }];
    
    // 内容占位符约束
    [self.contentPlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextView).offset(8);
        make.left.equalTo(self.contentTextView).offset(5);
        make.right.equalTo(self.contentTextView).offset(-5);
    }];
}

- (UITextView *)titleTextView {
    if (!_titleTextView) {
        _titleTextView = [[UITextView alloc] init];
        _titleTextView.editable = YES;
        _titleTextView.backgroundColor = [UIColor clearColor];
        _titleTextView.font = [UIFont boldSystemFontOfSize:24];
        _titleTextView.textAlignment = NSTextAlignmentLeft;
        _titleTextView.scrollEnabled = NO;
        _titleTextView.textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
        _titleTextView.returnKeyType = UIReturnKeyNext;
    }
    return _titleTextView;
}

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.editable = YES;
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.font = [UIFont systemFontOfSize:16];
        _contentTextView.textAlignment = NSTextAlignmentLeft;
        _contentTextView.textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
    }
    return _contentTextView;
}

- (UILabel *)titlePlaceholderLabel {
    if (!_titlePlaceholderLabel) {
        _titlePlaceholderLabel = [[UILabel alloc] init];
        _titlePlaceholderLabel.text = @"新文档";
        _titlePlaceholderLabel.font = [UIFont boldSystemFontOfSize:24];
        _titlePlaceholderLabel.textColor = [UIColor systemGrayColor];
        _titlePlaceholderLabel.hidden = NO;
    }
    return _titlePlaceholderLabel;
}

- (UILabel *)contentPlaceholderLabel {
    if (!_contentPlaceholderLabel) {
        _contentPlaceholderLabel = [[UILabel alloc] init];
        _contentPlaceholderLabel.text = @"轻点此处继续...";
        _contentPlaceholderLabel.font = [UIFont systemFontOfSize:16];
        _contentPlaceholderLabel.textColor = [UIColor systemGrayColor];
        _contentPlaceholderLabel.hidden = NO;
    }
    return _contentPlaceholderLabel;
}

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title content:(NSString *)content {
    self.titleTextView.text = title;
    self.contentTextView.text = content;
    
    self.titlePlaceholderLabel.hidden = title.length > 0;
    self.contentPlaceholderLabel.hidden = content.length > 0;
}

- (NSDictionary *)getCurrentContent {
    return @{
        @"title": self.titleTextView.text ?: @"",
        @"content": self.contentTextView.text ?: @"",
        @"timestamp": @([[NSDate date] timeIntervalSince1970])
    };
}

- (void)clearContent {
    [self setTitle:@"" content:@""];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(editViewDidBeginEditing)]) {
        [self.delegate editViewDidBeginEditing];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(editViewDidEndEditing)]) {
        [self.delegate editViewDidEndEditing];
    }
}

#pragma mark - Notifications

- (void)textDidChange:(NSNotification *)notification {
    UITextView *textView = notification.object;
    if (textView == self.titleTextView) {
        self.titlePlaceholderLabel.hidden = textView.text.length > 0;
    } else if (textView == self.contentTextView) {
        self.contentPlaceholderLabel.hidden = textView.text.length > 0;
    }
    
    if ([self.delegate respondsToSelector:@selector(editViewTextDidChange)]) {
        [self.delegate editViewTextDidChange];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
