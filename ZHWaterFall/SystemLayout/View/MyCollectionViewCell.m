//
//  MyCollectionViewCell.m
//  ZHWaterFall
//
//  Created by 李保征 on 2017/6/23.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "MyCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface MyCollectionViewCell()
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *priceLabel;
@end

@implementation MyCollectionViewCell

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
