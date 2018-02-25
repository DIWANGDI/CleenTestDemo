//
//  NSString+NullConfig.m
//  CleenTestDeml
//
//  Created by 王迪 on 2017/5/26.
//  Copyright © 2017年 wd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTRefreshFooterProtocol <NSObject>

@required
- (void)endRefreshStateTitle:(NSString*)stateTitle;
- (void)noMoreDataWithTitle:(NSString*)footTitle;

@end
