//
//  GCDTimer.m
//  GCDTimer
//
//  Created by LinBq on 16/12/23.
//  Copyright © 2016年 POLYV. All rights reserved.
//

#import "GCDTimer.h"

static const double kDefaultLeewayInSeconds = .0;
static const double kDefaultIntervalInSeconds = 1.0;

@interface GCDTimer ()

/// GCD 计时器
@property (nonatomic, strong, readonly) dispatch_source_t timer;

@property (nonatomic, weak) GCDTimerCallbackBlock callbackHandler;

@end

@implementation GCDTimer

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithDispatchQueue:(dispatch_queue_t)dispatchQueue {
    if (self = [super init]) {
        [self commonInit];
        _timer = [self.class createTimerWithDispatchQueue:dispatchQueue];
        [self.class setupTimer:_timer interval:_timerInterval leeway:_timerLeeway];
    }
    return self;
}

- (void)commonInit {
    _timerLeeway = kDefaultLeewayInSeconds;
    _timerInterval = kDefaultIntervalInSeconds;
}

#pragma mark count down

- (void)countdownWithTime:(NSTimeInterval)countdownInSeconds countdownHandler:(GCDTimerCallbackBlock)countdownHandler fire:(BOOL)fire {
    if (!_timer) return;
    if (!countdownHandler) return;
    
    _currentTime = countdownInSeconds;
    __weak typeof(self) weakSelf = self;
    void (^actionHandler)(void) = _enableSelfRetain ? ^(){
        [self _countdownActionHandler:countdownHandler];
    } : ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf _countdownActionHandler:countdownHandler];
    };
    _callbackHandler = countdownHandler;
    
    [self.class setupTimer:_timer actionHandler:actionHandler];
    if (fire) [self fire];
}

- (void)_countdownActionHandler:(GCDTimerCallbackBlock)countdownHandler {
    _currentTime -= _timerInterval;
    if (countdownHandler) countdownHandler(self);
    if (_currentTime <= 0) [self cancel];
}

#pragma mark - repeat

- (void)repeatWithActionHandler:(GCDTimerCallbackBlock)repeatActionHandler fire:(BOOL)fire {
    if (!_timer) return;
    if (!repeatActionHandler) return;
    
    _currentTime = .0;
    __weak typeof(self) weakSelf = self;
    void (^actionHandler)(void) = _enableSelfRetain ? ^(){
        [self _repeatActionHandler:repeatActionHandler];
    } : ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf _repeatActionHandler:repeatActionHandler];
    };
    _callbackHandler = repeatActionHandler;
    
    [self.class setupTimer:_timer actionHandler:actionHandler];
    if (fire) [self fire];
}

- (void)_repeatActionHandler:(GCDTimerCallbackBlock)repeatActionHandler {
    _currentTime += _timerInterval;
    if (repeatActionHandler) repeatActionHandler(self);
}

#pragma mark - delay

- (void)delayWithTime:(NSTimeInterval)delayInSeconds actionHandler:(GCDTimerCallbackBlock)delayActionHandler {
    if (!_timer) return;
    if (!delayActionHandler) return;
    
    _currentTime = delayInSeconds;
    __weak typeof(self) weakSelf = self;
    void (^actionHandler)(void) = _enableSelfRetain ? ^(){
        [self _delayActionHandler:delayActionHandler];
    } : ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf _delayActionHandler:delayActionHandler];
    };
    _callbackHandler = delayActionHandler;
    
    [self.class setupTimer:_timer actionHandler:actionHandler];
    [self fire];
}

- (void)_delayActionHandler:(void (^)(GCDTimer *timer))actionHandler {
    _currentTime -= _timerInterval;
    if (_currentTime <= 0) {
        // !!!: 可能存在顺序问题
        [self cancel];
        if (actionHandler) actionHandler(self);
    }
}

// -------------------------------------------------------------------------------------

