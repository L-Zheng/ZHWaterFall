//
//  CollectionViewFallVC.m
//  ZHWaterFall
//
//  Created by 李保征 on 2017/6/23.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "CollectionViewFallVC.h"

#import "MJExtension.h"
#import "MJRefresh.h"

#import "Item.h"
#import "MyCollectionViewCell.h"
#import "ZHWaterFallLayout.h"
#import "CollectionHeader.h"
#import "CollectionFooter.h"

@interface CollectionViewFallVC ()<UICollectionViewDataSource,UICollectionViewDelegate,ZHWaterFallLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong) ZHWaterFallLayout *waterFallLayout;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation CollectionViewFallVC

#pragma mark - getter

- (NSMutableArray *)items{
    if (!_items) {
        NSArray *array = [Item mj_objectArrayWithFilename:@"2.plist"];
        _items = [NSMutableArray arrayWithArray:array];
    }
    return _items;
}

- (ZHWaterFallLayout *)waterFallLayout{
    if (!_waterFallLayout) {
        _waterFallLayout = [[ZHWaterFallLayout alloc] init];
//        _waterFallLayout.sectionFootersPinToVisibleBounds = YES;
//        _waterFallLayout.sectionHeadersPinToVisibleBounds = YES;
        _waterFallLayout.delegate = self;
    }
    return _waterFallLayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.view.bounds.size.width / 3, 80);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionFootersPinToVisibleBounds = YES;
        layout.sectionHeadersPinToVisibleBounds = YES;
        layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) collectionViewLayout:self.waterFallLayout];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:MyCollectionViewCellID];
//        [_collectionView registerClass:[CollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionHeaderID];
//        [_collectionView registerClass:[CollectionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CollectionFooterID];
        
        __weak __typeof__(self) weakSelf = self;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadNewData];
        }];
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置CGRectZero从导航栏下开始计算
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - data
- (void)loadNewData{
    
    // 加载1.plist
    NSArray *newShops = [Item mj_objectArrayWithFilename:@"1.plist"];
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:newShops];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新瀑布流控件
        [self.collectionView reloadData];
        
        // 停止刷新
        [self.collectionView.mj_header endRefreshing];
    });
}

- (void)loadMoreData{
    NSArray *newShops = [Item mj_objectArrayWithFilename:@"3.plist"];
    [self.items addObjectsFromArray:newShops];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 刷新瀑布流控件
        [self.collectionView reloadData];
        
        // 停止刷新
        [self.collectionView.mj_footer endRefreshing];
    });
}

#pragma mark - collection delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyCollectionViewCellID forIndexPath:indexPath];
    cell.item = self.items[indexPath.item];
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    
//    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
//        CollectionHeader *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionHeaderID forIndexPath:indexPath];
//        return headView;
//    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
//        CollectionFooter *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CollectionFooterID forIndexPath:indexPath];
//        return footerView;
//    }
//    else{
//        return nil;
//    }
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(self.view.bounds.size.width, CollectionHeaderHeight);
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    return CGSizeMake(self.view.bounds.size.width, CollectionFooterHeight);
//}

#pragma mark - layout delegate

- (CGFloat)zhWaterFallLayout:(ZHWaterFallLayout *)zhWaterFallLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    Item *item = self.items[indexPath.item];
    return itemWidth * item.h / item.w;
}


@end
