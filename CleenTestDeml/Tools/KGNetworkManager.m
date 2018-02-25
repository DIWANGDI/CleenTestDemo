//
//  CleenDataModel.m
//  CleenTestDeml
//
//  Created by 王迪 on 2018/2/24.
//  Copyright © 2018年 王迪. All rights reserved.
//

#import "KGNetworkManager.h"
#import "Reachability.h"

//请求超时
#define TIMEOUT 30

typedef enum {
    NetWorkType_None = 0,//无网络
    NetWorkType_WIFI,    //wifi
    NetWorkType_2_3G,    //2G或者3G网络
} NetWorkType;

@implementation KGNetworkManager

+ (instancetype)sharedInstance {
    static KGNetworkManager *networkManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[self alloc] init];
    });
    
    return networkManager;
}

-(AFHTTPSessionManager *)baseHtppRequest
{
    AFHTTPSessionManager *manage=[AFHTTPSessionManager manager];
    [manage.requestSerializer setTimeoutInterval:TIMEOUT];
    return manage;
}

- (void)GetActionWithSuccess:(void(^)(id data))success
        fail:(void(^)(id err))fail
{
    NetWorkType status = [self networkType];
    if (status == NetWorkType_None)
    {
        fail(@"请检查你的网络连接");
        return;
    }
    AFHTTPSessionManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [kNetBaseURLString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        fail(error);
    }];
}


#pragma mark - 网络检测

-(NetWorkType) networkType {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if (NO == [reachability isReachable]) {
        return NetWorkType_None;
    }
    
    if ([reachability isReachableViaWiFi]) {
        return NetWorkType_WIFI;
    }
    
    if ([reachability isReachableViaWWAN]) {
        return NetWorkType_2_3G;
    }
    
    return NetWorkType_2_3G;
}
@end
