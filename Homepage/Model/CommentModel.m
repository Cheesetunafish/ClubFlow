//
//  CommentModel.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/19.
//

#import "CommentModel.h"


@implementation CommentModel

- (instancetype)initWithAuthor:(NSString *)author
                       content:(NSString *)content
                          time:(NSString *)time
                         likes:(NSInteger)likes
                       replies:(NSArray<CommentModel *> *)replies {
    self = [super init];
    if (self) {
        self.author = author;
        self.content = content;
        self.time = time;
        self.likes = likes;
        self.replies = replies;
    }
    return self;
}

@end
