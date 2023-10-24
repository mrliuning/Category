//
//  UITableViewCell+ios13.m
//  TojoyCloud
//
//  Created by 李亚川 on 2020/4/28.
//  Copyright © 2020 tianjiu. All rights reserved.
//

#import "UITableViewCell+ios13.h"
#import <Aspects/Aspects.h>

@implementation UITableViewCell (ios13)

/// 重写load方法
+ (void)load {
    if (@available(iOS 13.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSError *error;
            //消息转发
            [self aspect_hookSelector:@selector(layoutSubviews) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){
                [[info instance] hook_layoutSubviews];
            } error:&error];
        });
    }
}

//把发送向layoutSubviews的消息，转向hook_layoutSubviews
- (void)hook_layoutSubviews {
    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"_UITableCellAccessoryButton")]) {
                for (UIView *view in subview.subviews) {
                    view.layer.borderWidth = 2.5f;
                    view.layer.borderColor = self.backgroundColor.CGColor;
                }
                break;
            }
        }
    }
}

@end
