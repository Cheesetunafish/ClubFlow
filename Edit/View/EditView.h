//
//  EditView.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditView : UIView
/// titleText
@property (nonatomic, strong) UITextView *titleTextView;
/// content
@property (nonatomic, strong) UITextView *contentTextView;
/// title占位符
@property (nonatomic, strong) UILabel *titlePlaceholderLabel;
/// content占位符
@property (nonatomic, strong) UILabel *contentPlaceholderLabel;

@end

NS_ASSUME_NONNULL_END
