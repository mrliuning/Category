//
//  NSString+Times.m
//  TojoyCloud
//
//  Created by yuntai on 2017/10/12.
//  Copyright © 2017年 _Engineer_雷海洋_. All rights reserved.
//

#import "NSString+Times.h"
#import <Macro/CommonBaseMacros.h>

//cpu tickcount 转换成时间的函数
double MachTimeToSecs(uint64_t time)
{
    mach_timebase_info_data_t timebase;
    
    mach_timebase_info(&timebase);
    
    return (double)time * (double)timebase.numer /
    
    (double)timebase.denom /1e9;
}

@implementation NSString (Times)


/// 时间格式化成 00:00:00
/// @param time 时间，单位秒
+ (NSString *)longToTimeString:(long)time {
    if (time <= 0) {
        return @"00:00:00";
    }
    long duration = time/1000;
    long hour = duration/3600;
    long minute = (duration%3600)/60;
    long second = duration%60;
    return [NSString stringWithFormat:@"%@:%@:%@", [self toDoubleString:hour], [self toDoubleString:minute], [self toDoubleString:second]];
}

+ (NSString *)toDoubleString:(long)num {
    return num >= 10 ? @(num).stringValue : [NSString stringWithFormat:@"0%ld", num];
}



/// 格式化当前时间
/// @param format 时间格式
+ (NSString *)showCurrentTimeWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *timeDate = [NSDate date];
    NSString *time = [dateFormatter stringFromDate:timeDate];
    return time;
}

/// 将制定时间戳转化成指定时间格式
/// @param timestamp 时间戳，13位数
/// @param format 时间格式
+ (NSString *)showTime:(NSString *)timestamp format:(NSString *)format
{
    if (timestamp== nil || [timestamp isEqualToString:@""]) {
        return @"";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/ 1000.0];;
    NSString *time = [dateFormatter stringFromDate:timeDate];
    return time;
}


/// 将制定时间戳转化成yy.MM.dd HH:mm
/// @param timestamp 时间戳，13位数
+ (NSString *)showTime:(NSString *)timestamp{

    NSString *time = [self showTime:timestamp format:@"yy.MM.dd HH:mm"];
    return time;
}

/// 将制定时间戳转化成MM.dd
/// @param timestamp 时间戳，13位数
+ (NSString *)showMonthDayTime:(NSString *)timestamp
{
    NSString *time = [self showTime:timestamp format:@"MM.dd"];
    return time;
}

/// 将制定时间戳转化成yyyy-MM-dd
/// @param timestamp 时间戳，13位数
+(NSString *)showLivesTime:(NSString *)timestamp
{
    NSString *time = [self showTime:timestamp format:@"yyyy-MM-dd"];
    return time;
}

/// 将制定时间戳转化成yyyy/MM/dd hh:mm
/// @param timestamp 时间戳，13位数
+ (NSString *)showFormatterLineTime:(NSString *)timestamp
{
    NSString *time = [self showTime:timestamp format:@"yyyy/MM/dd HH:mm"];
    return time;
}

/// 将制定时间戳转化成yyyy-MM-dd HH:mm:ss
/// @param timestamp 时间戳，13位数
+(NSString *)showDetailLivesTime:(NSString *)timestamp
{
    NSString *time = [self showTime:timestamp format:@"yyyy-MM-dd HH:mm:ss"];
    return time;
}

