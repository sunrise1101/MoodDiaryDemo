//
//  MoodSelectView.h
//  MoodDiaryDemo
//
//  Created by 邓旭东 on 2017/12/27.
//  Copyright © 2017年 邓旭东. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoodSelectViewDelegate <NSObject>

- (void)selectAtIndex:(NSInteger) index;

@end

@interface MoodSelectView : UIView

@property (nonatomic, weak) id <MoodSelectViewDelegate>delegate;

@end
