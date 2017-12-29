//
//  MoodDiaryModel.h
//  MoodDiaryDemo
//
//  Created by 邓旭东 on 2017/12/28.
//  Copyright © 2017年 邓旭东. All rights reserved.
//

#import <Foundation/Foundation.h>

//1 心情最好 > 2 >3 >4 >5
typedef enum : NSUInteger {
    MoodLevel1 = 1,
    MoodLevel2 = 2,
    MoodLevel3 = 3,
    MoodLevel4 = 4,
    MoodLevel5 = 5,
} MoodLevel;

@interface MoodDiaryModel : NSObject

@property (nonatomic, assign) NSInteger dayValue;
@property (nonatomic, strong) NSDate *dateValue;
@property (nonatomic, assign) MoodLevel moodLevel;
@property (nonatomic, assign) BOOL isSelectedDay;

@end
