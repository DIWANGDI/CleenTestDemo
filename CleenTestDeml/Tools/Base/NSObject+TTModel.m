//
//  AppDelegate.m
//  CleenTestDeml
//
//  Created by 王迪 on 2018/2/24.
//  Copyright © 2018年 王迪. All rights reserved.
//

#import "NSObject+TTModel.h"
#import <YYKit/NSObject+YYModel.h>

@implementation NSObject (TTModel)

+ (id)tt_modelWithDicInfo:(id)dicInfo
{
    if (![dicInfo isKindOfClass:[NSArray class]]) {
        return [self modelWithJSON:dicInfo];
    }
    else {
        return [NSArray modelArrayWithClass:[self class] json:dicInfo];
    }
}

@end
