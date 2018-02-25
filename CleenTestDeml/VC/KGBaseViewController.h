//
//  AppDelegate.m
//  CleenTestDeml
//
//  Created by 王迪 on 2018/2/24.
//  Copyright © 2018年 王迪. All rights reserved.
//


#define HEIGHT_YANYAN_NAVIBAR     44.0f
#define HEIGHT_STATUSBAR          ([UIApplication sharedApplication].statusBarFrame.size.height)
#define HEIGHT_YANYAN_TOP         (HEIGHT_YANYAN_NAVIBAR + HEIGHT_STATUSBAR)

@interface KGBaseViewController : UIViewController

/** @brief 导航栏背景view */
@property(nonatomic,strong)UIView       *navBackView;

/** @brief 返回按钮 */
@property(nonatomic,strong)UIButton     *navLetfItem;

/** @brief 导航栏标题 */
@property(nonatomic,strong)UILabel      *navTitleLab;

/** @brief 设置导航栏标题 */
@property(nonatomic,copy)NSString       *navTitle;

@end
