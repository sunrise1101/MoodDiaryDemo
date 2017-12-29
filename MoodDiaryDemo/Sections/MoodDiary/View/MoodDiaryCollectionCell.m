//
//  MoodDiaryCollectionCell.m
//  MoodDiaryDemo
//
//  Created by 邓旭东 on 2017/12/26.
//  Copyright © 2017年 邓旭东. All rights reserved.
//

#import "MoodDiaryCollectionCell.h"

@interface MoodDiaryCollectionCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *dayLabel;

@end

@implementation MoodDiaryCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.dayLabel];
        [self.contentView addSubview:self.iconView];
        
        [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.centerX.offset(0);
            make.size.mas_equalTo(CGSizeMake(dxd_autoResize(20), dxd_autoResize(20)));
        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dayLabel.mas_bottom);
            make.centerX.offset(0);
            make.size.mas_equalTo(CGSizeMake(dxd_autoResize(26), dxd_autoResize(26)));
        }];
    }
    return self;
}

-(void)setModel:(MoodDiaryModel *)model {
    _model = model;
    if (![_model isKindOfClass:[MoodDiaryModel class]]) {
        self.dayLabel.text = @"";
        self.iconView.image = nil;
    }
    else
    {
        self.dayLabel.text = [NSString stringWithFormat:@"%ld",model.dayValue];
        switch (_model.moodLevel) {
            case MoodLevel1:
                self.iconView.image = [UIImage imageNamed:@"ic_level1_s"];
                break;
            case MoodLevel2:
                self.iconView.image = [UIImage imageNamed:@"ic_level2_s"];
                break;
            case MoodLevel3:
                self.iconView.image = [UIImage imageNamed:@"ic_level3_s"];
                break;
            case MoodLevel4:
                self.iconView.image = [UIImage imageNamed:@"ic_level4_s"];
                break;
            case MoodLevel5:
                self.iconView.image = [UIImage imageNamed:@"ic_level5_s"];
                break;
            default:
                self.iconView.image = nil;
                break;
        }
    }
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textColor = [UIColor whiteColor];
        _dayLabel.font = PBSysFont(dxd_autoResize(12));
        _dayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dayLabel;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

@end