//- (void)createTimerWithInterval:(double)intervalInSeconds leeway:(double)leewayInSeconds dispatchQueue:(dispatch_queue_t)dispatchQueue actionHandler:(void (^)(void))actionHandler fire:(BOOL)fire {
//    _timerLeeway = leewayInSeconds;
//    _timerInterval = intervalInSeconds;
//    if (!dispatchQueue) dispatchQueue = dispatch_get_main_queue();
//
//    _timer = [self.class createTimerWithDispatchQueue:dispatchQueue];
//    [self.class setupTimer:_timer interval:_timerInterval leeway:_timerLeeway];
//    [self.class setupTimer:_timer actionHandler:actionHandler];
//    if (fire) [self fire];
//}
//
//- (void)createCountdownTimerWithTime:(NSTimeInterval)countdownTime interval:(double)intervalInSeconds dispatchQueue:(dispatch_queue_t)dispatchQueue countdownHandler:(void (^)(GCDTimer *timer))countdownHandler fire:(BOOL)fire {
//    if (!countdownHandler) return;
//
//    _currentTime = countdownTime;
//
//    __weak typeof(self) weakSelf = self;
//    void (^actionHandler)(void) = _enableSelfRetain ? ^(){
//        [self _countdownActionHandler:countdownHandler];
//    } : ^(){
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        [strongSelf _countdownActionHandler:countdownHandler];
//    };
//
//    [self createTimerWithInterval:intervalInSeconds leeway:kDefaultLeewayInSeconds dispatchQueue:dispatchQueue actionHandler:actionHandler fire:fire];
//}
//
//- (void)countdownWithSecond:(long)second countBlock:(void (^)(long remainSecond))countBlock {
//    __block long remainSecond = second;
//    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    __weak typeof(self) weakSelf = self;
//    [self createTimerWithInterval:kDefaultIntervalInSeconds leeway:kDefaultLeewayInSeconds dispatchQueue:globalQueue actionHandler:^{
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        if (remainSecond <= 0) [strongSelf cancel];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            countBlock(remainSecond);
//        });
//        remainSecond --;
//    } fire:YES];
//}
//
//- (void)timerWithInterval:(double)interval dispatchQueue:(dispatch_queue_t)queue countdownSecond:(long)second countBlock:(void (^)(long remainSecond))countBlock {
//    __block long remainSecond = second;
//    if (!queue) queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    __weak typeof(self) weakSelf = self;
//    [self createTimerWithInterval:interval leeway:kDefaultLeewayInSeconds dispatchQueue:queue actionHandler:^{
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        if (remainSecond <= 0) [strongSelf cancel];
//        countBlock(remainSecond);
//        remainSecond --;
//    } fire:YES];
//}

#pragma mark - util

+ (dispatch_source_t)createTimerWithDispatchQueue:(dispatch_queue_t)dispatchQueue {
    if (!dispatchQueue) dispatchQueue = dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatchQueue);
    return timer;
}

+ (void)setupTimer:(dispatch_source_t)timer interval:(double)intervalInSeconds leeway:(double)leewayInSeconds {
    if (!timer) return;
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, intervalInSeconds * NSEC_PER_SEC), intervalInSeconds * NSEC_PER_SEC, leewayInSeconds * NSEC_PER_SEC);
}

+ (void)setupTimer:(dispatch_source_t)timer actionHandler:(void (^)(void))actionHandler {
    if (!timer) return;
    dispatch_source_set_event_handler(timer, actionHandler);
}

+ (void)resumeTimer:(dispatch_source_t)timer {
    if (!timer) return;
    dispatch_resume(timer);
}

#pragma mark - public

#pragma mark property

- (void)setTimerInterval:(NSTimeInterval)timerInterval {
    _timerInterval = timerInterval;
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, _timerInterval * NSEC_PER_SEC), _timerInterval * NSEC_PER_SEC, _timerLeeway * NSEC_PER_SEC);
}

- (void)setTimerLeeway:(NSTimeInterval)timerLeeway {
    _timerLeeway = timerLeeway;
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, _timerInterval * NSEC_PER_SEC), _timerInterval * NSEC_PER_SEC, _timerLeeway * NSEC_PER_SEC);
}

#pragma mark timer operation

- (void)fire {
    if (!_timer) return;
    if (_running) return;
    
    if (_callbackHandler) _callbackHandler(self);
    [self.class resumeTimer:_timer];
    _running = YES;
    NSLog(@"%s", __FUNCTION__);
}

- (void)cancel {
    if (!_timer) return;
    dispatch_source_cancel(_timer);
    _timer = nil;
}

#pragma mark convenience

+ (instancetype)countdownWithTime:(NSTimeInterval)countdownInSeconds countdownHandler:(GCDTimerCallbackBlock)countdownHandler {
    GCDTimer *timer = [[self alloc] initWithDispatchQueue:nil];
    timer.enableSelfRetain = YES;
    [timer countdownWithTime:countdownInSeconds countdownHandler:countdownHandler fire:YES];
    return timer;
}

+ (instancetype)repeatWithActionHandler:(GCDTimerCallbackBlock)repeatActionHandler {
    GCDTimer *timer = [[self alloc] initWithDispatchQueue:nil];
    timer.enableSelfRetain = YES;
    [timer repeatWithActionHandler:repeatActionHandler fire:YES];
    return timer;
}

@end

@implementation GCDTimer (Public)

@end
