//
//  MoodDiaryViewController.m
//  MoodDiaryDemo
//
//  Created by 邓旭东 on 2017/12/25.
//  Copyright © 2017年 邓旭东. All rights reserved.
//

#import "MoodDiaryViewController.h"
#import "MoodDiaryContainerView.h"
#import "MoodDiaryHeaderView.h"
#import "MoodDiaryCollectionCell.h"
#import "MoodSelectView.h"
#import "MoodDiaryViewModel.h"
#import "PBDateHelper.h"

@interface MoodDiaryViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, MoodSelectViewDelegate>

@property (nonatomic, strong) MoodDiaryContainerView *containerView;
@property (nonatomic, strong) UIButton *xButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) MoodSelectView *selectView;
@property (nonatomic, strong) MoodDiaryViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *dayModelMArray;
@property (nonatomic, strong) NSMutableDictionary *localDic;
@property (nonatomic, assign) BOOL isFullShow;

@end

@implementation MoodDiaryViewController

- (instancetype)initWithViewModel:(MoodDiaryViewModel *)viewModel {
    if (self = [super init]) {
        self.viewModel = viewModel;
        self.isFullShow = NO;
        [self setupViews];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupViews {
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    @weakify(self);
    [tapGes.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        [self removeSelf];
    }];
    tapGes.delegate = self;
    [self.view addGestureRecognizer:tapGes];
    self.view.backgroundColor = [UIColor pb_colorWithHexString:c_dark Alpha:0.8];
    
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.xButton];
    [self.containerView addSubview:self.collectionView];
    [self.containerView addSubview:self.selectView];
    [self.containerView addSubview:self.arrowButton];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        self.containerView.transform = CGAffineTransformIdentity;
        self.xButton.hidden = NO;
    }];
}

#pragma mark - system
-(void)updateViewConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(dxd_autoResize(25));
        make.trailing.offset(dxd_autoResize(-25));
        make.centerY.offset(0);
        make.height.mas_equalTo(dxd_autoResize(390));
    }];
    
    [self.xButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_trailing);
        make.centerY.equalTo(self.containerView.mas_top);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.offset(0);
        make.height.mas_equalTo(dxd_autoResize(178)).priority(MASLayoutPriorityDefaultMedium);
    }];
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.leading.trailing.offset(0);
        make.height.mas_equalTo(dxd_autoResize(212));
    }];
    
    [self.arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.collectionView);
        make.bottom.equalTo(self.collectionView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(dxd_autoResize(30), dxd_autoResize(30)));
    }];
    
    [super updateViewConstraints];
}

#pragma mark - lazy load
- (MoodDiaryContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[MoodDiaryContainerView alloc] init];
        _containerView.layer.cornerRadius = dxd_autoResize(10.0f);
        _containerView.layer.masksToBounds = YES;
        _containerView.transform = CGAffineTransformMakeScale(0, 0);
    }
    return _containerView;
}

- (MoodSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[MoodSelectView alloc] init];
        _selectView.delegate = self;
    }
    return _selectView;
}

- (UIButton *)arrowButton {
    if (!_arrowButton) {
        _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowButton setImage:[UIImage imageNamed:@"ic_push_m"] forState:UIControlStateNormal];
        [_arrowButton setImage:[UIImage imageNamed:@"ic_pull_m"] forState:UIControlStateSelected];
        [_arrowButton addTarget:self action:@selector(decideWhetherFullShow:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowButton;
}

- (UIButton *) xButton {
    if (!_xButton) {
        _xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xButton setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
        _xButton.hidden = YES;
        @weakify(self);
        [[_xButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self removeSelf];
        }];
    }
    return _xButton;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(MOODDIARYHEADERVIEW_WIDTH/7, dxd_autoResize(44));
        flowLayout.headerReferenceSize = CGSizeMake(MOODDIARYHEADERVIEW_WIDTH, MOODDIARYHEADERVIEW_HEIGHT);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[MoodDiaryCollectionCell class] forCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([MoodDiaryCollectionCell class])] ];
        
        [_collectionView registerClass:[MoodDiaryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([MoodDiaryHeaderView class])]];
    }
    return _collectionView;
}

