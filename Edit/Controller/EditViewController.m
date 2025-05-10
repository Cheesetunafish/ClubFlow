//
//  EditViewController.m
//  ClubFlow
//
//  Created by Shea Cheese on 2024/3/23.
//

#import "EditViewController.h"
#import "EditView.h"
#import "Masonry.h"
#import "DocumentModel.h"
@import FirebaseDatabase;
@import FirebaseAuth;

@interface EditViewController () <EditViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) EditView *editView;
@property (nonatomic, strong) UIToolbar *formatToolbar;
@property (nonatomic, copy) NSString *initialTitle;
@property (nonatomic, copy) NSString *initialContent;
@property (nonatomic, strong) FIRDatabaseReference *databaseRef;
//@property (nonatomic, strong) UIButton *addDocButton;

@end

@implementation EditViewController

#pragma mark - Lifecycle

- (instancetype)initWithTitle:(nullable NSString *)title 
                    content:(nullable NSString *)content 
                documentId:(nullable NSString *)documentId {
    self = [super init];
    if (self) {
        _initialTitle = title;
        _initialContent = content;
        _documentId = documentId;
        _databaseRef = [[FIRDatabase database] reference];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupNavigationBar];
    [self setupKeyboardNotifications];
    [self setupFormatToolbar];
    
    if (self.initialTitle || self.initialContent) {
        [self.editView setTitle:self.initialTitle ?: @"" content:self.initialContent ?: @""];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 确保每次显示时导航栏都正确显示
    self.navigationController.navigationBar.hidden = NO;
    [self.editView.titleTextView becomeFirstResponder];
}

#pragma mark - Setup Methods

- (void)setupViews {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    self.editView = [[EditView alloc] init];
    self.editView.delegate = self;
    [self.view addSubview:self.editView];
    
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupNavigationBar {
    // 取消按钮
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                               target:self
                                                                               action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    // 完成按钮
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(doneButtonTapped)];
    
    // 格式化按钮
    UIBarButtonItem *formatButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"textformat"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(formatButtonTapped)];
    
    self.navigationItem.rightBarButtonItems = @[doneButton, formatButton];
}

- (void)setupFormatToolbar {
    self.formatToolbar = [[UIToolbar alloc] init];
    [self.formatToolbar sizeToFit];
    
    NSMutableArray *items = [NSMutableArray array];
    
    // 字体大小按钮
    [items addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"textformat.size"]
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(fontSizeButtonTapped)]];
    
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    
    // 粗体按钮
    [items addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"bold"]
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(boldButtonTapped)]];
    
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    
    // 斜体按钮
    [items addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"italic"]
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(italicButtonTapped)]];
    
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    
    // 颜色按钮
    [items addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"paintpalette"]
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(colorButtonTapped)]];
    
    self.formatToolbar.items = items;
    self.editView.contentTextView.inputAccessoryView = self.formatToolbar;
}

- (void)setupKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
}

#pragma mark - Format Actions

- (void)fontSizeButtonTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择字体大小"
                                                                 message:nil
                                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSArray *sizes = @[@12, @14, @16, @18, @20, @24];
    for (NSNumber *size in sizes) {
        [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@", size]
                                                style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * _Nonnull action) {
            [self changeFontSize:size.floatValue];
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)boldButtonTapped {
    [self toggleBoldForSelectedText];
}

- (void)italicButtonTapped {
    [self toggleItalicForSelectedText];
}

- (void)colorButtonTapped {
    UIColorPickerViewController *colorPicker = [[UIColorPickerViewController alloc] init];
    colorPicker.delegate = (id)self;
    [self presentViewController:colorPicker animated:YES completion:nil];
}

#pragma mark - Text Formatting

- (void)changeFontSize:(CGFloat)size {
    UITextRange *selectedRange = self.editView.contentTextView.selectedTextRange;
    if (selectedRange) {
        UIFont *currentFont = self.editView.contentTextView.font;
        UIFont *newFont = [UIFont fontWithName:currentFont.fontName size:size];
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.editView.contentTextView.attributedText];
        NSRange range = [self.editView.contentTextView selectedRange];
        [attributedText addAttribute:NSFontAttributeName value:newFont range:range];
        
        self.editView.contentTextView.attributedText = attributedText;
    }
}

- (void)toggleBoldForSelectedText {
    NSRange selectedRange = [self.editView.contentTextView selectedRange];
    if (selectedRange.length > 0) {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.editView.contentTextView.attributedText];
        [attributedText enumerateAttributesInRange:selectedRange options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            UIFont *currentFont = attrs[NSFontAttributeName];
            UIFontDescriptor *descriptor = currentFont.fontDescriptor;
            UIFontDescriptorSymbolicTraits traits = descriptor.symbolicTraits;
            
            if (traits & UIFontDescriptorTraitBold) {
                traits &= ~UIFontDescriptorTraitBold;
            } else {
                traits |= UIFontDescriptorTraitBold;
            }
            
            descriptor = [descriptor fontDescriptorWithSymbolicTraits:traits];
            UIFont *newFont = [UIFont fontWithDescriptor:descriptor size:currentFont.pointSize];
            
            [attributedText addAttribute:NSFontAttributeName value:newFont range:range];
        }];
        
        self.editView.contentTextView.attributedText = attributedText;
    }
}

