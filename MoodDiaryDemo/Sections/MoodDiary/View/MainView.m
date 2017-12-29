//
//  MainView.m
//  MoodDiaryDemo
//
//  Created by 邓旭东 on 2017/12/28.
//  Copyright © 2017年 邓旭东. All rights reserved.
//

#import "MainView.h"
#import "MoodDiaryViewModel.h"

@interface MainView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *moodImageView;

@end

@implementation MainView

- (instancetype)initWithViewModel:(MoodDiaryViewModel *)viewModel {
    if (self = [super init]) {
        [self setupViews];
        [self bindViewModel:viewModel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            [viewModel.MoodDiaryClickSubject sendNext:nil];
        }];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)bindViewModel:(MoodDiaryViewModel *)viewModel {
    @weakify(self);
    [viewModel.MoodDiarySelectedSubject subscribeNext:^(id x) {
        @strongify(self);
        NSInteger index = [x integerValue];
        [self setAvatarImage:index];
    }];
}

- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.moodImageView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma mark - system
-(void)updateConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(dxd_autoResize(35));
    }];
    
    [self.moodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(dxd_autoResize(30));
        make.size.mas_equalTo(CGSizeMake(dxd_autoResize(60), dxd_autoResize(60)));
    }];
    
    [super updateConstraints];
}

-(void)setAvatarImage:(NSInteger)index {
    NSArray *imageArr = @[@"ic_level1_b",@"ic_level2_b",@"ic_level3_b",@"ic_level4_b",@"ic_level5_b"];
    self.moodImageView.image = [UIImage imageNamed:imageArr[index]];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor pb_colorWithHexString:c_brownishGrey];
        _titleLabel.font = PBSysFont(dxd_autoResize(15));
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"选择您的心情";
    }
    return _titleLabel;
}

- (UIImageView *)moodImageView {
    if (!_moodImageView) {
        _moodImageView = [[UIImageView alloc] init];
        _moodImageView.image = [UIImage imageNamed:@"ic_add_mood"];
        
        NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:[@"MoodDiaryViewController" cachePath]];
        if (dic.count > 0) {
            NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            NSDateComponents *comps = [greCalendar
                                       components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                       fromDate:[NSDate date]];
            //此处date为key，格式为2017-1-1 00:00:00 整时整分整秒
            NSDate *date = [greCalendar dateFromComponents:comps];
            
            NSInteger index = [dic[date] integerValue];
            if (index >= 1) {
                [self setAvatarImage:index - 1];
            }
            else {
                _moodImageView.image = [UIImage imageNamed:@"ic_add_mood"];
            }
        }
        else {
            _moodImageView.image = [UIImage imageNamed:@"ic_add_mood"];
        }
    }
    return _moodImageView;
}


@end
