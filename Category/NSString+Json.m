//
//  NSString+Json.m
//  TojoyCloud
//
//  Created by chenyu on 2018/9/3.
//  Copyright © 2018年 _Engineer_雷海洋_. All rights reserved.
//

#import "NSString+Json.h"

@implementation NSString (Json)

/// 字典转json字符串方法
/// @param dict 字典
+ (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

/// 将url里面的参数键值对转成一个字典 遍历的方式截取键值对
/// @param urlStr url
+ (NSMutableDictionary *)getH5URLParameters:(NSString *)urlStr {
    
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    
    NSMutableString *mutParamStr = [NSMutableString stringWithString:parametersString];
    NSRange range1 = {0,mutParamStr.length};
    [mutParamStr replaceOccurrencesOfString:@"?" withString:@"&" options:NSLiteralSearch range:range1];
    
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    // 判断参数是单个参数还是多个参数
    if ([mutParamStr containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [mutParamStr componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [mutParamStr componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    return params;
    
}

/// 将url里面的参数键值对转成一个字典 遍历的方式截取键值对
/// @param urlStr url
+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr {
    
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}


/// 将url里面的参数键值对转成一个字典，使用苹果系统提供的方法截取键值对
/// @param urlStr url
+ (NSMutableDictionary *)getRequestURLParameters:(NSString *)urlStr {
    if (!urlStr) {
        return nil;
    }
    if ([urlStr containsString:@"#"]) {
        NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
        if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
            NSArray *array = [urlStr componentsSeparatedByString:@"?"];
            if (array && array.count >= 2) {
                NSString * host = array[0];
                NSString *paramsStr = [urlStr substringFromIndex:host.length+1];
                if (paramsStr.length) {
    //                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
                    NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
                    for (NSString *param in paramArray) {
                        if (param && param.length) {
                            NSArray *parArr = [param componentsSeparatedByString:@"="];
                            if (parArr.count >= 2) {
                                NSString * subHost = parArr[0];
                                NSString * subParamsStr = [param substringFromIndex:subHost.length+1];
                                [paramsDict setObject:subParamsStr forKey:parArr[0]];
                            }
                        }
                    }
                    return paramsDict;
                }else{
                    return nil;
                }
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }
    NSURLComponents* urlComponents =  [NSURLComponents componentsWithString:urlStr];
    NSMutableDictionary* queryItemDict = [NSMutableDictionary dictionary];
    NSArray* queryItems = urlComponents.queryItems;
    for (NSURLQueryItem* item in queryItems) {
        [queryItemDict setObject:item.value?:@"" forKey:item.name];
    }
    return queryItemDict;
}

@end
