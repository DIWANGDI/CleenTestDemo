//
//  NSString+NullConfig.m
//  CleenTestDeml
//
//  Created by 王迪 on 2017/5/26.
//  Copyright © 2017年 wd. All rights reserved.
//
#import "UIScrollView+TTRefresh.h"
#import <objc/runtime.h>

static Class<TTRefreshHeaderProtocol> s_defaultRefreshHeaderClass = nil;
static Class<TTRefreshFooterProtocol> s_defaultRefreshFooterClass = nil;

@interface UIScrollView ()

@property (nonatomic, retain) UIView* xtt_tmpHeaderAccessoryView;

@end

@implementation UIScrollView (TTRefresh)

- (void)setTt_refreshDelegate:(id<XTTScrollViewRefreshDelegate>)tt_refreshDelegate
{
    objc_setAssociatedObject(self, @selector(tt_refreshDelegate), tt_refreshDelegate, OBJC_ASSOCIATION_ASSIGN);
    
    self.tt_enablePullingRefresh = [tt_refreshDelegate respondsToSelector:@selector(pullRefreshInScrollView:)];
    self.tt_enableLoadingMore = [tt_refreshDelegate respondsToSelector:@selector(loadingMoreInScrollView:)];
}

- (id<XTTScrollViewRefreshDelegate>)tt_refreshDelegate
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTt_enablePullingRefresh:(BOOL)tt_enablePullingRefresh
{
    if (tt_enablePullingRefresh) {
        if (!self.mj_header) {
            if ([self.tt_refreshDelegate respondsToSelector:@selector(refreshHeaderInScrollView:)]) {
                self.mj_header = [self.tt_refreshDelegate refreshHeaderInScrollView:self];
            }
            
            Class headerClass = [UIScrollView ttr_defaultHeaderClass];
            self.mj_header = self.mj_header ? self.mj_header: [[headerClass alloc] init];
            typeof(self) __weak ws = self;
            self.mj_header.refreshingBlock = ^{
                if ([ws.tt_refreshDelegate respondsToSelector:@selector(pullRefreshInScrollView:)]) {
                    [ws.tt_refreshDelegate pullRefreshInScrollView:ws];
                }
            };
        }
    }
    else {
        self.mj_header = nil;
    }
}

- (BOOL)tt_enablePullingRefresh
{
    return self.mj_header != nil;
}

- (void)setTt_enableLoadingMore:(BOOL)tt_enableLoadingMore
{
    if (tt_enableLoadingMore) {
        if (!self.mj_footer) {
            if ([self.tt_refreshDelegate respondsToSelector:@selector(refreshFooterInScrollView:)]) {
                self.mj_footer = [self.tt_refreshDelegate refreshFooterInScrollView:self];
            }
            
            Class footerClass = [UIScrollView ttr_defaultFooterClass];
            self.mj_footer = self.mj_footer ? self.mj_footer: [[footerClass alloc] init];
            __weak typeof(self) ws = self;
            self.mj_footer.refreshingBlock = ^{
                if ([ws.tt_refreshDelegate respondsToSelector:@selector(loadingMoreInScrollView:)]) {
                    [ws.tt_refreshDelegate loadingMoreInScrollView:ws];
                }
            };
        }
    }
    else {
        self.mj_footer = nil;
    }
}

- (BOOL)tt_enableLoadingMore
{
    return self.mj_footer != nil;
}

- (MJRefreshHeader<TTRefreshHeaderProtocol> *)tt_refreshHeader
{
    return (MJRefreshHeader<TTRefreshHeaderProtocol> *)self.mj_header;
}

- (MJRefreshAutoFooter<TTRefreshFooterProtocol> *)tt_refreshFooter
{
    return (MJRefreshAutoFooter<TTRefreshFooterProtocol> *)self.mj_footer;
}

- (BOOL)tt_hasNoMoreData
{
    return (self.tt_refreshFooter.state == MJRefreshStateNoMoreData || !self.tt_enableLoadingMore);
}

- (void)xtt_beginPullingRefresh
{
    [self.tt_refreshHeader beginRefreshing];
}

- (void)xtt_endPullingRefreshState:(TTEndRefreshState)endRefreshState
{
    [self.tt_refreshHeader endRefreshState:endRefreshState];
}

- (void)xtt_endPullingRefreshStateTitle:(NSString *)stateTitle
{
    [self.tt_refreshHeader endRefreshStateTitle:stateTitle];
}
    
- (void)xtt_beginLoadingMore
{
    [self.tt_refreshFooter beginRefreshing];
}

- (void)xtt_endLodingMoreStateTitle:(NSString *)stateTitle
{
    [self.tt_refreshFooter endRefreshStateTitle:stateTitle];
}

