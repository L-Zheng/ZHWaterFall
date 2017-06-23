//
//  ZHWaterFallLayout.h
//  ZHWaterFall
//
//  Created by 李保征 on 2017/6/23.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHWaterFallLayout;

@protocol ZHWaterFallLayoutDelegate <NSObject>

@required
/** cell高度 */
- (CGFloat)zhWaterFallLayout:(ZHWaterFallLayout *)zhWaterFallLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@optional
/** 列数 */
- (CGFloat)columnCountOfZHWaterFallLayout:(ZHWaterFallLayout *)ZHWaterFallLayout;
/** 列间距 */
- (CGFloat)columnMarginOfZHWaterFallLayout:(ZHWaterFallLayout *)ZHWaterFallLayout;
/** 行间距 */
- (CGFloat)rowMarginOfZHWaterFallLayout:(ZHWaterFallLayout *)ZHWaterFallLayout;
/** 上下左右边距 */
- (UIEdgeInsets)edgeInsetsOfZHWaterFallLayout:(ZHWaterFallLayout *)waterFallLayout;

@end

@interface ZHWaterFallLayout : UICollectionViewFlowLayout

@property (nonatomic ,weak) id<ZHWaterFallLayoutDelegate> delegate;

@end
