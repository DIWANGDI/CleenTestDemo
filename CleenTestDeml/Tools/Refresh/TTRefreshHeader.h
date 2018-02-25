//
//  NSString+NullConfig.m
//  CleenTestDeml
//
//  Created by 王迪 on 2017/5/26.
//  Copyright © 2017年 wd. All rights reserved.
//

#import "MJRefreshHeader.h"
#import "TTRefreshHeaderProtocol.h"

@interface TTRefreshHeader : MJRefreshHeader<TTRefreshHeaderProtocol>

@property (nonatomic, strong) UIImageView* gifImageView;
@property (nonatomic, strong) UILabel* stateLabel;

@property (nonatomic, copy) NSString* refreshingStateTitle;
@property (nonatomic, copy) NSString* pullingStateTitle;

- (void)setStateTitle:(NSString*)stateTitle forEndRefreshState:(TTEndRefreshState)endRefreshState;

- (void)endRefreshState:(TTEndRefreshState)endRefreshState;

@end
