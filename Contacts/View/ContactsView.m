//
//  ContactsView.m
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/21.
//

#import "ContactsView.h"

@implementation ContactsView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self showUpView];
    }
    return self;
}

- (void)showUpView {
    self.backgroundColor = [UIColor blueColor];
}

@end
