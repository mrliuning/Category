//
//  NSString+Json.h
//  TojoyCloud
//
//  Created by chenyu on 2018/9/3.
//  Copyright © 2018年 _Engineer_雷海洋_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Json)

/// 字典转json字符串方法
/// @param dict 字典
+ (NSString *)convertToJsonData:(NSDictionary *)dict;

/// 将url里面的参数键值对转成一个字典，遍历的方式截取键值对
/// @param urlStr url
+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr;

/// 将url里面的参数键值对转成一个字典，遍历的方式截取键值对
/// @param urlStr url
+ (NSMutableDictionary *)getH5URLParameters:(NSString *)urlStr;

/// 将url里面的参数键值对转成一个字典，使用苹果系统提供的方法截取键值对
/// @param urlStr url
+ (NSMutableDictionary *)getRequestURLParameters:(NSString *)urlStr;

@end
