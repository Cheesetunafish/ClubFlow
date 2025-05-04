//
//  DocumentModel.m
//  ClubFlow
//
//  Created by Shea Cheese on 2024/3/23.
//

#import "DocumentModel.h"

@implementation DocumentModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.documentId = dictionary[@"documentId"];
        self.title = dictionary[@"title"];
        self.content = dictionary[@"content"];
        self.createTime = [dictionary[@"createTime"] doubleValue];
        self.isPinned = [dictionary[@"isPinned"] boolValue];
        self.userId = dictionary[@"userId"];
    }
    return self;
}

- (NSDictionary *)toDictionary {
    return @{
        @"documentId": self.documentId ?: @"",
        @"title": self.title ?: @"",
        @"content": self.content ?: @"",
        @"createTime": @(self.createTime),
        @"isPinned": @(self.isPinned),
        @"userId": self.userId ?: @""
    };
}

@end 