//
//  NSString+NullConfig.m
//  CleenTestDeml
//
//  Created by 王迪 on 2017/9/10.
//  Copyright © 2017年 wd. All rights reserved.
//

#import <UIKit/UIKit.h>

/** @brief 自定义cell需要实现的方法 */
@interface UITableViewCell ()

- (CGFloat)ch_heightForModel:(id)model;

/**
 在计算cell高度时会被调用
 
 @param model 计算cell高度需要的model
 @param tableView cell所在的tableView
 */
- (void)ch_calModel:(id)model atTableView:(UITableView *)tableView;

/**
 在给cell赋值时会被调用
 
 @param model 给cell赋值的model
 @param tableView cell所在的tableView
 */
- (void)ch_setModel:(id)model atTableView:(UITableView *)tableView;

@end
