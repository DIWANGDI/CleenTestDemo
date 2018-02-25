//
//  AppDelegate.m
//  CleenTestDeml
//
//  Created by 王迪 on 2018/2/24.
//  Copyright © 2018年 王迪. All rights reserved.
//


#import "KGBaseTableViewController.h"

@interface KGBaseTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) UITableViewStyle style;

@end

@implementation KGBaseTableViewController

- (instancetype)init
{
    if (self = [super init])
    {
        _currentPageIndex = 0;
        _separatorFull = NO;
        _style = UITableViewStyleGrouped;
        _arrayDataItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style
{
    if (self = [self init])
    {
        _style = style;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    self.tableView.tt_enableLoadingMore = NO;
    [self.tableView xtt_beginPullingRefresh];
}

- (void)initUI
{
    [self adjustIOS11];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        CGRect viewFrame=self.view.bounds;
        viewFrame.origin.y+=HEIGHT_YANYAN_TOP;
        viewFrame.size.height-=HEIGHT_YANYAN_TOP;
        _tableView = [[UITableView alloc] initWithFrame:viewFrame style:self.style];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0 ;
        _tableView.estimatedSectionHeaderHeight = 0 ;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = wh_lineColor;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _tableView.tt_refreshDelegate = self;
        
        //去掉kongcell的分割线
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenSize.width, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)adjustIOS11
{
#ifdef __IPHONE_11_0
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
#else // 暂时适配Xcode8编译
    
    SEL aSel = NSSelectorFromString(@"setContentInsetAdjustmentBehavior:");
    Method aMethod = class_getInstanceMethod(self.class, aSel);
    IMP aImp = method_getImplementation(aMethod);
    if (aImp) {
        void(*aFunc)(id, SEL, NSInteger) = (typeof(aFunc))aImp;
        aFunc(self, aSel, 2); // UIScrollViewContentInsetAdjustmentNever
    }
    else {
        
    }
    
#endif
}

#pragma mark - - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.arrayDataItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.separatorFull) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

-(void)viewDidLayoutSubviews{
    
    if (self.separatorFull) {
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}
@end
