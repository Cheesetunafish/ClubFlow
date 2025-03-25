//
//  EditViewController.h
//  ClubFlow
//
//  Created by Shea Cheese on 2024/3/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EditViewControllerDelegate <NSObject>

- (void)editViewController:(UIViewController *)controller didFinishEditingWithTitle:(NSString *)title content:(NSString *)content;
- (void)editViewControllerDidCancel:(UIViewController *)controller;

@end

@interface EditViewController : UIViewController

@property (nonatomic, weak) id<EditViewControllerDelegate> delegate;
@property (nonatomic, copy, nullable) NSString *documentId;

// 如果传入documentId则为编辑模式，否则为新建模式
- (instancetype)initWithTitle:(nullable NSString *)title 
                    content:(nullable NSString *)content 
                documentId:(nullable NSString *)documentId;

@end

NS_ASSUME_NONNULL_END
