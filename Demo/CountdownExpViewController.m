//
//  CountdownExpViewController.m
//  GCDTimerDemo
//
//  Created by Bq on 2018/11/21.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "CountdownExpViewController.h"
#import "GCDTimer.h"

@interface CountdownExpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *countdownTextField;
@property (weak, nonatomic) IBOutlet UITextField *intervalTextField;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) GCDTimer *countdownTimer;

@end

@implementation CountdownExpViewController

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
    [_countdownTimer cancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)startAction:(UIBarButtonItem *)sender {
    // 获取倒计时、间隔
    NSTimeInterval countdownTime = _countdownTextField.text.doubleValue;
    NSTimeInterval countdownInterval = _intervalTextField.text.doubleValue;
    if (countdownInterval <= .0) {
        countdownInterval = 1.0;
    }
    _countdownTextField.text = @(countdownTime).description;
    _intervalTextField.text = @(countdownInterval).description;
    
    // 创建倒计时对象
    GCDTimer *countdownTimer = [[GCDTimer alloc] initWithDispatchQueue:nil];
    countdownTimer.enableSelfRetain = YES;
    _countdownTimer = countdownTimer;
    countdownTimer.timerInterval = countdownInterval;
    __weak typeof(self) weakSelf = self;
    [countdownTimer countdownWithTime:countdownTime countdownHandler:^(GCDTimer *timer) {
        weakSelf.countLabel.text = @(timer.currentTime).description;
    } fire:YES];
    
//    // 创建使用默认间隔 1s 的自引用倒计时对象，不对其定时器对象进行强引用，则定时器对象在定时器归零时自动销毁
//    __weak typeof(self) weakSelf = self;
//    [GCDTimer countdownWithTime:countdownTime interval:countdownInterval countdownHandler:^(GCDTimer *timer) {
//        weakSelf.countLabel.text = @(timer.currentTime).description;
//    }];
}
- (IBAction)stopAction:(UIBarButtonItem *)sender {
    [_countdownTimer cancel];
    _countLabel.text = @"停止";
}

@end
