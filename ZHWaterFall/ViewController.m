//
//  ViewController.m
//  ZHWaterFall
//
//  Created by 李保征 on 2017/6/22.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ViewController.h"
#import "CustomFallVC.h"
#import "CollectionViewFallVC.h"


@interface ViewController ()


@end

@implementation ViewController

- (IBAction)goToCollectionViewFallVC:(UIButton *)sender {
    CollectionViewFallVC *vc = [[CollectionViewFallVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)goToCustomFallVC:(UIButton *)sender {
    CustomFallVC *vc = [[CustomFallVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