/// 将制定时间戳转化成 今天 hms 昨天hms 日期hms
/// @param timestamp 时间戳，13位数
+(NSString *)showDetailLivesTime3:(NSString *)timestamp
{
    if (timestamp== nil || [timestamp isEqualToString:@""]) {
        return @"";
    }
    NSTimeInterval playTime = [timestamp doubleValue]/ 1000.0;
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    
    double distanceTime = nowTime - playTime;
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    NSDate* beDate = [NSDate dateWithTimeIntervalSince1970:playTime];
    [df setDateFormat:@"HH:mm:ss"];
    NSString* timeStr = [df stringFromDate:beDate];
    [df setDateFormat:@"dd"];
    NSString* nowDay = [df stringFromDate:[NSDate date]];
    NSString* playDay = [df stringFromDate:beDate];
    
    if(distanceTime <24*60*60&& [nowDay integerValue] == [playDay integerValue]){//时间小于一天
        return  [NSString stringWithFormat:@"今天 %@",timeStr];
    }else if(distanceTime<24*60*60*2&& [nowDay integerValue] != [playDay integerValue]){
        
        if([nowDay integerValue] - [playDay integerValue] ==1|| ([playDay integerValue] - [nowDay integerValue] >10&& [nowDay integerValue] ==1)) {
            return  [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
    }
    return [self showDetailLivesTime:timestamp];
}


/// 将制定时间戳转化成yyyy-MM-dd HH:mm:ss
/// @param timestamp 时间戳
+ (NSString *)showDetailTimeWithTimeInterval:(NSTimeInterval)timestamp
{
    if (!timestamp) {
        return @"";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[@(timestamp).stringValue integerValue]];
    NSString *time = [dateFormatter stringFromDate:timeDate];
    return time;
}



/// 时间差, 传入的时间和当前的时间差
/// @param endTime 指定时间 YYYY-MM-dd HH:mm:ss
+ (NSInteger)dateTimeDifferenceWithEndTime:(NSString *)endTime
{
    NSInteger end = [NSString timeSwitchTimeStamp:endTime andFormatter:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *phoneDate = [NSDate date]; // 手机时间
    NSTimeInterval phoneTime = [phoneDate timeIntervalSince1970]*1;
    NSInteger value = (NSInteger)(end - phoneTime);
    return value;
}

/// 获取与当前时间比较的可读性时间（刚刚，10分钟前，两小时前等)
/// @param timeStamp 时间戳
+(NSString *)getTimeDiff:(NSTimeInterval)timeStamp
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];

    NSDate *currentDate = [NSDate date];
    NSTimeInterval distance = [currentDate timeIntervalSinceDate:timeDate];
    
    NSString *timestamp;
    
    if (distance < 60) {
        timestamp = [NSString stringWithFormat:@"%@",@"刚刚"];
    }
    else if (distance < 60 * 60) {
        int distanceInt = distance / 60;
        timestamp = [NSString stringWithFormat:@"%d %@", distanceInt, @"分钟前"];
    }
    else if (distance < 60 * 60 * 24) {
        int distanceInt = distance / 60 / 60;
        timestamp = [NSString stringWithFormat:@"%d %@", distanceInt, @"小时前"];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        int distanceInt = distance / 60 / 60 / 24;
        timestamp = [NSString stringWithFormat:@"%d %@", distanceInt, @"天前"];
    }
    else if (distance < 60 * 60 * 24 * 7 * 4) {
        int distanceInt = distance / 60 / 60 / 24 / 7;
        timestamp = [NSString stringWithFormat:@"%d %@", distanceInt, @"周前"];
    }
    else {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        timestamp = [formatter stringFromDate:date];
    }
    return timestamp;
}

/// 获取与当前时间比较的可读性时间（刚刚，10分钟前，两小时，天，和同年以及跨年前等)
/// @param timeStamp 时间戳
+(NSString *)getTimeDiffDayAndYear:(NSTimeInterval)timeStamp
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];

    NSDate *currentDate = [NSDate date];
    NSTimeInterval distance = [currentDate timeIntervalSinceDate:timeDate];
    
    NSString *timestamp;
    
    if (distance < 60) {
        timestamp = [NSString stringWithFormat:@"%@",@"刚刚"];
    }
    else if (distance < 60 * 60) {
        int distanceInt = distance / 60;
        timestamp = [NSString stringWithFormat:@"%d %@", distanceInt, @"分钟前"];
    }
    else if (distance < 60 * 60 * 24) {
        int distanceInt = distance / 60 / 60;
        timestamp = [NSString stringWithFormat:@"%d %@", distanceInt, @"小时前"];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        int distanceInt = distance / 60 / 60 / 24;
        timestamp = [NSString stringWithFormat:@"%d %@", distanceInt, @"天前"];
    }
    else if([self isSameYear:timeDate])
    {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        timestamp = [formatter stringFromDate:date];
    }
    else {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        timestamp = [formatter stringFromDate:date];
    }
    return timestamp;
}

