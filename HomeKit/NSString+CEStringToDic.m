//
//  NSString+CEStringToDic.m
//  CloudEducation
//
//  Created by 张君泽 on 16/9/7.
//  Copyright © 2016年 AngelDawn. All rights reserved.
//

#import "NSString+CEStringToDic.h"

@implementation NSString (CEStringToDic)
+ (NSDictionary *)dictionaryFromString:(NSString *)string{
    if (!string) return nil;
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
//        CJLog(@"字典解析失败:%@",error);
        return nil;
    }
    return Dic;
}
+ (NSArray *)arrayFromString:(NSString *)string{
    if (!string) return nil;
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
//        CJLog(@"字典解析失败:%@",error);
        return nil;
    }
    return array;

}
+ (NSString *)timeWithTimeString:(double)string{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//GMT  UTC
//    formatter.timeZone = [NSTimeZone localTimeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    yyyy/MM/dd HH:mm
    [formatter setDateFormat:@"yyyy/MM/dd"];
    float time = string + 8*60*60*1000;
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time/ 1000.0];
//    CJLog(@"%@",date);
    
    
    //设置源日期时区 ===>时间偏移有问题  没用
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
   
    
    
    NSString* dateString = [formatter stringFromDate:date];
//    CJLog(@"%@",dateString);
    //获取当前时间
//    NSDate *nowDate = [NSDate new];
//    NSTimeInterval timeInterVal = [nowDate timeIntervalSinceDate:date];
//    CJLog(@"时间间隔:%.0f",timeInterVal);
//    if (timeInterVal/(60*60*24) < 1) {
//        return @"今天";
//    }else if (timeInterVal/(2 *60 *60*24) < 2){
//        return @"昨天";
//    }
    return dateString;
//    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
//    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
//    [formatter1 setTimeStyle:NSDateFormatterShortStyle];
//    [formatter1 setDateFormat:@"yyyyMMddHHMMss"];
//    NSDate *date1 = [formatter dateFromString:@"1283376197"];
//    NSLog(@"date1:%@",date1);
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:1296035591];
//    NSLog(@"1296035591  = %@",confromTimesp);
//    CJLog(@"%.0f",string);
//    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
//    CJLog(@"confromTimespStr =  %@",confromTimespStr);
//    NSString *timeString = [NSString stringWithFormat:@"%@",date];
//    CJLog(@"%@",timeString);
//    return timeString;
    return nil;
}
+ (CGFloat)heightWithString:(NSString *)string font:(CGFloat)font width:(CGFloat)width{
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGRect rect = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height + 20;
}
@end
