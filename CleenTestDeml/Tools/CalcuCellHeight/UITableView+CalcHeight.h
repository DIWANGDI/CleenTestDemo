//
//  NSString+NullConfig.m
//  CleenTestDeml
//
//  Created by 王迪 on 2017/9/10.
//  Copyright © 2017年 wd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UITableViewCell_CalcHeight.h"

@interface UITableView (CalcHeight)

- (CGFloat)ch_heightForModel:(NSObject *)model configCellClass:(Class(^)(NSObject *model))configCellClass;

- (UITableViewCell *)ch_cellForModel:(NSObject *)model;

/**
 清除保存在model上的cell高度缓存
 @param model 需要清除cell高度缓存的model
 */
- (void)ch_cleanHeightCacheForModel:(NSObject *)model;

/**
 延时reloadData，防止连续调用造成的显示异常
 
 @param delay 延迟调用reloadData的时间间隔
 */
- (void)ch_delayReloadData:(NSTimeInterval)delay;

@end
