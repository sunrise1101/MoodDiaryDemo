//
//  MoodDiaryHeaderView.m
//  MoodDiaryDemo
//
//  Created by 邓旭东 on 2017/12/26.
//  Copyright © 2017年 邓旭东. All rights reserved.
//

#import "MoodDiaryHeaderView.h"

@implementation MoodDiaryHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UILabel *moodTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((MOODDIARYHEADERVIEW_WIDTH-dxd_autoResize(100))/2, dxd_autoResize(20), dxd_autoResize(100), dxd_autoResize(20))];
        moodTitleLabel.textAlignment = NSTextAlignmentCenter;
        moodTitleLabel.textColor = [UIColor whiteColor];
        moodTitleLabel.font = PBSysFont(dxd_autoResize(18.f));
        moodTitleLabel.text = @"心情日记";
        [self addSubview:moodTitleLabel];
        
        NSArray *weekArray = [[NSArray alloc] initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
        for (int i=0; i<weekArray.count; i++) {
            UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*MOODDIARYHEADERVIEW_WIDTH/7, dxd_autoResize(67), MOODDIARYHEADERVIEW_WIDTH/7, dxd_autoResize(20))];
            weekLabel.textAlignment = NSTextAlignmentCenter;
            weekLabel.textColor = [UIColor whiteColor];
            weekLabel.font = PBSysFont(dxd_autoResize(12.f));
            weekLabel.text = weekArray[i];
            [self addSubview:weekLabel];
        }
        
    }
    return self;
}

@end
