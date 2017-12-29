//
//  MoodSelectView.m
//  MoodDiaryDemo
//
//  Created by 邓旭东 on 2017/12/27.
//  Copyright © 2017年 邓旭东. All rights reserved.
//

#import "MoodSelectView.h"

#define MOODSELECTITEM_WIDTH (dxd_autoResize(44))

@interface MoodSelectItemView : UIView

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *moodLabel;
@end

@implementation MoodSelectItemView

- (instancetype)init {
    if (self = [super init]) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews {
    [self addSubview:self.iconImageView];
    [self addSubview:self.moodLabel];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(0);
        make.top.offset(0);
        make.size.mas_equalTo(CGSizeMake(MOODSELECTITEM_WIDTH, MOODSELECTITEM_WIDTH));
    }];
    
    [self.moodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(0);
        make.size.mas_equalTo(CGSizeMake(MOODSELECTITEM_WIDTH, dxd_autoResize(15)));
        make.bottom.equalTo(self);
    }];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)moodLabel {
    if (!_moodLabel) {
        _moodLabel = [[UILabel alloc] init];
        _moodLabel.textColor = [UIColor pb_colorWithHexString:c_warmGrey];
        _moodLabel.font = [UIFont systemFontOfSize:15];
        _moodLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moodLabel;
}

@end

@interface MoodSelectView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *itemViewArray;

@end

@implementation MoodSelectView

- (instancetype)init {
    if (self = [super init]) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.containerView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.offset(dxd_autoResize(35));
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(dxd_autoResize(80));
        make.leading.trailing.offset(0);
        make.height.mas_equalTo(dxd_autoResize(74));
    }];
    
    NSArray *titleArr = @[@"飞天",@"很好",@"一般",@"好累",@"想哭"];
    NSArray *imageArr = @[@"ic_level1_b",@"ic_level2_b",@"ic_level3_b",@"ic_level4_b",@"ic_level5_b"];
    
    
    for (int i = 0; i < titleArr.count; i++) {
        MoodSelectItemView *itemView = [[MoodSelectItemView alloc] init];
        itemView.userInteractionEnabled = YES;
        itemView.iconImageView.image = [UIImage imageNamed:imageArr[i]];
        itemView.moodLabel.text = titleArr[i];
        itemView.tag = i;
        [self.itemViewArray addObject:itemView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAtIndex:)];
        [itemView addGestureRecognizer:tap];
    }
    [self makeEqualWidthViews:self.itemViewArray inView:self.containerView LRpadding:dxd_autoResize(21) viewPadding:dxd_autoResize(16)];
}

- (void)selectAtIndex:(UIGestureRecognizer *)gesture
{
    MoodSelectItemView *itemView = (MoodSelectItemView *)gesture.view;
    if (_delegate && [_delegate respondsToSelector:@selector(selectAtIndex:)]) {
        [_delegate selectAtIndex:itemView.tag];
    }
}

/**
 *  将若干view等宽布局于容器containerView中
 *
 *  @param views         viewArray
 *  @param containerView 容器view
 *  @param LRpadding     距容器的左右边距
 *  @param viewPadding   各view的左右边距
 */
-(void)makeEqualWidthViews:(NSArray *)views inView:(UIView *)containerView LRpadding:(CGFloat)LRpadding viewPadding :(CGFloat)viewPadding {
    UIView *lastView;
    for (UIView *view in views) {
        [containerView addSubview:view];
        if (lastView) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(containerView);
                make.left.equalTo(lastView.mas_right).offset(viewPadding);
                make.width.equalTo(lastView);
            }];
        }else
        {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(containerView).offset(LRpadding);
                make.top.bottom.equalTo(containerView);
                make.width.mas_equalTo(MOODSELECTITEM_WIDTH);
            }];
        }
        lastView = view;
    }
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

- (NSMutableArray *)itemViewArray {
    if (!_itemViewArray) {
        _itemViewArray = [[NSMutableArray alloc] init];
    }
    return _itemViewArray;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

@end
