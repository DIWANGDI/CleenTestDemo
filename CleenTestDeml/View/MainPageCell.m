//
//  MainPageCell.m
//  CleenTestDeml
//
//  Created by 王迪 on 2018/2/24.
//  Copyright © 2018年 王迪. All rights reserved.
//

#import "MainPageCell.h"
#import "CleenDataModel.h"
#import <UIImageView+WebCache.h>

#define DefaultHeadImgSize   CGSizeMake(100, 80)

@interface MainPageCell ()

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIView  *line;

@end

@implementation MainPageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];
        
        self.headImgView = [[UIImageView alloc] initWithImage:PLACE_HOLEDER_IMG];
        self.headImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.headImgView.clipsToBounds = YES;
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.font = [UIFont systemFontOfSize:18];
        self.titleLab.textColor = wh_TitleColor;
        self.titleLab.numberOfLines = 1;
        
        self.contentLbl = [[UILabel alloc] init];
        self.contentLbl.textAlignment = NSTextAlignmentLeft;
        self.contentLbl.font = [UIFont systemFontOfSize:15];
        self.contentLbl.textColor = wh_norFontColor;
        self.contentLbl.numberOfLines = 30;
        
        self.line=[[UIView alloc] init];
        self.line.backgroundColor=wh_lineColor;
        
        [self.contentView addSubview:self.headImgView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.contentLbl];
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize titleSize = [self.titleLab sizeThatFits:CGSizeMake(FRAME_W(self) - 20, 0)];
    CGRect titleFrame=self.titleLab.frame;
    titleFrame.origin = CGPointMake(10, 5);
    titleFrame.size = titleSize;
    self.titleLab.frame = titleFrame;
    
    CGFloat imgViewWidth = DefaultHeadImgSize.width;
    
    CGSize contentSize = [self.contentLbl sizeThatFits:CGSizeMake(FRAME_W(self) - 10 - 10 - imgViewWidth - 10, 0)];
    CGRect contentFrame = CGRectZero;
    contentFrame.origin = CGPointMake(10, FRAME_B(self.titleLab)+10);
    contentFrame.size = contentSize;
    self.contentLbl.frame = contentFrame;
    
    CGRect imgFrame = self.headImgView.frame;
    imgFrame.origin.x = FRAME_W(self) - imgViewWidth - 10;
    imgFrame.origin.y = FRAME_T(self.contentLbl);
    self.headImgView.frame = imgFrame;
    
    CGRect lineFrame = self.line.frame;
    lineFrame.origin.x = 0;
    lineFrame.origin.y = MAX(FRAME_B(self.contentLbl), FRAME_B(self.headImgView)) + 5;
    lineFrame.size = CGSizeMake(FRAME_W(self), 1);
    self.line.frame = lineFrame;
}

- (CGFloat)ch_heightForModel:(id)model
{
    return FRAME_B(self.line);
}

- (void)ch_calModel:(CleenDataModel *)model atTableView:(UITableView *)tableView
{
    self.titleLab.text=model.title;
    self.contentLbl.text=model.descript;
    
    CGRect headFrame = self.headImgView.frame;
    headFrame.size = model.imageSize.height > 0 ? model.imageSize : DefaultHeadImgSize;
    self.headImgView.frame = headFrame;
}

- (void)ch_setModel:(CleenDataModel *)model atTableView:(UITableView *)tableView
{
    [self ch_calModel:model atTableView:tableView];
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.imageHref] placeholderImage:PLACE_HOLEDER_IMG completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL)
     {
         // 如果已经获取到 image 的高度，则不再重复获取
         if (image && model.imageSize.height > 0) {
             return;
         }
         
         if (error || image == nil) {
             return ;
         }
         
         /*
          * 将image的size保存在model中，是为了在计算cell高度以及给cell赋值时重新设置
          * headImgView.frame 时使用。
          * 不能直接在这里设置 headImgView.frame，因为这里对cell的操作是异步的，
          * 如果直接在这里设置的话，将会由于cell的复用机制导致显示异常。
          */
         CGFloat imgW = FRAME_W(self.headImgView);
         CGFloat imgH = image.size.height/image.size.width * imgW;
         model.imageSize = CGSizeMake(imgW, imgH);
         
         /*
          * tableView reloadData 之前需要清除保存在model中的高度缓存，
          * 不然的话，reloadData后仍将使用缓存来设置cell高度
          */
         [tableView ch_cleanHeightCacheForModel:model];
         
         // 延时调用是为了防止 tableView 连续 reloadData 导致的显示异常
         [tableView ch_delayReloadData:0.1];
     }];
}

@end
