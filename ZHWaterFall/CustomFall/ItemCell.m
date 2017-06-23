//
//  ItemCell.m
//  ZHWaterFall
//
//  Created by 李保征 on 2017/6/23.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ItemCell.h"
#import "ZHWaterFallView.h"
#import "UIImageView+WebCache.h"
#import "Item.h"

@interface ItemCell()
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *priceLabel;
@end

@implementation ItemCell


+ (instancetype)cellWithWaterflowView:(ZHWaterFallView *)fallView{
    static NSString *ID = @"item";
    ItemCell *cell = [fallView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ItemCell alloc] init];
        cell.identifier = ID;
    }
    return cell;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.textColor = [UIColor whiteColor];
        [self addSubview:priceLabel];
        self.priceLabel = priceLabel;
    }
    return self;
}

- (void)setItem:(Item *)item{
    _item = item;
    self.priceLabel.text = item.price;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:@"loading"]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    CGFloat priceX = 0;
    CGFloat priceH = 25;
    CGFloat priceY = self.bounds.size.height - priceH;
    CGFloat priceW = self.bounds.size.width;
    self.priceLabel.frame = CGRectMake(priceX, priceY, priceW, priceH);
}

@end
