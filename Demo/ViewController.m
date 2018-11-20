//
//  ViewController.m
//  GCDTimer
//
//  Created by LinBq on 16/12/24.
//  Copyright © 2016年 POLYV. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+Bq.h"
#import "GCDTimer.h"

@interface ViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (nonatomic, assign) long countSecend;

@property (nonatomic, strong) GCDTimer *countdown;

@end

@implementation ViewController

- (void)dealloc{
	NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setupUI];
}

- (void)setupUI{
	self.pickView.dataSource = self;
	self.pickView.delegate = self;
	
	[self.activityIndicator stopAnimating];
	
	UIButton *backBtn = self.backButton;
	[backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismiss{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	self.countSecend = 10;
	[self.pickView reloadComponent:0];
	[self.activityIndicator startAnimating];
	// 有结束点的定时器不需要被持有
	[GCDTimer countdownWithSecond:self.countSecend countBlock:^(long remainSecond) {
		NSLog(@"剩余时间 %lds", remainSecond);
		[self.pickView selectRow:remainSecond - 1 inComponent:0 animated:YES];;
		if (remainSecond < 1){
			NSLog(@"毕");
			[self.activityIndicator stopAnimating];
		}
	}];
}

- (IBAction)startTimer:(id)sender {
	__block long i = 0;
	// 没有结束点的定时器一定要被持有
	// 且当该控制器生命周期结束，定时器也将被销毁
	self.countdown = [GCDTimer repeatWithBlock:^{
		NSLog(@"%02ld", i);
		i++;
	}];
}
- (IBAction)stopTimer:(id)sender {
	[self.countdown cancel];
	self.countdown = nil;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return self.countSecend;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	return [NSString stringWithFormat:@"%ld", row];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
