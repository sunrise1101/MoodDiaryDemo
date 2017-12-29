//
//  MoodDiaryViewModel.h
//  MoodDiaryDemo
//
//  Created by 邓旭东 on 2017/12/28.
//  Copyright © 2017年 邓旭东. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NextBlock)(NSDictionary *);

typedef RACSignal* (^SignalBlock)(id);
typedef RACDisposable* (^DisposableBlock)(id<RACSubscriber>);

@interface MoodDiaryViewModel : NSObject

@property (nonatomic, strong) RACSubject *MoodDiaryClickSubject;
@property (nonatomic, strong) RACCommand *MoodDiarySelectCommand;
@property (nonatomic, strong) RACSubject *MoodDiarySelectedSubject;

@end
