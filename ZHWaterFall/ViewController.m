//
//  ViewController.m
//  ZHWaterFall
//
//  Created by 李保征 on 2017/6/22.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ViewController.h"

#import "MJExtension.h"
#import "MJRefresh.h"

#import "ZHWaterFallView.h"
#import "Item.h"
#import "ItemCell.h"

@interface ViewController ()<ZHWaterFallViewDelegate,ZHWaterFallViewDataSource>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) ZHWaterFallView *fallView;

@end

@implementation ViewController

#pragma mark - getter

- (NSMutableArray *)items{
    if (!_items) {
        NSArray *array = [Item mj_objectArrayWithFilename:@"2.plist"];
        _items = [NSMutableArray arrayWithArray:array];
    }
    return _items;
}

- (ZHWaterFallView *)fallView{
    if (!_fallView) {
        _fallView = [[ZHWaterFallView alloc] init];
        _fallView.backgroundColor = [UIColor orangeColor];
        // 跟随着父控件的尺寸而自动伸缩
        _fallView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _fallView.frame = self.view.bounds;
        _fallView.dataSource = self;
        _fallView.delegate = self;
        
        __weak __typeof__(self) weakSelf = self;
        _fallView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadNewData];
        }];
        _fallView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
    }
    return _fallView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.fallView];
    [self.fallView.mj_header beginRefreshing];
    
}

#pragma mark - data
- (void)loadNewData{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 加载1.plist
        NSArray *newShops = [Item mj_objectArrayWithFilename:@"1.plist"];
        [self.items insertObjects:newShops atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newShops.count)]];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新瀑布流控件
        [self.fallView reloadData];
        
        // 停止刷新
        [self.fallView.mj_header endRefreshing];
    });
}

- (void)loadMoreData{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 加载3.plist
        NSArray *newShops = [Item mj_objectArrayWithFilename:@"3.plist"];
        [self.items addObjectsFromArray:newShops];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 刷新瀑布流控件
        [self.fallView reloadData];
        
        // 停止刷新
        [self.fallView.mj_footer endRefreshing];
    });
}
#pragma mark - delegate
- (NSUInteger)numberOfCellsInWaterFallView:(ZHWaterFallView *)waterFallView{
    return self.items.count;
}

- (ZHWaterFallCell *)waterFallView:(ZHWaterFallView *)waterFallView cellAtIndex:(NSUInteger)index{
    ItemCell *cell = [ItemCell cellWithWaterflowView:waterFallView];
    cell.item = self.items[index];
    return cell;
}

- (NSUInteger)numberOfColumnsInWaterFallView:(ZHWaterFallView *)waterFallView{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        // 竖屏
        return 3;
    } else {
        return 5;
    }
}

- (CGFloat)waterFallView:(ZHWaterFallView *)waterFallView heightAtIndex:(NSUInteger)index{
    Item *item = self.items[index];
    // 根据cell的宽度 和 图片的宽高比 算出 cell的高度
    return waterFallView.cellWidth * item.h / item.w;
}

#pragma mark - layout

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.fallView reloadData];
}



@end
