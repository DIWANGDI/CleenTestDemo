//
//  NSString+NullConfig.m
//  CleenTestDeml
//
//  Created by 王迪 on 2017/5/26.
//  Copyright © 2017年 wd. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef enum{
    
    TTEndRefreshState_Initial,
    TTEndRefreshState_Success,
    TTEndRefreshState_Fail,
    
    TTEndRefreshState_Custom,
    
} TTEndRefreshState;

@protocol TTRefreshHeaderProtocol <NSObject>

@required
- (void)endRefreshState:(TTEndRefreshState)endRefreshState;
- (void)endRefreshStateTitle:(NSString *)title;

@end
