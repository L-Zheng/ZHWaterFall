//
//  ZHWaterFallView.m
//  ZHWaterFall
//
//  Created by 李保征 on 2017/6/22.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ZHWaterFallView.h"

#define ZHWaterFallViewDefaultCellH 70
#define ZHWaterFallViewDefaultMargin 8
#define ZHWaterFallViewDefaultNumberOfColumns 3

@interface ZHWaterFallView()

@property (nonatomic,strong) NSMutableArray <NSValue *> *cellFrames;

@property (nonatomic,strong) NSMutableDictionary *displayingCells;

@property (nonatomic,strong) NSMutableSet <ZHWaterFallCell *> *reusableCells;
@end

@implementation ZHWaterFallView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self reloadData];
}

#pragma maek - getter

- (NSMutableArray<NSValue *> *)cellFrames{
    if (!_cellFrames) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

- (NSMutableDictionary *)displayingCells{
    if (!_displayingCells) {
        _displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
}

- (NSMutableSet<ZHWaterFallCell *> *)reusableCells{
    if (!_reusableCells) {
        _reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}

#pragma mark - public func

/** cell的宽度 */
- (CGFloat)cellWidth{
    // 总列数
    NSInteger numberOfColumns = [self numberOfColumns];
    CGFloat leftM = [self marginForType:ZHWaterFallMarginTypeLeft];
    CGFloat rightM = [self marginForType:ZHWaterFallMarginTypeRight];
    CGFloat columnM = [self marginForType:ZHWaterFallMarginTypeColumn];
    return (self.bounds.size.width - leftM - rightM - (numberOfColumns - 1) * columnM) / numberOfColumns;
}

- (void)reloadData{
    // 移除所有保存数据
    [self.displayingCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayingCells removeAllObjects];
    [self.cellFrames removeAllObjects];
    [self.reusableCells removeAllObjects];
    
    // cell的总数
    NSInteger numberOfCells = [self.dataSource numberOfCellsInWaterFallView:self];
    // 间距  cell的宽度
    CGFloat topM = [self marginForType:ZHWaterFallMarginTypeTop];
    CGFloat bottomM = [self marginForType:ZHWaterFallMarginTypeBottom];
    CGFloat leftM = [self marginForType:ZHWaterFallMarginTypeLeft];
    CGFloat rightM = [self marginForType:ZHWaterFallMarginTypeRight];
    CGFloat columnM = [self marginForType:ZHWaterFallMarginTypeColumn];
    CGFloat rowM = [self marginForType:ZHWaterFallMarginTypeRow];
    CGFloat cellW = [self cellWidth];
    
    // 总列数
    NSInteger numberOfColumns = [self numberOfColumns];
    // 用一个C语言数组存放所有列的最大Y值
    CGFloat maxYOfColumns[numberOfColumns];
    for (int i = 0; i<numberOfColumns; i++) {
        maxYOfColumns[i] = 0.0;
    }
    
    // 计算所有cell的frame
    for (int i = 0; i<numberOfCells; i++) {
        // cell处在第几列(最短的一列)
        NSUInteger cellColumn = 0;
        // cell所处那列的最大Y值(最短那一列的最大Y值)
        CGFloat maxYOfCellColumn = maxYOfColumns[cellColumn];
        // 求出最短的一列
        for (int j = 1; j<numberOfColumns; j++) {
            if (maxYOfColumns[j] < maxYOfCellColumn) {
                cellColumn = j;
                maxYOfCellColumn = maxYOfColumns[j];
            }
        }
        
        // 询问代理i位置的高度
        CGFloat cellH = [self heightAtIndex:i];
        
        // cell的位置
        CGFloat cellX = leftM + cellColumn * (cellW + columnM);
        CGFloat cellY = 0;
        if (maxYOfCellColumn == 0.0) { // 首行
            cellY = topM;
        } else {
            cellY = maxYOfCellColumn + rowM;
        }
        
        // 添加frame到数组中
        CGRect cellFrame = CGRectMake(cellX, cellY, cellW, cellH);
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        
        // 更新最短那一列的最大Y值
        maxYOfColumns[cellColumn] = CGRectGetMaxY(cellFrame);
    }
    
    // 设置contentSize
    CGFloat contentH = maxYOfColumns[0];
    for (int j = 1; j<numberOfColumns; j++) {
        if (maxYOfColumns[j] > contentH) {
            contentH = maxYOfColumns[j];
        }
    }
    contentH += bottomM;
    self.contentSize = CGSizeMake(0, contentH);
}

- (__kindof ZHWaterFallCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    __block ZHWaterFallCell *reusableCell = nil;
    
    [self.reusableCells enumerateObjectsUsingBlock:^(ZHWaterFallCell *cell, BOOL *stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            reusableCell = cell;
            *stop = YES;
        }
    }];
    
    if (reusableCell) { // 从缓存池中移除
        [self.reusableCells removeObject:reusableCell];
    }
    return reusableCell;
}

#pragma mark - private func

/** 列数 */
- (NSUInteger)numberOfColumns{
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterFallView:)]) {
        return [self.dataSource numberOfColumnsInWaterFallView:self];
    } else {
        return ZHWaterFallViewDefaultNumberOfColumns;
    }
}

