//
//  CleenDataModel.m
//  CleenTestDeml
//
//  Created by 王迪 on 2018/2/24.
//  Copyright © 2018年 王迪. All rights reserved.
//

#import <AFHTTPSessionManager.h>

typedef void(^HJMFailureBlock)(NSError *error);
typedef void(^HJMNetWorkSuccessBlock)(id data,id message);

@interface KGNetworkManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

-(AFHTTPSessionManager *)baseHtppRequest;

/**
 Get请求
 @param success 成功回调
 @param fail 失败回调
 */
- (void)GetActionWithSuccess:(void(^)(id data))success
                        fail:(void(^)(id err))fail;

@end
