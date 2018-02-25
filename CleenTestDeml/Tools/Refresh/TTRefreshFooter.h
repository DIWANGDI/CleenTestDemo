//
//  NSString+NullConfig.m
//  CleenTestDeml
//
//  Created by 王迪 on 2017/5/26.
//  Copyright © 2017年 wd. All rights reserved.
//

#import "MJRefreshAutoFooter.h"
#import "TTRefreshFooterProtocol.h"

@interface TTRefreshFooter : MJRefreshAutoFooter<TTRefreshFooterProtocol>

@property (nonatomic, strong) UILabel* stateLabel;
@property (nonatomic, strong) UIImageView* gifImgView;

- (void)endRefreshStateTitle:(NSString*)stateTitle;
- (void)noMoreDataWithTitle:(NSString*)footTitle;

@end
