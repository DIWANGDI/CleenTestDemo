//
//  NSString+NullConfig.m
//  CleenTestDeml
//
//  Created by 王迪 on 2017/5/26.
//  Copyright © 2017年 wd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "TTRefreshHeaderProtocol.h"
#import "TTRefreshFooterProtocol.h"

#import "TTRefreshHeader.h"
#import "TTRefreshFooter.h"

@protocol XTTScrollViewRefreshDelegate <NSObject>

@optional
- (void)pullRefreshInScrollView:(UIScrollView*)scrollView;
- (void)loadingMoreInScrollView:(UIScrollView*)scrollView;

/** @brief 该方法如果不实现，将默认使用 TTRefreshHeader 类型的header */
- (MJRefreshHeader<TTRefreshHeaderProtocol>*)refreshHeaderInScrollView:(UIScrollView*)scrollView;

/** @brief 该方法如果不实现，将默认使用 TTRefreshFooter 类型的footer */
- (MJRefreshAutoFooter<TTRefreshFooterProtocol>*)refreshFooterInScrollView:(UIScrollView*)scrollView;

@end

@interface UIScrollView (TTRefresh)

@property (nonatomic, assign) id<XTTScrollViewRefreshDelegate> tt_refreshDelegate;

@property (nonatomic, assign) BOOL tt_enablePullingRefresh;
@property (nonatomic, assign) BOOL tt_enableLoadingMore;

/*
 *  只有设置了 tt_refreshDelegate 并实现了 pullRefreshInScrollView: 方法，
 *  或者 tt_enablePullingRefresh=YES，则tt_refreshHeader才不为nil。
 *  如果设置了 tt_refreshDelegate 并实现了 pullRefreshInScrollView: 方法，
 *  但是返回nil，则默认返回 TTRefreshHeader 类型的header。
 */
@property (nonatomic, strong, readonly) MJRefreshHeader<TTRefreshHeaderProtocol>* tt_refreshHeader;

/*
 * 只有设置了 tt_refreshDelegate 并实现了 loadingMoreInScrollView: 方法，
 * 或者 tt_enableLoadingMore=YES，则tt_refreshFooter才不为nil
 * 如果设置了 tt_refreshDelegate 并实现了 loadingMoreInScrollView: 方法，
 * 但是返回nil，则默认返回 TTRefreshFooter 类型的footer。
 */
@property (nonatomic, strong, readonly) MJRefreshAutoFooter<TTRefreshFooterProtocol>* tt_refreshFooter;

@property (nonatomic, readonly) BOOL tt_hasNoMoreData;

/** @brief 下拉刷新 */
- (void)xtt_beginPullingRefresh;

- (void)xtt_endPullingRefreshState:(TTEndRefreshState)endRefreshState;

- (void)xtt_endPullingRefreshStateTitle:(NSString *)title;

/** @brief 上拉加载更多 */
- (void)xtt_beginLoadingMore;

- (void)xtt_endLodingMoreStateTitle:(NSString*)stateTitle;

/** @brief 上拉加载没有更多数据 */
- (void)xtt_noMoreDataWithTitle:(NSString*)footTitle;

- (void)xtt_endPullingWithAccessoryView:(UIView*)accessoryView endState:(TTEndRefreshState)endRefreshState;

+ (void)xtt_configDefaultRefreshHeaderClass:(Class<TTRefreshHeaderProtocol>)headerClass;

+ (void)xtt_configDefaultRefreshFooterClass:(Class<TTRefreshFooterProtocol>)footerClass;


@end

