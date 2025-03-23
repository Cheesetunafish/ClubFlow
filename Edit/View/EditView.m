//
//  EditView.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/22.
//

#import "EditView.h"
#import "Macros.h"
#import "Masonry.h"

@implementation EditView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpViews];
    }
    return self;
}


- (void)setUpViews {
    [self addSubview:self.titleTextView];
    [self addSubview:self.contentTextView];
}

- (UITextView *)titleTextView {
    if (!_titleTextView) {
        _titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, NAVBAR_STATUSBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_STATUSBAR_HEIGHT)];
        _titleTextView.editable = YES;
        _titleTextView.backgroundColor = [UIColor greenColor];
        _titleTextView.font = [UIFont boldSystemFontOfSize:24];
        _titleTextView.textAlignment = NSTextAlignmentLeft;
        
        _titleTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return _titleTextView;
}

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 2*NAVBAR_STATUSBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 2*NAVBAR_STATUSBAR_HEIGHT)];
        _contentTextView.editable = YES;
        _contentTextView.backgroundColor = [UIColor yellowColor];
        
    }
    return _contentTextView;
}

- (UILabel *)titlePlaceholderLabel {
    if (!_titlePlaceholderLabel) {
        _titlePlaceholderLabel = [[UILabel alloc] init];
        
    }
    return _titlePlaceholderLabel;
}

- (UILabel *)contentPlaceholderLabel {
    if (!_contentPlaceholderLabel) {
        _contentPlaceholderLabel = [[UILabel alloc] init];
    }
    return _contentPlaceholderLabel;
}

@end
