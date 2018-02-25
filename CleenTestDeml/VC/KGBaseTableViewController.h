//
//  AppDelegate.m
//  CleenTestDeml
//
//  Created by 王迪 on 2018/2/24.
//  Copyright © 2018年 王迪. All rights reserved.
//

#import "UIScrollView+TTRefresh.h"
#import "KGBaseViewController.h"

@interface KGBaseTableViewController : KGBaseViewController 

@property (nonatomic,strong) UITableView        *tableView;

/** @brief 分割线是否填充满 */
@property (nonatomic,assign) BOOL               separatorFull;

/** @brief Tableview接受数据的数组 */
@property (nonatomic,strong)NSMutableArray      *arrayDataItems;

/** @brief 翻页时候当前页数，默认第一页为0 */
@property (nonatomic,assign) NSInteger          currentPageIndex;

/**
 设置Tableview样式
 @param style Tableview样式
 @return Tableview对象
 */
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style;

@end

@interface KGBaseTableViewController(can_be_override)<XTTScrollViewRefreshDelegate>
@end
