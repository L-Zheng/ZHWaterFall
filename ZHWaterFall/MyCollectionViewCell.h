//
//  MyCollectionViewCell.h
//  ZHWaterFall
//
//  Created by 李保征 on 2017/6/23.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"


static NSString *const MyCollectionViewCellID = @"MyCollectionViewCellID";

@interface MyCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) Item *item;

@end
