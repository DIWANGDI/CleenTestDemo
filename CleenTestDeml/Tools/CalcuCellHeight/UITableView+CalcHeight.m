//
//  NSString+NullConfig.m
//  CleenTestDeml
//
//  Created by 王迪 on 2017/9/10.
//  Copyright © 2017年 wd. All rights reserved.
//

#import "UITableView+CalcHeight.h"
#import <objc/runtime.h>

@interface UITableView ()

@property (nonatomic, strong, readonly) NSMutableDictionary *pri_ch_cellStorage;

@end

@implementation UITableView (CalcHeight)

- (CGFloat)ch_heightForModel:(NSObject *)model configCellClass:(Class(^)(NSObject *))configCellClass
{
    Class cellClass = configCellClass(model);
    NSString *reusedID = NSStringFromClass(cellClass);
    
    // 先尝试从model中获取cell的高度
    SEL heightKey = [self pri_ch_cacheHeightKeyForReusedID:reusedID];
    CGFloat cellHeight = [objc_getAssociatedObject(model, heightKey) floatValue];
    
    if (cellHeight > 0) {
        return cellHeight;
    }
    
    [self registerClass:cellClass forCellReuseIdentifier:reusedID];
    [self pri_ch_reuseID:&reusedID forModel:model];
    
    UITableViewCell *calcCell = self.pri_ch_cellStorage[reusedID];
    if (!calcCell) {
        calcCell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
        calcCell.frame = CGRectMake(0, 0, self.frame.size.width, 0.1);
        [self.pri_ch_cellStorage setValue:calcCell forKey:reusedID];
    }
    
    [calcCell ch_calModel:model atTableView:self];
    [calcCell setNeedsLayout];
    [calcCell layoutIfNeeded];
    
    if ([calcCell respondsToSelector:@selector(ch_heightForModel:)]) {
        cellHeight = [calcCell ch_heightForModel:model];
    }
    else {
        // 可能使用的是自动布局，需要用自动布局的方式计算高度
    }
    
    // 计算完高度，将高度缓存在model里
    if (cellHeight > 0) {
        objc_setAssociatedObject(model, heightKey, @(cellHeight), OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return cellHeight;
}

- (UITableViewCell *)ch_cellForModel:(NSObject *)model
{
    NSString *reuseID = nil;
    [self pri_ch_reuseID:&reuseID forModel:model];
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:reuseID];
    [cell ch_setModel:model atTableView:self];
    return cell;
}

- (void)ch_cleanHeightCacheForModel:(NSObject *)model
{
    NSString *reuseID = nil;
    [self pri_ch_reuseID:&reuseID forModel:model];
    SEL heightKey = [self pri_ch_cacheHeightKeyForReusedID:reuseID];
    objc_setAssociatedObject(model, heightKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)ch_delayReloadData:(NSTimeInterval)delay
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:delay];
}

#pragma mark - - private

- (SEL)pri_ch_cacheHeightKeyForReusedID:(NSString *)reusedID
{
    // 先尝试从model中获取cell的高度
    NSString *heigtKeyStr = [NSString stringWithFormat:@"$getCellHeight_%p_%@", self, reusedID];
    SEL heightKey = NSSelectorFromString(heigtKeyStr);
    return heightKey;
}

- (void)pri_ch_reuseID:(NSString **)reuseIDPtr forModel:(NSObject *)model
{
    NSString *reuseIDKeyStr = [NSString stringWithFormat:@"$getReusedID_%p", self];
    SEL reuseIDKey = NSSelectorFromString(reuseIDKeyStr);
    NSString *reuseID = *reuseIDPtr;
    if (!reuseID.length) {
        *reuseIDPtr = objc_getAssociatedObject(model, reuseIDKey);
    }
    else {
        objc_setAssociatedObject(model, reuseIDKey, reuseID, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (NSMutableDictionary *)pri_ch_cellStorage
{
    NSMutableDictionary *mDic = objc_getAssociatedObject(self, _cmd);
    if (!mDic) {
        mDic = [NSMutableDictionary dictionaryWithCapacity:3];
        objc_setAssociatedObject(self, _cmd, mDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return mDic;
}

@end
