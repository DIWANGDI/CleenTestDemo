//
//  CleenDataModel.h
//  CleenTestDeml
//
//  Created by 王迪 on 2018/2/24.
//  Copyright © 2018年 王迪. All rights reserved.
//

#import "ZZBaseModel.h"

/** @brief 服务器下发数据模型 */
@interface CleenDataModel : ZZBaseModel

/** @brief 标题 */
@property (nonatomic ,copy) NSString * title;

/** @brief 内容 */
@property (nonatomic ,copy) NSString * descript;

/** @brief 图片URL */
@property (nonatomic ,copy) NSString * imageHref;

/** @brief 图片的Size */
@property (nonatomic, assign) CGSize imageSize;

@end
