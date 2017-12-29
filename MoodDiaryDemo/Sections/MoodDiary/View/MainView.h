//
//  MainView.h
//  MoodDiaryDemo
//
//  Created by 邓旭东 on 2017/12/28.
//  Copyright © 2017年 邓旭东. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoodDiaryViewModel;

@interface MainView : UIView

- (instancetype)initWithViewModel:(MoodDiaryViewModel *)viewModel;

@end