- (NSMutableDictionary *)localDic {
    if (!_localDic) {
        _localDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:[PBClassName cachePath]];
        if (dic.count > 0) {
            [_localDic setValuesForKeysWithDictionary:dic];
        }
    }
    return _localDic;
}

#pragma mark - collectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dayModelMArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MoodDiaryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([MoodDiaryCollectionCell class])] forIndexPath:indexPath];
    cell.model = self.dayModelMArray[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    MoodDiaryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([MoodDiaryHeaderView class])] forIndexPath:indexPath];
    return headerView;
}

- (void)removeSelf {
    [UIView animateWithDuration:0.3f animations:^{
        self.xButton.hidden = YES;
        self.containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([self.view isDescendantOfView:touch.view]) {
        return YES;
    }
    return NO;
}

- (void)decideWhetherFullShow:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.isFullShow = !self.isFullShow;
}

#pragma mark - Select Item Delegate
- (void)selectAtIndex:(NSInteger)index {
//    NSLog(@"func:%s,line:%d \n value:%ld\n",__func__,__LINE__,index);
    for (MoodDiaryModel *model in self.dayModelMArray) {
        if (![model isKindOfClass:[MoodDiaryModel class]]) {
            continue;
        }

        if (model.isSelectedDay) {
            model.moodLevel = index+1;
            [self.viewModel.MoodDiarySelectCommand execute:@(index)];
            //归档
            [self.localDic setObject:@(model.moodLevel) forKey:model.dateValue];
            [NSKeyedArchiver archiveRootObject:self.localDic toFile:[PBClassName cachePath]];
            break;
        }
    }
    
    [self.collectionView reloadData];
}

-(void)setIsFullShow:(BOOL)isFullShow {
    _isFullShow = isFullShow;
    self.dayModelMArray = [[NSMutableArray alloc] initWithCapacity:42];
    if (_isFullShow) {
        NSDate *date = [NSDate date];
        NSUInteger days = [PBDateHelper numberOfDaysInMonth:date];
        NSInteger week = [PBDateHelper startDayOfWeek:date];
        int day = 1;
        for (int i = 1; i < days+week; i++) {
            if (i < week) {
                [self.dayModelMArray addObject:@""];
            }
            else {
                MoodDiaryModel *model = [[MoodDiaryModel alloc] init];
                model.dayValue = day;
                NSDate *dayDate = [PBDateHelper dateOfDay:day fromDate:[NSDate date]];
                model.dateValue = dayDate;
                model.moodLevel = [[self.localDic objectForKey:model.dateValue] integerValue];
                if ([dayDate.yyyyMMddByLineWithDate isEqualToString:[NSDate date].yyyyMMddByLineWithDate]) {
                    model.isSelectedDay = YES;
                }
                [self.dayModelMArray addObject:model];
                day++;
            }
        }
    }
    else {
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday fromDate:nowDate];
        // 获取今天是周几
        NSInteger weekDay = [comp weekday];
        // 获取几天是几号
        NSInteger day = [comp day];
        // 计算当前日期和本周的星期天相差天数
        long diff = [calendar firstWeekday] - weekDay;
        
        NSUInteger days = [PBDateHelper numberOfDaysInMonth:nowDate];
        
        for (int i = 0; i < 7; i++) {
            
            if (day + diff + i > days || day + diff + i < 1) {
                [self.dayModelMArray addObject:@""];
            }
            else {
                MoodDiaryModel *model = [[MoodDiaryModel alloc] init];
                model.dayValue = day + diff + i;
                NSDate *dayDate = [PBDateHelper dateOfDay:model.dayValue fromDate:[NSDate date]];
                model.dateValue = dayDate;
                model.moodLevel = [[self.localDic objectForKey:model.dateValue] integerValue];
                if ([dayDate.yyyyMMddByLineWithDate isEqualToString:[NSDate date].yyyyMMddByLineWithDate]) {
                    model.isSelectedDay = YES;
                }
                [self.dayModelMArray addObject:model];
            }
        }
    }
    
    [self.collectionView reloadData];
    
    if (_isFullShow) {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(dxd_autoResize(390));
        }];
    }
    else {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(dxd_autoResize(178));
        }];
    }
}

@end
