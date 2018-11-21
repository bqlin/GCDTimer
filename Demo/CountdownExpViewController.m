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
    NSTimeInterval countdownTime = _countdownTextField.text.doubleValue;
    NSTimeInterval countdownInterval = _intervalTextField.text.doubleValue;
    if (countdownInterval <= .0) {
        countdownInterval = 1.0;
    }
    _countdownTextField.text = @(countdownTime).description;
    _intervalTextField.text = @(countdownInterval).description;
    
//    GCDTimer *countdownTimer = [[GCDTimer alloc] initWithDispatchQueue:nil];
//    countdownTimer.enableSelfRetain = YES;
//    _countdownTimer = countdownTimer;
//    countdownTimer.timerInterval = countdownInterval;
//    __weak typeof(self) weakSelf = self;
//    [countdownTimer countdownWithTime:countdownTime countdownHandler:^(GCDTimer *timer) {
//        weakSelf.countLabel.text = @(timer.currentTime).description;
//    } fire:YES];
    
    __weak typeof(self) weakSelf = self;
    [GCDTimer countdownWithTime:countdownTime countdownHandler:^(GCDTimer *timer) {
        weakSelf.countLabel.text = @(timer.currentTime).description;
    }];
}
- (IBAction)stopAction:(UIBarButtonItem *)sender {
    [_countdownTimer cancel];
    _countLabel.text = @"停止";
}

@end
