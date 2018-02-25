//
//  AppDelegate.m
//  CleenTestDeml
//
//  Created by 王迪 on 2018/2/24.
//  Copyright © 2018年 王迪. All rights reserved.
//

#import "ZZBaseModel.h"
#import <YYKit.h>

@implementation ZZBaseModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init]; return [self modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self modelCopy];
}

- (NSUInteger)hash
{
    return [self modelHash];
}

- (BOOL)isEqual:(id)object
{
    return [self modelIsEqual:object];
}

- (NSString *)description
{
    return [self modelDescription];
}

+ (nullable id)modelWithDicInfo:(_Nullable id)dicInfo
{
    return [self tt_modelWithDicInfo:dicInfo];
}



@end
