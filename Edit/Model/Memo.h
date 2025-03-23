//
//  Memo.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Memo : NSObject
/// id
@property (nonatomic, copy) NSString *memoId;
/// title
@property (nonatomic, copy) NSString *title;
/// content
@property (nonatomic, copy) NSString *content;
/// timestamp
@property (nonatomic, assign) NSTimeInterval timestamp;

@end

NS_ASSUME_NONNULL_END