+(NSString *)getStrTimeDiffDayAndYear:(NSString *)curDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:curDate];

    NSDate *currentDate = [NSDate date];
    NSTimeInterval distance = [currentDate timeIntervalSinceDate:timeDate];
    
    NSString *timestamp;
    
    if (distance < 60) {
        timestamp = [NSString stringWithFormat:@"%@",@"刚刚"];
    }
    else if (distance < 60 * 60) {
        int distanceInt = distance / 60;
        timestamp = [NSString stringWithFormat:@"%d %@", distanceInt, @"分钟前"];
    }
    else if (distance < 60 * 60 * 24) {
        int distanceInt = distance / 60 / 60;
        timestamp = [NSString stringWithFormat:@"%d %@", distanceInt, @"小时前"];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        int distanceInt = distance / 60 / 60 / 24;
        timestamp = [NSString stringWithFormat:@"%d %@", distanceInt, @"天前"];
    }
    else if([self isSameYear:timeDate])
    {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        
        NSDate* date = [dateFormatter dateFromString:curDate];
        timestamp = [formatter stringFromDate:date];
    }
    else {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSDate* date = [dateFormatter dateFromString:curDate];
        timestamp = [formatter stringFromDate:date];
    }
    return timestamp;
}


+ (BOOL)isSameYear:(NSDate *)compareDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear ;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    NSDateComponents *compareCmps = [calendar components:unit fromDate:compareDate];
    
    return compareCmps.year == nowCmps.year;
}


/// 获取当前时间戳
+(NSInteger)getTimeStamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间
    
    NSLog(@"设备当前的时间:%@",[formatter stringFromDate:datenow]);
    
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
    timeSp = timeSp*1000;
    NSLog(@"设备当前的时间戳:%ld",(long)timeSp); //时间戳的值
    
    return timeSp;
}


/// 比较时间，返回YES，则表示 endTime>time
/// @param time yyyy-MM-dd-HH:mm:ss格式的时间
/// @param endTime yyyy-MM-dd-HH:mm:ss格式的时间
+(BOOL)compareTimeWithStartTime:(NSString *)time endTime:(NSString *)endTime{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    
    NSDate *startD = [date dateFromString:time];
    NSDate *endD = [date dateFromString:endTime];;
    
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;

    NSTimeInterval value = end - start;
    
    if (value>=0) {
        return YES;
    }
    
    return NO;
}
+(BOOL)compareTimeWithStartTime:(NSString *)time endTime:(NSString *)endTime WithFormat:(NSString *)format
{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:format];
    
    NSDate *startD = [date dateFromString:time];
    NSDate *endD = [date dateFromString:endTime];;
    
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;

    NSTimeInterval value = end - start;
    
    if (value>=0) {
        return YES;
    }
    
    return NO;
}

/// 比较时间，返回YES，则表示 time>当前时间
/// @param time yyyy-MM-dd-HH:mm:ss格式的时间
+(BOOL)compareNowWithTime:(NSString *)time{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSDate *endD = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/ 1000.0];
    
    NSDate *startD = [NSDate date];
    
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    if (value>0) {
        return YES;
    }
    
    return NO;
}

/// 获取yyyy.MM.dd格式的日期时间
/// @param timeStamp 时间戳 13位
+(NSString*)getDayTimeWithTimeStamp:(NSString *)timeStamp
{
    if (!timeStamp) {
        return @"";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[timeStamp integerValue]/ 1000.0];
    NSString *time = [dateFormatter stringFromDate:timeDate];
    return time;
}

