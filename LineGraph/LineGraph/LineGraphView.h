//
//  LineGraphView.h
//  SmartHome
//
//  Created by wzl on 2017/5/31.
//  Copyright © 2017年 Huawei Device. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB2(rgbValue,Alpha) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:Alpha]


@interface LineGraphView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *bodyWeights;
@property (nonatomic, strong) NSArray *pointDatas;
@property (nonatomic, assign) NSInteger selectIndx;

@end
