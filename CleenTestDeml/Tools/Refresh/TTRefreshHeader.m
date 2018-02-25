//
//  NSString+NullConfig.m
//  CleenTestDeml
//
//  Created by 王迪 on 2017/5/26.
//  Copyright © 2017年 wd. All rights reserved.
//

#import "TTRefreshHeader.h"

@interface TTRefreshHeader()

@property (nonatomic, strong) NSMutableDictionary* stateTitleMap;

@end

@implementation TTRefreshHeader
{
    BOOL isRefreshEnding; // 刷新完毕正在结束的状态
    TTEndRefreshState currentEndRefreshState;
    
    CFTimeInterval gifPausedTime;
}

- (void)setStateTitle:(NSString *)stateTitle forEndRefreshState:(TTEndRefreshState)endRefreshState
{
    stateTitle = [stateTitle isKindOfClass:[NSString class]] ? stateTitle : @"";
    [self.stateTitleMap setObject:stateTitle forKey:@(endRefreshState)];
}

- (void)prepare
{
    [super prepare];
    
    currentEndRefreshState = TTEndRefreshState_Initial;
    // 自定义高度
    self.mj_h = MJRefreshHeaderHeight + 20;
    self.backgroundColor = [UIColor clearColor];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    CGRect gifFrame = self.gifImageView.frame;
    gifFrame.size = CGSizeMake(26, 26);
    gifFrame.origin.x = (self.mj_w - self.gifImageView.mj_w) / 2;
    gifFrame.origin.y = (self.mj_h - self.gifImageView.mj_h) / 2 - 5;
    self.gifImageView.frame = gifFrame;
    
    CGPoint stateCenter = self.stateLabel.center;
    stateCenter.x = self.gifImageView.center.x;
    stateCenter.y = CGRectGetMaxY(self.gifImageView.frame) + 10;
    self.stateLabel.center = stateCenter;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    if (isRefreshEnding) {
        return;
    }
    
    [self setRotateAnimation];
    if (!self.isRefreshing) {
        [self pauseGifImageViewLayer];
        self.gifImageView.layer.timeOffset = gifPausedTime - self.scrollView.mj_offsetY/120.0;
    }
    else {
        [self resumeGifImageViewLayer];
    }
    
    if (!self.isRefreshing && self.scrollView.mj_offsetY > -10) {
        self.stateLabel.text = [self.stateTitleMap objectForKey:@(currentEndRefreshState)];
    }
}

- (void)setRotateAnimation
{
    NSString *kRotateLayer = @"tt-rotate-animation-layer";
    CABasicAnimation* rotateAni = (CABasicAnimation *)[self.gifImageView.layer animationForKey:kRotateLayer];
    if (!rotateAni) {
        rotateAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAni.fromValue = @(0);
        rotateAni.toValue = @(2*M_PI);
        rotateAni.repeatCount = MAXFLOAT;
        rotateAni.duration = 0.6;
        [self.gifImageView.layer addAnimation:rotateAni forKey:kRotateLayer];
    }
}

- (void)pauseGifImageViewLayer
{
    CALayer *layer = self.gifImageView.layer;
    if (layer.speed < 0.1) {
        return;
    }
    
    gifPausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 让CALayer的时间停止走动
    layer.speed = 0.0;
    // 让CALayer的时间停留在pausedTime这个时刻
    layer.timeOffset = gifPausedTime;
}

- (void)resumeGifImageViewLayer
{
    CALayer *layer = self.gifImageView.layer;
    if (layer.speed > 0.9) {
        return;
    }
    
    CFTimeInterval pausedTime = layer.timeOffset;
    // 1. 让CALayer的时间继续行走
    layer.speed = 1.0;
    // 2. 取消上次记录的停留时刻
    layer.timeOffset = 0.0;
    // 3. 取消上次设置的时间
    layer.beginTime = 0.0;
    // 4. 计算暂停的时间(这里也可以用CACurrentMediaTime()-pausedTime)
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    // 5. 设置相对于父坐标系的开始时间(往后退timeSincePause)
    layer.beginTime = timeSincePause;
}

- (void)setState:(MJRefreshState)state
{
    [super setState:state];
    if (state == MJRefreshStateRefreshing) {
        self.stateLabel.text = self.refreshingStateTitle; //@"刷新中...";
    }
    if (state == MJRefreshStateIdle) {
        self.stateLabel.text = [self.stateTitleMap objectForKey:@(currentEndRefreshState)];
    }
    if (state == MJRefreshStatePulling) {
        self.stateLabel.text = self.pullingStateTitle; //@"松开刷新";
    }
}

- (void)endRefreshState:(TTEndRefreshState)endRefreshState
{
    currentEndRefreshState = endRefreshState;
    isRefreshEnding = YES;
    self.stateLabel.text = [self.stateTitleMap objectForKey:@(currentEndRefreshState)];
    self.window.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [super endRefreshing];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            currentEndRefreshState = TTEndRefreshState_Initial;
            isRefreshEnding = NO;
            self.window.userInteractionEnabled = YES;
        });
    });
}
    
- (void)endRefreshStateTitle:(NSString *)title
{
    currentEndRefreshState = TTEndRefreshState_Custom;
    [self.stateTitleMap setObject:(title.length ? title: @"刷新成功") forKey:@(currentEndRefreshState)];
    [self endRefreshState:currentEndRefreshState];
}

- (void)endRefreshing
{
    [super endRefreshing];
}

#pragma mark - - properties
- (UIImageView *)gifImageView
{
    if (!_gifImageView) {
        _gifImageView = [[UIImageView alloc] init];
        _gifImageView.backgroundColor = [UIColor clearColor];
        _gifImageView.image = [UIImage imageNamed:@"refresh_loading.png"];
        [self addSubview:_gifImageView];
    }
    return _gifImageView;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        _stateLabel.font = [UIFont systemFontOfSize:10];
        _stateLabel.textColor = [UIColor colorWithRed:0x50/255.0 green:0x50/255.0 blue:0x50/255.0 alpha:1.0];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_stateLabel];
    }
    return _stateLabel;
}

- (NSMutableDictionary *)stateTitleMap
{
    if (!_stateTitleMap) {
        _stateTitleMap = [NSMutableDictionary dictionaryWithCapacity:3];
        [_stateTitleMap setObject:@"下拉刷新" forKey:@(TTEndRefreshState_Initial)];
        [_stateTitleMap setObject:@"刷新成功" forKey:@(TTEndRefreshState_Success)];
        [_stateTitleMap setObject:@"刷新失败" forKey:@(TTEndRefreshState_Fail)];
    }
    return _stateTitleMap;
}

- (NSString *)refreshingStateTitle
{
    if (!_refreshingStateTitle) {
        _refreshingStateTitle = @"刷新中...";
    }
    return _refreshingStateTitle;
}

- (NSString *)pullingStateTitle
{
    if (!_pullingStateTitle) {
        _pullingStateTitle = @"松开刷新";
    }
    return _pullingStateTitle;
}

// 重写window的getter方法，解决未刷新完毕跳转并停留在下一个界面，刷新完毕的时候contentInset恢复异常问题。
- (UIWindow *)window
{
    UIWindow* superWindow = [super window];
    if (!superWindow) {
        if (self.pri_xtt_viewController) {
            return [[UIApplication sharedApplication].delegate window];
        }
        else {
            return nil;
        }
    }
    else {
        return superWindow;
    }
}

- (UIViewController *)pri_xtt_viewController
{
    UIResponder* nextResponder = self.nextResponder;
    do {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    } while ((nextResponder = nextResponder.nextResponder));
    return nil;
}

@end
