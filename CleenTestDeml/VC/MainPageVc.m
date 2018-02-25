//
//  MainPageVc.m
//  CleenTestDeml
//
//  Created by 王迪 on 2018/2/24.
//  Copyright © 2018年 王迪. All rights reserved.
//

#import "MainPageVc.h"
#import "KGNetworkManager.h"
#import "CleenDataModel.h"
#import "MainPageCell.h"
#import "NSString+NullConfig.h"

@interface MainPageVc ()

@end

@implementation MainPageVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navLetfItem setHidden:YES];
}

- (void)pullRefreshInScrollView:(UIScrollView *)scrollView
{
    self.currentPageIndex = 0;
    [self requestDataSuccess:^(NSArray *arr)
    {
        if (arr.count)
        {
            [self.arrayDataItems setArray:arr];
            self.currentPageIndex += 1;
            [self.tableView reloadData];
            self.tableView.tt_enableLoadingMore = NO;
        }
        [self.tableView xtt_endPullingRefreshState:TTEndRefreshState_Success];
        
    } fail:^(NSString *err)
    {
        [self.tableView xtt_endPullingRefreshState:TTEndRefreshState_Fail];
    }];
}

- (void)requestDataSuccess:(void(^)(NSArray *arr))success fail:(void(^)(NSString *err))fail
{
    weakSelf(ws);
    [[KGNetworkManager sharedInstance] GetActionWithSuccess:^(NSDictionary *data)
    {
        ws.navTitle=configEmpty(data[@"title"]);
        NSArray* resultArr = [CleenDataModel modelWithDicInfo:data[@"rows"]];
        success(resultArr);
        
    } fail:^(id err)
    {
        fail(err);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CleenDataModel *model = self.arrayDataItems[indexPath.row];
    return [tableView ch_heightForModel:model configCellClass:^Class(NSObject *model) {
        return [MainPageCell class];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CleenDataModel *model = self.arrayDataItems[indexPath.row];
    MainPageCell *cell = (MainPageCell *)[tableView ch_cellForModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
