//
//  DocumentModel.h
//  ClubFlow
//
//  Created by Shea Cheese on 2024/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DocumentModel : NSObject

@property (nonatomic, copy) NSString *documentId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSTimeInterval createTime;
@property (nonatomic, assign) BOOL isPinned;
@property (nonatomic, copy) NSString *userId;

// 使用Firebase数据创建模型
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
// 转换为Firebase数据
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END 
