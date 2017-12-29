//
//  PBDateHelper.h
//  MoodDiaryDemo
//
//  Created by 邓旭东 on 2017/12/28.
//  Copyright © 2017年 邓旭东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBDateHelper : NSObject

+ (NSUInteger)numberOfDaysInMonth:(NSDate *)date;
+ (NSUInteger)startDayOfWeek:(NSDate *)date;
+ (NSDate *)firstDateOfMonth:(NSDate *)date;
+ (NSDate *)dateOfDay:(NSInteger)day fromDate:(NSDate *)date;
+ (NSDate *)getLastMonth:(NSDate *)date;
+ (NSDate *)getNextMonth:(NSDate *)date;

@end
