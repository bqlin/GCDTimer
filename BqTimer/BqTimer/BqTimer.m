//
//  BqTimer.m
//  BqTimer
//
//  Created by LinBq on 16/12/23.
//  Copyright © 2016年 POLYV. All rights reserved.
//

#import "BqTimer.h"

/// 创建GCD定时器
dispatch_source_t CreateDispatchTimer(double interval, dispatch_queue_t queue, dispatch_block_t block){
	dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
	if (timer){
		dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 1ull / 10 * NSEC_PER_SEC);
		dispatch_source_set_event_handler(timer, block);
		dispatch_resume(timer);
	}
	return timer;
}

@interface BqTimer ()

/// GCD 计时器
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation BqTimer
#pragma mark - dealloc & init
- (void)dealloc{
	NSLog(@"%s", __FUNCTION__);
}


#pragma mark - 外部接口
#pragma mark 倒计时
+ (instancetype)countdownWithSecond:(long)second countBlock:(void (^)(long remainSecond))countBlock{
	return [[self alloc] initWithSecond:second countBlock:countBlock];
}
- (instancetype)initWithSecond:(long)second countBlock:(void (^)(long remainSecond))countBlock{
	if (self = [super init]) {
		[self countdownWithSecond:second countBlock:countBlock];
	}
	return self;
}

#pragma mark 重复操作
+ (instancetype)repeatWithBlock:(void (^)())repeatBlock{
	return [[self alloc] initWithRepeatBlock:repeatBlock];
}
- (instancetype)initWithRepeatBlock:(void (^)())repeatBlock{
	if (self = [super init]) {
		[self repeatWithBlock:repeatBlock];
	}
	return self;
}

#pragma mark 自定义定时器
+ (instancetype)timerWithInterval:(double)interval dispatchQueue:(dispatch_queue_t)queue countdownSecond:(long)second countBlock:(void (^)(long remainSecond))countBlock{
	return [[self alloc] initWithInterval:interval dispatchQueue:queue countdownSecond:second countBlock:countBlock];
}
- (instancetype)initWithInterval:(double)interval dispatchQueue:(dispatch_queue_t)queue countdownSecond:(long)second countBlock:(void (^)(long remainSecond))countBlock{
	if (self = [super init]) {
		[self timerWithInterval:interval dispatchQueue:queue countdownSecond:second countBlock:countBlock];
	}
	return self;
}

#pragma mark - 定时器操作
/// 取消定时器
- (void)cancel{
	if (!_timer) return;
	dispatch_source_cancel(_timer);
	_timer = nil;
}

#pragma mark - 内部方法
/// 初始化
- (instancetype)init{
	if (self = [super init]) {
		
	}
	return self;
}

/// 每秒回调
- (void)repeatWithBlock:(void (^)())repeatBlock{
	dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	self.timer = CreateDispatchTimer(1, globalQueue, repeatBlock);
}

/// 倒计时
- (void)countdownWithSecond:(long)second countBlock:(void (^)(long remainSecond))countBlock{
	__block long remainSecond = second;
	dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	self.timer = CreateDispatchTimer(1, globalQueue, ^{
		if (remainSecond <= 0) [self cancel];
		dispatch_sync(dispatch_get_main_queue(), ^{
			countBlock(remainSecond);
		});
		remainSecond --;
	});
}

/// 自定义定时器
- (void)timerWithInterval:(double)interval dispatchQueue:(dispatch_queue_t)queue countdownSecond:(long)second countBlock:(void (^)(long remainSecond))countBlock{
	__block long remainSecond = second;
	if (!queue) queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	self.timer = CreateDispatchTimer(interval, queue, ^{
		if (remainSecond <= 0) [self cancel];
		countBlock(remainSecond);
		remainSecond --;
	});
}
@end