/// 将时间长度 转化成 时:分:秒
/// @param timeLength eg:1000,定位秒
+(NSString*)getHourTimeWithTimeLength:(NSInteger)timeLength
{
    NSString * hour = timeLength/60/60<10?[NSString stringWithFormat:@"0%ld",timeLength/60/60]:[NSString stringWithFormat:@"%ld",timeLength/60/60];
    NSString * minite = timeLength%3600/60<10?[NSString stringWithFormat:@"0%ld",timeLength%3600/60]:[NSString stringWithFormat:@"%ld",timeLength%3600/60];
    NSString * secont = timeLength%60<10?[NSString stringWithFormat:@"0%ld",timeLength%60]:[NSString stringWithFormat:@"%ld",timeLength%60];
    NSString * timeString = [NSString stringWithFormat:@"%@:%@:%@",hour,minite,secont];
    return timeString;
}



/// 传入 秒  得到  xx分钟xx秒
/// @param totalTime 时间长度，定位秒
+(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    if (str_second.length<2) {
        str_second = [NSString stringWithFormat:@"0%@",str_second];
    }
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
        
    return format_time;
}

+(NSString *)getTimeFromTime:(NSString *)totalTime currentForamate:(NSString *)currentFroamte targetFormate:(NSString *)formate{
    if (beNil(totalTime)) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:currentFroamte];
    NSDate *someDay = [formatter dateFromString:totalTime];
    // 格式化时间
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterFullStyle];// 修改下面提到的北京时间的日期格式
    [formatter1 setTimeStyle:NSDateFormatterFullStyle];// 修改下面提到的北京时间的时间格式
    [formatter1 setDateFormat:formate];
    NSString* dateString = [formatter1 stringFromDate:someDay];
    
    return dateString;
}


/// 将制定时间戳转化成yyyy-MM-dd HH:mm
/// @param timeStamp 时间戳，13位数
+(NSString*)getMiniteTimeWithTimeStamp:(NSString *)timeStamp
{
    NSString *time = [self showTime:timeStamp format:@"yyyy-MM-dd HH:mm"];

    return time;
}

/// 将当前时间戳转化成yyyy-MM-dd HH:mm:ss
+(NSString*)getNowTime{
    
    NSDateFormatter *tFormat=[[NSDateFormatter alloc] init];
    [tFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *tResult=[NSString stringWithFormat:@"%@",[tFormat stringFromDate:[NSDate date]]];
    return tResult;
}

/// 将某个时间转化成时间戳，13位数
/// @param timestamp 指定格式的时间
/// @param format 时间格式
+(NSString *)timestampSwitchTime:(NSString *)timestamp andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSDate* dateTodo = [formatter dateFromString:timestamp];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateTodo timeIntervalSince1970]*1000];
    return timeSp;
}