/** 间距 */
- (CGFloat)marginForType:(ZHWaterFallMarginType)type{
    if ([self.delegate respondsToSelector:@selector(waterFallView:marginForType:)]) {
        return [self.delegate waterFallView:self marginForType:type];
    } else {
        return ZHWaterFallViewDefaultMargin;
    }
}

/**  index位置对应的高度 */
- (CGFloat)heightAtIndex:(NSUInteger)index{
    if ([self.delegate respondsToSelector:@selector(waterFallView:heightAtIndex:)]) {
        return [self.delegate waterFallView:self heightAtIndex:index];
    } else {
        return ZHWaterFallViewDefaultCellH;
    }
}

/** 判断一个frame有无显示在屏幕上 */
- (BOOL)isInScreen:(CGRect)frame{
    return (CGRectGetMaxY(frame) > self.contentOffset.y) &&
    (CGRectGetMinY(frame) < self.contentOffset.y + self.bounds.size.height);
}

#pragma mark - layout
/**  当UIScrollView滚动的时候也会调用这个方法 */
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 向数据源索要对应位置的cell
    NSUInteger numberOfCells = self.cellFrames.count;
    for (int i = 0; i<numberOfCells; i++) {
        // 取出i位置的frame
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        
        // 优先从字典中取出i位置的cell
        ZHWaterFallCell *cell = self.displayingCells[@(i)];
        
        // 判断i位置对应的frame在不在屏幕上（能否看见）
        if ([self isInScreen:cellFrame]) { // 在屏幕上
            if (cell == nil) {
                cell = [self.dataSource waterFallView:self cellAtIndex:i];
                cell.frame = cellFrame;
                [self addSubview:cell];
                
                // 存放到字典中
                self.displayingCells[@(i)] = cell;
            }
        } else {  // 不在屏幕上
            if (cell) {
                // 从scrollView和字典中移除
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                
                // 存放进缓存池
                [self.reusableCells addObject:cell];
            }
        }
    }
}

#pragma mark - action

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (![self.delegate respondsToSelector:@selector(waterFallView:didSelectAtIndex:)]) return;
    
    // 获得触摸点
    UITouch *touch = [touches anyObject];
    //    CGPoint point = [touch locationInView:touch.view];
    CGPoint point = [touch locationInView:self];
    
    __block NSNumber *selectIndex = nil;
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(id key, ZHWaterFallCell *cell, BOOL *stop) {
        if (CGRectContainsPoint(cell.frame, point)) {
            selectIndex = key;
            *stop = YES;
        }
    }];
    
    if (selectIndex) {
        [self.delegate waterFallView:self didSelectAtIndex:selectIndex.unsignedIntegerValue];
    }
}

@end
