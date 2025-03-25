//
//  EditView.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EditViewDelegate <NSObject>

@optional
- (void)editViewDidBeginEditing;
- (void)editViewDidEndEditing;
- (void)editViewTextDidChange;

@end

@interface EditView : UIView
/// titleText
@property (nonatomic, strong) UITextView *titleTextView;
/// content
@property (nonatomic, strong) UITextView *contentTextView;
/// title占位符
@property (nonatomic, strong) UILabel *titlePlaceholderLabel;
/// content占位符
@property (nonatomic, strong) UILabel *contentPlaceholderLabel;
/// 代理
@property (nonatomic, weak) id<EditViewDelegate> delegate;

/// 设置标题和内容
- (void)setTitle:(NSString *)title content:(NSString *)content;
/// 获取当前编辑内容
- (NSDictionary *)getCurrentContent;
/// 清空编辑内容
- (void)clearContent;

@end

NS_ASSUME_NONNULL_END
