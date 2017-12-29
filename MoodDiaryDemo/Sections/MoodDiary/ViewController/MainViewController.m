//
//  MainViewController.m
//  MoodDiaryDemo
//
//  Created by 邓旭东 on 2017/12/25.
//  Copyright © 2017年 邓旭东. All rights reserved.
//

#import "MainViewController.h"
#import "MoodDiaryViewController.h"
#import "MoodDiaryViewModel.h"
#import "MainView.h"

@interface MainViewController ()

@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) MoodDiaryViewModel *viewModel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self bindViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor randomColor];
    [self.view addSubview:self.mainView];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)bindViewModel {
    @weakify(self);
    [[self.viewModel.MoodDiaryClickSubject takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(id x) {
         @strongify(self);
         MoodDiaryViewController *vc = [[MoodDiaryViewController alloc] initWithViewModel:self.viewModel];
         [self.navigationController addChildViewController:vc];
         [vc didMoveToParentViewController:self.navigationController];
         [self.navigationController.view addSubview:vc.view];
     }];
}

#pragma mark - system
-(void)updateViewConstraints {    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.leading.offset(dxd_autoResize(50));
        make.trailing.offset(dxd_autoResize(-50));
        make.height.mas_equalTo(dxd_autoResize(200));
    }];
    [super updateViewConstraints];
}

- (MainView *)mainView {
    if (!_mainView) {
        _mainView = [[MainView alloc] initWithViewModel:self.viewModel];
        _mainView.layer.cornerRadius = dxd_autoResize(10);
        _mainView.layer.masksToBounds = YES;
    }
    return _mainView;
}

- (MoodDiaryViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MoodDiaryViewModel alloc] init];
    }
    return _viewModel;
}

@end
