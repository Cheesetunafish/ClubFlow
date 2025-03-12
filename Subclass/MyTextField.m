//
//  MyTextField.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/11.
//

#import "MyTextField.h"
#import "UIColor+Hex.h"

@implementation MyTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initStyle];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initStyle];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initStyle];
    }
    return self;
}

- (void)initStyle {
    self.backgroundColor = [UIColor colorWithHexString:@"F3F4F6"];
    self.layer.cornerRadius = 10;
}

- (void)rightViewGesture:(UIView *)rightView {
    rightView.userInteractionEnabled = YES;
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePasswd)];
    [rightView addGestureRecognizer:click];
}

- (void)hidePasswd {
    self.secureTextEntry = !self.isSecureTextEntry;
}

#pragma mark - Rewrite

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect leftRect = [super leftViewRectForBounds:bounds];
    leftRect.origin.x += 16;
    return leftRect;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect rightRect = [super rightViewRectForBounds:bounds];
    rightRect.origin.x -= 16;
    return rightRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 45, 5);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 45, 5);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 45, 5);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
