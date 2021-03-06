//
//  UIColor+Expand.h
//  PublishingDemo
//
//  Created by 邓旭东 on 2017/12/20.
//  Copyright © 2017年 邓旭东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Expand)


#define c_warmGrey              @"#999999"
#define c_grapefruit            @"#ff5a54"
#define c_black                 @"#3D3D3D"
#define c_dark                  @"#14191e"
#define c_tealish               @"#32c9d7"
#define c_weirdGreen            @"#5edea6"
#define c_brownishGrey          @"#666666"

/**
 *    @brief    generate color
 *
 *    @param     hexString     eg:#34DE8A
 *
 *    @return    color's instance
 */

+ (UIColor *)pb_colorWithHexString:(NSString *)hexString;

+ (UIColor *)pb_colorWithHexString:(NSString *)hexString Alpha:(CGFloat)alpha;

+ (UIColor*)randomColor;

@end
