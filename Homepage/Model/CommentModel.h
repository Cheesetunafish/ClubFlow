//
//  CommentModel.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentModel : NSObject
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, strong) NSArray<CommentModel *> *replies;

- (instancetype)initWithAuthor:(NSString *)author
                       content:(NSString *)content
                          time:(NSString *)time
                         likes:(NSInteger)likes
                       replies:(NSArray<CommentModel *> *)replies;
@end

NS_ASSUME_NONNULL_END
