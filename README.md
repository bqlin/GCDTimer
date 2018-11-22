# GCDTimer

高效易用安全的 GCD 定时器。

对 `dispatch_source_t` 的 GCD 定时器进行 Objective-C 接口封装。实现以下功能：

定时器操作：

- 创建定时器，指定执行队列；
- 配置定时器执行间隔；
- 配置定时器执行精度；
- 是否开启子引用；
- 立即启动定时器；
- 取消定时器；
- 创建倒计时定时器；
- 创建重复定时器；

便利方法：

- 创建自引用倒计时定时器；
- 创建自引用重复定时器；

状态获取：

- 定时器任务是否运行；
- 定时器是否可用；
- 定时器累计时间；

状态回调：

- 取消状态回调；

## 示例代码

#### 自引用倒计时

```objective-c
// 倒计时 5s，间隔 1s
[GCDTimer countdownWithTime:5 interval:1 countdownHandler:^(GCDTimer *timer) {
    NSLog(@"timer countdown: %@", @(timer.currentTime));
}];
```

使用上述 `+countdownWithTime:interval:countdownHandler:` 方法或开启 `enableSelfRetain` 自引用属性时，GCDTimer 对象会在内部自引用，直到倒计时小于等于 0 时，自动销毁。

---

#### 重复任务定时器

```objective-c
// 每隔 1s 重复执行
GCDTimer *repeatTimer = [GCDTimer repeatWithInterval:1 actionHandler:^(GCDTimer *timer) {
    NSLog(@"timer time: %@", @(timer.currentTime));
}];
_repeatTimer = repeatTimer;
...
// 在特定时机或在页面 `-dealloc` 方法内执行 `-cancel` 方法
[_repeatTimer cancel];
```

同上，使用上述 `+repeatWithInterval:actionHandler:` 方法或开启 `enableSelfRetain` 自引用属性时，GCDTimer 对象会在内部自引用。要销毁或停止定时器则需要主动调用 `-cancel` 方法。

---

> 注意：
>
> 若不使用自引用功能时，需要对创建的 `GCDTimer` 进行强引用（作为强引用属性什么的），否则会在作用域超出时被系统自动销毁。

P.S. 若有更多定时器的应用场景欢迎 issue 我，说不定我能加个接口~