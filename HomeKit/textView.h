//
//  textView.h
//  HomeKit
//
//  Created by 张君泽 on 16/9/19.
//  Copyright © 2016年 CloudEducation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface textView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lab1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lab1Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lab12;

@property (nonatomic, copy)NSString *lab1Str;
@property (weak, nonatomic) IBOutlet UILabel *lab1;

+ (textView *)shareTextView;
@end
