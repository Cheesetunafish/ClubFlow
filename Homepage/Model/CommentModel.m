//
//  CommentModel.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/19.
//

#import "CommentModel.h"


@implementation CommentModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.displayName = dic[@"displayName"];
        self.text = dic[@"text"];
        
        NSTimeInterval timestamp = [dic[@"timestamp"] doubleValue];
        self.timeString = [self formatTimestamp:timestamp];
        
        NSDictionary *repliesDict = dic[@"replies"];
        NSMutableArray *replies = [NSMutableArray array];
        if ([repliesDict isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in repliesDict) {
                NSDictionary *replyDic = repliesDict[key];
                CommentModel *replyModel = [[CommentModel alloc] initWithDictionary:replyDic];
                [replies addObject:replyModel];
            }
        }
        self.replyArray = replies;
    }
    return self;
}

- (NSString *)formatTimestamp:(NSTimeInterval)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter stringFromDate:date];
}

@end
