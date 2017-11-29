//
//  UIViewController+Bq.m
//  BqCountDown
//
//  Created by LinBq on 16/12/23.
//  Copyright © 2016年 POLYV. All rights reserved.
//

#import "UIViewController+Bq.h"

@implementation UIViewController (Bq)

- (void)dealloc{
//	NSLog(@"%s", __FUNCTION__);
}

- (UIButton *)backButton{
	UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
	[backBtn setTitle:@"返回" forState:UIControlStateNormal];
	[self.view addSubview:backBtn];
	[backBtn sizeToFit];
	backBtn.frame = CGRectMake(8, 18, backBtn.bounds.size.width, backBtn.bounds.size.height);
	return backBtn;
}



@end