/// 将某个时间戳转化成 时间
/// @param timeStampString 时间戳 13位
/// @param format 时间格式
+(NSString *)timeStampSwitchTime:(NSString *)timeStampString andDateFormatter:(NSString *)format{
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

/// 获取当前时间的时间戳，13位数
+ (NSString *)getCurrentTime
{
    NSDate *destinationDate = [NSDate date];
    NSTimeInterval timeGmt = [destinationDate timeIntervalSince1970] * 1000;
    
    NSString * sCurrentTime = [NSString stringWithFormat:@"%.f", timeGmt];
    
    return sCurrentTime;
}


/// 将 yyyy-MM-dd的时间转成字典：@{@"星期":@"M月d日"}
/// @param time yyyy-MM-dd的时间
+(NSDictionary *)editTime:(NSString *)time
{
    if (beNil(time)) {
        return @{};
    }
//    NSArray * weekEngArray=@[@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT",@"SUN"];
    NSArray * weekChiArray=@[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    
    NSLocale * alocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    formatter.locale = alocale;
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *someDay = [formatter dateFromString:time];
    // 格式化时间
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
    formatter1.locale = alocale;
    [formatter1 setDateStyle:NSDateFormatterFullStyle];// 修改下面提到的北京时间的日期格式
    [formatter1 setTimeStyle:NSDateFormatterFullStyle];// 修改下面提到的北京时间的时间格式
    [formatter1 setDateFormat:@"M月d日"];
    NSString* dateString = [formatter1 stringFromDate:someDay];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    dateformatter.locale = alocale;
    [dateformatter setDateFormat:@"EEE"];
    
    NSString * weekString = [dateformatter stringFromDate:someDay];
    
    NSDictionary * dict=[[NSDictionary alloc]init];
    for (NSInteger i=0; i<weekChiArray.count; i++) {
        if ([weekString containsString:weekChiArray[i]]) {
            return @{weekChiArray[i]:dateString};
        }
    }

    return dict;
}


/// 将yyyy-MM-dd格式的时间转化成指定时间格式
/// @param time yyyy-MM-dd的时间
/// @param dataFormatter 指定时间格式
+(NSString *)editMonthAndDayTime:(NSString *)time andDateFormatter:(NSString *)dataFormatter
{
    if (beNil(time)) {
        return @"";
    } else if (time.length > 10) {
        return [NSString editMonthAndDayTimeTwo:time andDateFormatter:dataFormatter];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *someDay = [formatter dateFromString:time];
    // 格式化时间
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterFullStyle];// 修改下面提到的北京时间的日期格式
    [formatter1 setTimeStyle:NSDateFormatterFullStyle];// 修改下面提到的北京时间的时间格式
    [formatter1 setDateFormat:dataFormatter];
    NSString* dateString = [formatter1 stringFromDate:someDay];
    
    return dateString;
}

/// 将yyyy-MM-dd HH:mm:ss格式的时间转化成指定时间格式
/// @param time yyyy-MM-dd HH:mm:ss的时间
/// @param dataFormatter 指定时间格式
+(NSString *)editMonthAndDayTimeTwo:(NSString *)time andDateFormatter:(NSString *)dataFormatter
{
    if (beNil(time)) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *someDay = [formatter dateFromString:time];
    // 格式化时间
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterFullStyle];// 修改下面提到的北京时间的日期格式
    [formatter1 setTimeStyle:NSDateFormatterFullStyle];// 修改下面提到的北京时间的时间格式
    [formatter1 setDateFormat:dataFormatter];
    NSString* dateString = [formatter1 stringFromDate:someDay];
    
    return dateString;
}

#pragma mark - 将某个时间转化成 时间戳
+ (NSInteger)timeSwitchTimeStamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
//    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值
    return timeSp;
    
}



/// 两个时间相差多少分钟
/// @param startTime yyyy-MM-dd HH:mm:ss格式的时间
/// @param endTime yyyy-MM-dd HH:mm:ss格式的时间
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startD =[date dateFromString:startTime];
    
    NSDate *endD = [date dateFromString:endTime];
    
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    
    NSTimeInterval value = end - start;

    int minute = (int)value /60%60;
      
    return @(minute).stringValue;
}

/// 将格式为[@"yyyy-MM-dd HH:mm:ss"]的时间字符串转换成"多少时间段前"，例如"3天前"，"5分钟前"等
/// @param str 格式为[@"yyyy-MM-dd HH:mm:ss"]的时间字符串
+ (NSString *)compareTimeToIntervalTimeString:(NSString *)strTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *timeDate = [dateFormatter dateFromString:strTime];
    
    NSDate *currentDate = [NSDate date];
    
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    
    long temp = 0;
    
    NSString *result;
    
    if (timeInterval/60 < 1) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
        
    }
    return  result;
}

/// 将格式为[@"yyyy-MM-dd HH:mm:ss"]的时间字符串转换成"今天、昨天、前天"
/// @param strTime 格式为[@"yyyy-MM-dd HH:mm:ss"]的时间字符串
+ (NSString *)compareTimeToTodayTimeString:(NSString *)strTime{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
    NSDate *currentDate = [NSDate date];
    NSDate *aStrDate = [dateFormatter dateFromString:[strTime substringToIndex:10]];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:aStrDate toDate:currentDate options:0];
    
    switch (cmps.day) {
        case 0:
            return @"今天";
            break;
        case 1:
            return @"昨天";
            break;
        case 2:
            return @"前天";
            break;
        default:
            return @"其他";
            break;
    }
}


@end
