//
//  MoodDiaryViewModel.m
//  MoodDiaryDemo
//
//  Created by 邓旭东 on 2017/12/28.
//  Copyright © 2017年 邓旭东. All rights reserved.
//

#import "MoodDiaryViewModel.h"

@implementation MoodDiaryViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self dxd_initialize];
    }
    return self;
}

- (void)dxd_initialize {
    [self.MoodDiarySelectCommand.executionSignals.switchToLatest subscribeNext:^void (id input) {
        [self.MoodDiarySelectedSubject sendNext:input];
    }];
}

- (RACSubject *)MoodDiaryClickSubject {
    if (!_MoodDiaryClickSubject) {
        _MoodDiaryClickSubject = [[RACSubject alloc] init];
    }
    return _MoodDiaryClickSubject;
}

- (RACSubject *)MoodDiarySelectedSubject {
    if (!_MoodDiarySelectedSubject) {
        _MoodDiarySelectedSubject = [[RACSubject alloc] init];
    }
    return _MoodDiarySelectedSubject;
}

- (RACCommand *)MoodDiarySelectCommand {
    if (!_MoodDiarySelectCommand) {
        SignalBlock signalBlock = ^RACSignal *(id input) {
            DisposableBlock disposableBlock = ^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                return nil;
            };
            RACSignal* signal = [RACSignal createSignal:disposableBlock];
            return signal;
        };
        _MoodDiarySelectCommand = [[RACCommand alloc] initWithSignalBlock:signalBlock];
    }
    return _MoodDiarySelectCommand;
}

@end