- (void)xtt_noMoreDataWithTitle:(NSString*)footTitle
{
    [self.tt_refreshFooter noMoreDataWithTitle:footTitle];
}

- (void)xtt_endPullingWithAccessoryView:(UIView *)accessoryView endState:(TTEndRefreshState)endRefreshState
{
    self.xtt_tmpHeaderAccessoryView = accessoryView;
    if (self.mj_insetT > 0.1 && accessoryView && accessoryView.frame.size.height > 0.1) {
        
        [self xtt_showAccessoryViewFinishBlock:^{
            [self.tt_refreshHeader endRefreshState:endRefreshState];
            [self xtt_hideAccessoryViewDelay:0.1];
        }];
    }
    else {
        [self.tt_refreshHeader endRefreshState:endRefreshState];
    }
}

// // // // // // // // // // // // // // // // // // // // // // // // // // //
// // // // // // // // // // // // // // // // // // // // // // // // // // //
// // // // // // // // // // // // // // // // // // // // // // // // // // //
- (void)xtt_showAccessoryViewFinishBlock:(void(^)(void))finishBlock
{
    UIView* accessoryView = self.xtt_tmpHeaderAccessoryView;
    
    CGRect selfConvertFrame = [self convertRect:self.bounds toView:self.superview];
    CGRect accessoryFrame = accessoryView.frame;
    accessoryFrame.origin = selfConvertFrame.origin;
    accessoryView.frame = accessoryFrame;
    [self.superview addSubview:accessoryView];
    accessoryView.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mj_insetT = accessoryView.frame.size.height;
    }];
    
    UILabel* textLbl = [self xtt_labelWithTextOfAccessoryView:accessoryView];
    if (textLbl) {
        textLbl.transform = CGAffineTransformMakeScale(0.6, 0.6);
        [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            accessoryView.alpha = 1;
            textLbl.transform = CGAffineTransformIdentity;
        } completion:nil];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (finishBlock) {
            finishBlock();
        }
    });
}

- (void)xtt_hideAccessoryViewDelay:(NSTimeInterval)delay
{
    UIView* accessoryView = self.xtt_tmpHeaderAccessoryView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.12 animations:^{
            accessoryView.alpha = 0;
        } completion:^(BOOL finished) {
            [accessoryView removeFromSuperview];
        }];
    });
}

- (UILabel*)xtt_labelWithTextOfAccessoryView:(UIView*)ofView
{
    for (UILabel* lbl in ofView.subviews) {
        if ([lbl isKindOfClass:[UILabel class]] && lbl.text.length > 0) {
            return lbl;
        }
        else {
            return [self xtt_labelWithTextOfAccessoryView:lbl];
        }
    }
    return nil;
}

- (void)setXtt_tmpHeaderAccessoryView:(UIView *)xtt_tmpHeaderAccessoryView
{
    objc_setAssociatedObject(self, @selector(xtt_tmpHeaderAccessoryView), xtt_tmpHeaderAccessoryView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)xtt_tmpHeaderAccessoryView
{
    return objc_getAssociatedObject(self, _cmd);
}

// // // // // // // // // // // // // // // // // // // // // // // // // // //
// // // // // // // // // // // // // // // // // // // // // // // // // // //
// // // // // // // // // // // // // // // // // // // // // // // // // // //

#pragma mark - - get default header or footer
+ (Class<TTRefreshHeaderProtocol>)ttr_defaultHeaderClass
{
    if (s_defaultRefreshHeaderClass) {
        return s_defaultRefreshHeaderClass;
    }
    return [TTRefreshHeader class];
}

+ (Class<TTRefreshFooterProtocol>)ttr_defaultFooterClass
{
    if (s_defaultRefreshFooterClass) {
        return s_defaultRefreshFooterClass;
    }
    return [TTRefreshFooter class];
}

#pragma mark - - config default refresh header or footer
+ (void)xtt_configDefaultRefreshHeaderClass:(Class)headerClass
{
    if ([headerClass conformsToProtocol:@protocol(TTRefreshHeaderProtocol)] && [headerClass isSubclassOfClass:[MJRefreshHeader class]]) {
        s_defaultRefreshHeaderClass = headerClass;
    }
    else {
        NSLog(@"you config the error header class: <%@> !!! ", headerClass);
    }
}

+ (void)xtt_configDefaultRefreshFooterClass:(Class)footerClass
{
    if ([footerClass conformsToProtocol:@protocol(TTRefreshFooterProtocol)] && [footerClass isSubclassOfClass:[MJRefreshAutoFooter class]]) {
        s_defaultRefreshFooterClass = footerClass;
    }
    else {
        NSLog(@"you config the error footer: <%@> !!!", footerClass);
    }
}

@end
