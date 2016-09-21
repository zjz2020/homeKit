//
//  NSString+CEStringToDic.h
//  CloudEducation
//
//  Created by 张君泽 on 16/9/7.
//  Copyright © 2016年 AngelDawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (CEStringToDic)
+ (NSDictionary *)dictionaryFromString:(NSString *)string;
+ (NSArray *)arrayFromString:(NSString *)string;
///将时间戳转换为标准时间
+ (NSString *)timeWithTimeString:(double)string;
///根据内容返回lable高度
+ (CGFloat)heightWithString:(NSString *)string font:(CGFloat)font width:(CGFloat)width;
@end
