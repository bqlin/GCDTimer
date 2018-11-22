//
//  RepeatExpViewController.m
//  GCDTimerDemo
//
//  Created by Bq on 2018/11/21.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "RepeatExpViewController.h"
#import "GCDTimer.h"

@interface RepeatExpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *intervalTextField;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) GCDTimer *repeatTimer;

@end

@implementation RepeatExpViewController

- (void)dealloc {
    [_repeatTimer cancel];
    NSLog(@"%s", __FUNCTION__);
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
    // 获取执行间隔
    NSTimeInterval repeatInterval = _intervalTextField.text.doubleValue;
    if (repeatInterval <= .0) {
        repeatInterval = 1.0;
    }
    _intervalTextField.text = @(repeatInterval).description;
    
    // 创建重复定时器对象
    GCDTimer *repeatTimer = [[GCDTimer alloc] initWithDispatchQueue:nil];
    _repeatTimer = repeatTimer;
    repeatTimer.timerInterval = repeatInterval;
    __weak typeof(self) weakSelf = self;
    [repeatTimer repeatWithActionHandler:^(GCDTimer *timer) {
        weakSelf.countLabel.text = @(timer.currentTime).description;
    } fire:YES];
    
    // 便捷创建自引用重复定时器对象，必须对该对象引用主动销毁（调用 -cancel），否则不会自动销毁
    _repeatTimer = [GCDTimer repeatWithInterval:repeatInterval actionHandler:^(GCDTimer *timer) {
        weakSelf.countLabel.text = @(timer.currentTime).description;
    }];
}
- (IBAction)stopAction:(UIBarButtonItem *)sender {
    [_repeatTimer cancel];
    _countLabel.text = @"停止";
}

@end
