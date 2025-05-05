//
//  CommentModel.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentModel : NSObject

@property (nonatomic, copy) NSString *commentID; // 可选，用于标识

@property (nonatomic, copy) NSString *displayName;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, strong) NSArray<CommentModel *> *replyArray;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
NS_ASSUME_NONNULL_END
