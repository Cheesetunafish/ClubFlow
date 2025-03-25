//
//  DocumentModel.m
//  ClubFlow
//
//  Created by Shea Cheese on 2024/3/23.
//

#import "DocumentModel.h"

@implementation DocumentModel

+ (instancetype)documentWithDictionary:(NSDictionary *)dict {
    DocumentModel *model = [[DocumentModel alloc] init];
    model.documentId = dict[@"documentId"];
    model.title = dict[@"title"];
    model.content = dict[@"content"];
    model.createTime = [dict[@"createTime"] doubleValue];
    model.isPinned = [dict[@"isPinned"] boolValue];
    return model;
}

- (NSDictionary *)toDictionary {
    return @{
        @"documentId": self.documentId ?: @"",
        @"title": self.title ?: @"",
        @"content": self.content ?: @"",
        @"createTime": @(self.createTime),
        @"isPinned": @(self.isPinned)
    };
}

@end 