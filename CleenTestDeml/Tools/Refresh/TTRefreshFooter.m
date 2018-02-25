//
//  NSString+NullConfig.m
//  CleenTestDeml
//
//  Created by 王迪 on 2017/5/26.
//  Copyright © 2017年 wd. All rights reserved.
//
#import "TTRefreshFooter.h"

@interface TTRefreshFooter()

@property (nonatomic, strong) UIView* stateContentView;

@end

@implementation TTRefreshFooter

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 设置自己的高度
    self.mj_h = MJRefreshFooterHeight+10;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    [self.stateLabel sizeToFit];
    CGRect contentFrame = self.stateContentView.frame;
    CGRect lblFrame = self.stateLabel.frame;
    lblFrame.origin.x = 0;
    lblFrame.origin.y = (contentFrame.size.height - lblFrame.size.height) / 2.0;
    self.stateLabel.frame = lblFrame;
    
    CGRect imgFrame = self.gifImgView.frame;
    imgFrame.origin.x = CGRectGetMaxX(lblFrame) + 10.0f;
    imgFrame.origin.y = (contentFrame.size.height - imgFrame.size.height) / 2.0;
    self.gifImgView.frame = imgFrame;
    
    contentFrame.size.width = CGRectGetMaxX(imgFrame);
    contentFrame.origin.x = (self.mj_w-contentFrame.size.width) / 2.0;
    contentFrame.origin.y = (self.mj_h-contentFrame.size.height) / 2.0;
    
    self.stateContentView.frame = contentFrame;
}

- (void)beginRefreshing
{
    [super beginRefreshing];
    self.stateLabel.text = @"正在努力加载";
    [self startRotateAnimation];
}

- (void)endRefreshStateTitle:(NSString *)stateTitle
{
    [super endRefreshing];
    self.stateLabel.text = stateTitle ? stateTitle : @"上拉加载更多";
    [self stopRotateAnimation];
}

- (void)noMoreDataWithTitle:(NSString *)footTitle
{
    self.state = MJRefreshStateNoMoreData;
    self.stateLabel.text = footTitle ? footTitle : @"没有更多数据";
    [self stopRotateAnimation];
}

#define kRotateLayer  @"rotate-animation-layer"
- (void)startRotateAnimation
{
    self.gifImgView.mj_w = 12;
    [self layoutIfNeeded];
    CABasicAnimation* rotateAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAni.fromValue = @(0);
    rotateAni.toValue = @(2*M_PI);
    rotateAni.repeatCount = MAXFLOAT;
    rotateAni.duration = 0.8;
    [self.gifImgView.layer addAnimation:rotateAni forKey:kRotateLayer];
}

- (void)stopRotateAnimation
{
    self.gifImgView.mj_w = 0;
    [self layoutIfNeeded];
    [self.gifImgView.layer removeAnimationForKey:kRotateLayer];
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        _stateLabel.text = @"上拉加载更多";
        _stateLabel.backgroundColor = [UIColor clearColor];
        _stateLabel.font = [UIFont systemFontOfSize:12];
        _stateLabel.textColor = [UIColor colorWithRed:0x50/255.0 green:0x50/255.0 blue:0x50/255.0 alpha:1.0];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.backgroundColor = [UIColor clearColor];
    }
    return _stateLabel;
}

- (UIImageView *)gifImgView
{
    if (!_gifImgView) {
        _gifImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
        _gifImgView.backgroundColor = [UIColor clearColor];
        _gifImgView.image = [UIImage imageNamed:@"refresh_loading.png"];
    }
    return _gifImgView;
}

- (UIView *)stateContentView
{
    if (!_stateContentView) {
        _stateContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        _stateContentView.backgroundColor = [UIColor clearColor];
        [_stateContentView addSubview:self.stateLabel];
        [_stateContentView addSubview:self.gifImgView];
        [self addSubview:_stateContentView];
    }
    return _stateContentView;
}

@end
