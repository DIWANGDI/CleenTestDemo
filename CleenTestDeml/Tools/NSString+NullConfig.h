//
//  NSString+NullConfig.h
//  CleenTestDeml
//
//  Created by 王迪 on 2018/2/24.
//  Copyright © 2018年 王迪. All rights reserved.
//

#import <Foundation/Foundation.h>

/** @brief 字符串为空的判断 */
NSString* configEmptyToStr(id rawObj, NSString* toStr);

NSString* configEmpty(id rawObj);

@interface NSString (NullConfig)

@end
