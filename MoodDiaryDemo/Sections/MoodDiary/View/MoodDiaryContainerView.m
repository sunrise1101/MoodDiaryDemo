//
//  MoodDiaryContainerView.m
//  MoodDiaryDemo
//
//  Created by 邓旭东 on 2017/12/26.
//  Copyright © 2017年 邓旭东. All rights reserved.
//

#import "MoodDiaryContainerView.h"

@implementation MoodDiaryContainerView

//设置渐变背景色
- (void)drawRect:(CGRect)rect {
    
    /**
     *  1.通过CAGradientLayer 设置渐变的背景。
     */
    CAGradientLayer *layer = [CAGradientLayer new];
    //colors存放渐变的颜色的数组
    layer.colors = @[(__bridge id)[UIColor pb_colorWithHexString:c_tealish].CGColor, (__bridge id)[UIColor pb_colorWithHexString:c_weirdGreen].CGColor];
    /**
     * 起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
     */
    layer.startPoint = CGPointMake(0, 1);
    layer.endPoint = CGPointMake(1, 0);
    layer.frame = self.bounds;
    [self.layer insertSublayer:layer atIndex:0];
}

@end
