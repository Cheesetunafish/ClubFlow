//
//  DocumentCell.h
//  ClubFlow
//
//  Created by Shea Cheese on 2024/3/23.
//

#import <UIKit/UIKit.h>
#import "DocumentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DocumentCell : UITableViewCell

@property (nonatomic, strong) DocumentModel *document;

+ (NSString *)identifier;
- (void)configureWithDocument:(DocumentModel *)document;

@end

NS_ASSUME_NONNULL_END 