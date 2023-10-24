//
//  NSString+Times.h
//  TojoyCloud
//
//  Created by yuntai on 2017/10/12.
//  Copyright © 2017年 _Engineer_雷海洋_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mach/mach_time.h>

//cpu tickcount 转换成时间的函数
double MachTimeToSecs(uint64_t time);

@interface NSString (Times)

/// 时间格式化成 00:00:00
/// @param time 时间，单位秒
+ (NSString *)longToTimeString:(long)time;


/// 格式化当前时间
/// @param format 时间格式
+ (NSString *)showCurrentTimeWithFormat:(NSString *)format;


/// 将制定时间戳转化成指定时间格式
/// @param timestamp 时间戳，13位数
/// @param format 时间格式
+ (NSString *)showTime:(NSString *)timestamp format:(NSString *)format;


/// 将制定时间戳转化成yy.MM.dd HH:mm
/// @param timestamp 时间戳，13位数
+ (NSString *)showTime:(NSString *)timestamp;


/// 将制定时间戳转化成MM.dd
/// @param timestamp 时间戳，13位数
+ (NSString *)showMonthDayTime:(NSString *)timestamp;


/// 将制定时间戳转化成yyyy-MM-dd
/// @param timestamp 时间戳，13位数
+ (NSString *)showLivesTime:(NSString *)timestamp;


/// 将制定时间戳转化成yyyy/MM/dd hh:mm
/// @param timestamp 时间戳，13位数
+ (NSString *)showFormatterLineTime:(NSString *)timestamp;


/// 将制定时间戳转化成yyyy-MM-dd HH:mm:ss
/// @param timestamp 时间戳，13位数
+(NSString *)showDetailLivesTime:(NSString *)timestamp;


/// 将制定时间戳转化成 今天HH:mm:ss 昨天HH:mm:ss 日期HH:mm:ss
/// @param timestamp 时间戳，13位数
+(NSString *)showDetailLivesTime3:(NSString *)timestamp;


/// 将制定时间戳转化成yyyy-MM-dd HH:mm:ss
/// @param timestamp 时间戳
+ (NSString *)showDetailTimeWithTimeInterval:(NSTimeInterval )timestamp;


/// 时间差, 传入的时间和当前的时间差
/// @param endTime 指定时间，YYYY-MM-dd HH:mm:ss
+ (NSInteger)dateTimeDifferenceWithEndTime:(NSString *)endTime;


/// 获取与当前时间比较的可读性时间（刚刚，10分钟前，两小时前等)
/// @param timeStamp 时间戳
+(NSString *)getTimeDiff:(NSTimeInterval)timeStamp;

/// 获取与当前时间比较的可读性时间（刚刚，10分钟前，两小时，天，和同年以及跨年前等)
/// @param timeStamp 时间戳
+(NSString *)getTimeDiffDayAndYear:(NSTimeInterval)timeStamp;

///获取当前时间戳  13位数
+(NSInteger)getTimeStamp;


/// 比较时间，返回YES，则表示 endTime>time
/// @param time yyyy-MM-dd-HH:mm:ss格式的时间
/// @param endTime yyyy-MM-dd-HH:mm:ss格式的时间
+(BOOL)compareTimeWithStartTime:(NSString *)time endTime:(NSString *)endTime;
/// 比较时间，返回YES，则表示 endTime>time
/// @param time  比较前格式的时间
/// @param endTime 比较后格式的时间
/// @param format 比较时间格式
+(BOOL)compareTimeWithStartTime:(NSString *)time endTime:(NSString *)endTime WithFormat:(NSString *)format;


/// 比较时间，返回YES，则表示 time>当前时间
/// @param time yyyy-MM-dd-HH:mm:ss格式的时间
+(BOOL)compareNowWithTime:(NSString *)time;


/// 获取yyyy.MM.dd格式的日期时间
/// @param timeStamp 时间戳 13位
+(NSString*)getDayTimeWithTimeStamp:(NSString *)timeStamp;


/// 将时间长度 转化成 时:分:秒
/// @param timeLength eg:1000,定位秒
+(NSString*)getHourTimeWithTimeLength:(NSInteger )timeLength;


/// 传入 秒  得到  xx分钟xx秒
/// @param totalTime 时间长度，定位秒
+(NSString *)getMMSSFromSS:(NSString *)totalTime;


/// 传入 完整时间 得到 目标格式时间
/// @param currentForamate 当前时间格式
/// @param targetFormate 目标时间格式
+(NSString *)getTimeFromTime:(NSString *)totalTime currentForamate:(NSString *)currentFroamte targetFormate:(NSString *)formate;


/// 将制定时间戳转化成yyyy-MM-dd HH:mm
/// @param timeStamp 时间戳，13位数
+(NSString*)getMiniteTimeWithTimeStamp:(NSString *)timeStamp;


/// 将当前时间戳转化成yyyy-MM-dd HH:mm:ss
+(NSString*)getNowTime;


/// 将某个时间转化成时间戳 13位数
/// @param timestamp 指定格式的时间
/// @param format 时间格式
+(NSString *)timestampSwitchTime:(NSString *)timestamp andFormatter:(NSString *)format;


/// 将某个时间戳转化成 时间
/// @param timeStampString 时间戳 13位
/// @param format 时间格式
+(NSString *)timeStampSwitchTime:(NSString *)timeStampString andDateFormatter:(NSString *)format;


/// 获取当前时间的时间戳，13位数
+ (NSString *)getCurrentTime;

/// 将 yyyy-MM-dd的时间转成字典：@{@"星期":@"M月d日"}
/// @param time yyyy-MM-dd的时间
+(NSDictionary *)editTime:(NSString *)time;


/// 将yyyy-MM-dd格式的时间转化成指定时间格式
/// @param time yyyy-MM-dd的时间
/// @param dataFormatter 指定时间格式
+(NSString *)editMonthAndDayTime:(NSString *)time andDateFormatter:(NSString *)dataFormatter;


/// 两个时间相差多少分钟
/// @param startTime yyyy-MM-dd HH:mm:ss格式的时间
/// @param endTime yyyy-MM-dd HH:mm:ss格式的时间
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

/// 将格式为[@"yyyy-MM-dd HH:mm:ss"]的时间字符串转换成"多少时间段前"，例如"3天前"，"5分钟前"等
/// @param str 格式为[@"yyyy-MM-dd HH:mm:ss"]的时间字符串
+ (NSString *)compareTimeToIntervalTimeString:(NSString *)strTime;

/// 将格式为[@"yyyy-MM-dd HH:mm:ss"]的时间字符串转换成"今天、昨天、前天"
/// @param strTime 格式为[@"yyyy-MM-dd HH:mm:ss"]的时间字符串
+ (NSString *)compareTimeToTodayTimeString:(NSString *)strTime;
@end
