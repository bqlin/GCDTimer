//
//  BqTimer.h
//  BqTimer
//
//  Created by LinBq on 16/12/23.
//  Copyright © 2016年 POLYV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BqTimer : NSObject

/**
 *  快速创建倒计时对象
 *
 *  注意：回调在主队列中同步执行
 *
 *  @param second     倒计时长
 *  @param countBlock 倒数执行回调
 *
 *  @return BqTimer 对象
 */
+ (instancetype)countdownWithSecond:(long)second countBlock:(void (^)(long remainSecond))countBlock;

/**
 *  快速创建每秒操作定时器对象
 *
 *  注意：
 *
 *  1. 回调在全局并发队列中执行；
 *
 *  2. 调用者必须持有该对象，其生命周期随持有者；
 *
 *  @param repeatBlock 每秒回调
 *
 *  @return BqTimer 对象
 */
+ (instancetype)repeatWithBlock:(void (^)())repeatBlock;

/**
 *  快速创建自定义定时器
 *
 *  @param interval   执行时间间隔
 *  @param queue      执行队列，若为空则在全局异步队列中执行
 *  @param second     执行时长
 *  @param countBlock 执行回调
 *
 *  @return BqTimer 对象
 */
+ (instancetype)timerWithInterval:(double)interval dispatchQueue:(dispatch_queue_t)queue countdownSecond:(long)second countBlock:(void (^)(long remainSecond))countBlock;


/**
 *  初始化为倒计时对象
 *
 *  注意：回调在主队列中同步执行
 *
 *  @param second     倒计时长
 *  @param countBlock 倒数执行回调
 *
 *  @return BqTimer 对象
 */
- (instancetype)initWithSecond:(long)second countBlock:(void (^)(long remainSecond))countBlock;

/**
 *  初始化为每秒操作定时器对象
 *
 *  注意：
 *
 *  1. 回调在全局并发队列中执行；
 *
 *  2. 调用者必须持有该对象，其生命周期随持有者；
 *
 *  @param repeatBlock 每秒回调
 *
 *  @return BqTimer 对象
 */
- (instancetype)initWithRepeatBlock:(void (^)())repeatBlock;

/**
 *  初始化为自定义定时器
 *
 *  @param interval   执行时间间隔
 *  @param queue      执行队列
 *  @param second     执行时长
 *  @param countBlock 执行回调
 *
 *  @return BqTimer 对象
 */
- (instancetype)initWithInterval:(double)interval dispatchQueue:(dispatch_queue_t)queue countdownSecond:(long)second countBlock:(void (^)(long remainSecond))countBlock;

/**
 *  取消定时器及其操作
 */
- (void)cancel;


@end
