//
//  NSString+NullConfig.m
//  CleenTestDeml
//
//  Created by 王迪 on 2018/2/24.
//  Copyright © 2018年 王迪. All rights reserved.
//

#import "NSString+NullConfig.h"

@implementation NSString (NullConfig)

NSString* configEmptyToStr(id rawObj, NSString* toStr)
{
    return (rawObj == nil
            || [rawObj isKindOfClass:[NSNull class]]
            || [rawObj isEqual:@"(null)"]
            || [rawObj isEqual:@"null"]) ? toStr : [NSString stringWithFormat:@"%@", rawObj];
}

NSString* configEmpty(id rawObj)
{
    return configEmptyToStr(rawObj, @"");
}

@end
