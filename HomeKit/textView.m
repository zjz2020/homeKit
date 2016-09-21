//
//  textView.m
//  HomeKit
//
//  Created by 张君泽 on 16/9/19.
//  Copyright © 2016年 CloudEducation. All rights reserved.
//

#import "textView.h"
#import "NSString+CEStringToDic.h"
@implementation textView
+ (textView *)shareTextView{

    textView *textv = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    return textv;
}
- (void)setLab1Str:(NSString *)lab1Str{
    _lab1Str = lab1Str;
        _lab1.text = lab1Str;
    _lab1.numberOfLines = 0;
        CGFloat height = [NSString heightWithString:lab1Str font:17 width:170];
        _lab1Height.constant = height;
//    NSLog(@"%.0f",height);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
