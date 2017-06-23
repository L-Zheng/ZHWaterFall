//
//  ItemCell.h
//  ZHWaterFall
//
//  Created by 李保征 on 2017/6/23.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ZHWaterFallCell.h"
@class ZHWaterFallView, Item;

@interface ItemCell : ZHWaterFallCell

+ (instancetype)cellWithWaterflowView:(ZHWaterFallView *)fallView;

@property (nonatomic, strong) Item *item;

@end
