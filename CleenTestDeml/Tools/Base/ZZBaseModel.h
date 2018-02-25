//
//  AppDelegate.m
//  CleenTestDeml
//
//  Created by 王迪 on 2018/2/24.
//  Copyright © 2018年 王迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+TTModel.h"


@interface ZZBaseModel : NSObject<NSCoding, NSCopying>

+ (nullable id)modelWithDicInfo:(_Nullable id)dicInfo;

@end
