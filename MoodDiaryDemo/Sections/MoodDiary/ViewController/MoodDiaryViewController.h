//
//  MoodDiaryViewController.h
//  MoodDiaryDemo
//
//  Created by 邓旭东 on 2017/12/25.
//  Copyright © 2017年 邓旭东. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoodDiaryViewModel;

@interface MoodDiaryViewController : UIViewController

- (instancetype)initWithViewModel:(MoodDiaryViewModel *)viewModel;

@end
