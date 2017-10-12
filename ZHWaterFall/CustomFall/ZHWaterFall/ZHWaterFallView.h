//
//  ZHWaterFallView.h
//  ZHWaterFall
//
//  Created by 李保征 on 2017/6/22.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHWaterFallCell.h"

typedef enum {
    ZHWaterFallMarginTypeTop,
    ZHWaterFallMarginTypeBottom,
    ZHWaterFallMarginTypeLeft,
    ZHWaterFallMarginTypeRight,
    ZHWaterFallMarginTypeColumn, // 每一列
    ZHWaterFallMarginTypeRow, // 每一行
} ZHWaterFallMarginType;

@class ZHWaterFallView, ZHWaterFallCell;


@protocol ZHWaterFallViewDataSource <NSObject>
@required
/** 个数 */
- (NSUInteger)numberOfCellsInWaterFallView:(ZHWaterFallView *)waterFallView;
/** cell */
- (ZHWaterFallCell *)waterFallView:(ZHWaterFallView *)waterFallView cellAtIndex:(NSUInteger)index;

@optional
/** 列数 */
- (NSUInteger)numberOfColumnsInWaterFallView:(ZHWaterFallView *)waterFallView;
@end


@protocol ZHWaterFallViewDelegate <UIScrollViewDelegate>
@optional
/**  第index位置cell对应的高度 */
- (CGFloat)waterFallView:(ZHWaterFallView *)waterFallView heightAtIndex:(NSUInteger)index;
/**  返回间距 */
- (CGFloat)waterFallView:(ZHWaterFallView *)waterFallView marginForType:(ZHWaterFallMarginType)type;
/**  选中第index位置的cell */
- (void)waterFallView:(ZHWaterFallView *)waterFallView didSelectAtIndex:(NSUInteger)index;
@end



@interface ZHWaterFallView : UIScrollView

@property (nonatomic, weak) id<ZHWaterFallViewDataSource> dataSource;

@property (nonatomic, weak) id<ZHWaterFallViewDelegate> delegate;

- (void)reloadData;

- (CGFloat)cellWidth;

- (__kindof ZHWaterFallCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end