- (void)toggleItalicForSelectedText {
    NSRange selectedRange = [self.editView.contentTextView selectedRange];
    if (selectedRange.length > 0) {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.editView.contentTextView.attributedText];
        [attributedText enumerateAttributesInRange:selectedRange options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            UIFont *currentFont = attrs[NSFontAttributeName];
            UIFontDescriptor *descriptor = currentFont.fontDescriptor;
            UIFontDescriptorSymbolicTraits traits = descriptor.symbolicTraits;
            
            if (traits & UIFontDescriptorTraitItalic) {
                traits &= ~UIFontDescriptorTraitItalic;
            } else {
                traits |= UIFontDescriptorTraitItalic;
            }
            
            descriptor = [descriptor fontDescriptorWithSymbolicTraits:traits];
            UIFont *newFont = [UIFont fontWithDescriptor:descriptor size:currentFont.pointSize];
            
            [attributedText addAttribute:NSFontAttributeName value:newFont range:range];
        }];
        
        self.editView.contentTextView.attributedText = attributedText;
    }
}

#pragma mark - UIColorPickerViewControllerDelegate

- (void)colorPickerViewControllerDidSelectColor:(UIColorPickerViewController *)viewController {
    NSRange selectedRange = [self.editView.contentTextView selectedRange];
    if (selectedRange.length > 0) {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.editView.contentTextView.attributedText];
        [attributedText addAttribute:NSForegroundColorAttributeName value:viewController.selectedColor range:selectedRange];
        self.editView.contentTextView.attributedText = attributedText;
    }
}

#pragma mark - Keyboard Handling

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.size.height, 0.0);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.editView.contentTextView.contentInset = contentInsets;
        self.editView.contentTextView.scrollIndicatorInsets = contentInsets;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        self.editView.contentTextView.contentInset = UIEdgeInsetsZero;
        self.editView.contentTextView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}

#pragma mark - EditViewDelegate

- (void)editViewDidBeginEditing {
    // 处理开始编辑事件
}

- (void)editViewDidEndEditing {
    // 处理结束编辑事件
}

- (void)editViewTextDidChange {
    // 处理文本变化事件
}

#pragma mark - Actions
// 点击取消按钮
- (void)cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 点击完成按钮
- (void)doneButtonTapped {
    NSDictionary *content = [self.editView getCurrentContent];
    NSString *title = content[@"title"];
    NSString *documentContent = content[@"content"];
    if (title.length == 0 && documentContent.length == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    // 创建DocumentModel对象
    DocumentModel *document = [[DocumentModel alloc] init];
    document.title = title;
    document.content = documentContent;
    document.createTime = [[NSDate date] timeIntervalSince1970];
    document.isPinned = NO;
    // 编辑模式
    if (self.documentId) {
        document.documentId = self.documentId;
        NSDictionary *documentData = [document toDictionary];
        FIRDatabaseReference *docRef = [[self.databaseRef child:@"documents"] child:self.documentId];
        [docRef updateChildValues:documentData withCompletionBlock:[self saveCompletionBlock]];
    } else {
        // 新建模式
        FIRDatabaseReference *newDocRef = [[self.databaseRef child:@"documents"] childByAutoId];
        document.documentId = newDocRef.key;
        NSDictionary *documentData = [document toDictionary];
        [newDocRef setValue:documentData withCompletionBlock:[self saveCompletionBlock]];
    }
}

- (void (^)(NSError * _Nullable, FIRDatabaseReference * _Nonnull))saveCompletionBlock {
    return ^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                // 显示错误提示
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存失败"
                                                                             message:error.localizedDescription
                                                                      preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                // 发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DocumentDidUpdateNotification" 
                                                                object:nil];
                // 关闭编辑界面
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });
    };
}

- (void)formatButtonTapped {
    [self.editView.contentTextView becomeFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNewDocumentMode {
    self.documentId = nil;
    self.editView.titleTextView.text = @"";
    self.editView.contentTextView.text = @"";
    self.navigationItem.title = @"新建文档";
    
    // 设置placeholder
    self.editView.titlePlaceholderLabel.hidden = NO;
    self.editView.contentPlaceholderLabel.hidden = NO;
    
    // 让标题输入框获得焦点
    [self.editView.titleTextView becomeFirstResponder];
}

@end
