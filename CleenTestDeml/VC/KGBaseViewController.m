//
//  AppDelegate.m
//  CleenTestDeml
//
//  Created by 王迪 on 2018/2/24.
//  Copyright © 2018年 王迪. All rights reserved.
//


#import "KGBaseViewController.h"

@interface KGBaseViewController ()

@end

@implementation KGBaseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setNav];
}

-(void)setNav
{
    self.navBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenSize.width, HEIGHT_YANYAN_TOP)];
    self.navBackView.backgroundColor = wh_themeColor;
    [self.view addSubview:self.navBackView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.userInteractionEnabled = NO;
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setImage:[UIImage imageNamed:@"M_Left_Img"] forState:UIControlStateNormal];
    leftBtn.frame=CGRectMake(10, HEIGHT_STATUSBAR+2, 40, HEIGHT_YANYAN_NAVIBAR-4);
    [leftBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navLetfItem = leftBtn;
    
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:19];
    label.textColor = wh_navTitleColor;
    label.numberOfLines = 1;
    label.frame = CGRectMake(KScreenSize.width/2-80, HEIGHT_STATUSBAR, 160, HEIGHT_YANYAN_NAVIBAR);
    self.navTitleLab = label;
    
    [self.navBackView addSubview:leftBtn];
    [self.navBackView addSubview:label];
}

-(void)setNavTitle:(NSString *)navTitle
{
    self.navTitleLab.text = navTitle;
}

-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
