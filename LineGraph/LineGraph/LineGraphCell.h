//
//  LineGraphCell.h
//  SmartHome
//
//  Created by wzl on 2017/5/31.
//  Copyright © 2017年 Huawei Device. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineGraphDetailView.h"
#import "BodyWeightModel.h"

#define UIColorFromRGB2(rgbValue,Alpha) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:Alpha]


@interface LineGraphCell : UICollectionViewCell

@property (nonatomic, copy) void(^popUpDetailViewBlock)(UIView *view);
@property (nonatomic, strong) LineGraphDetailView *detailView;
@property (nonatomic, strong) BodyWeightModel *model;
@property (nonatomic, assign) BOOL showTip;

- (void)setStartsDot:(CGFloat)startsDot endDot:(CGFloat)endDot preDot:(CGFloat)preDot;
- (void)removeDetailView;

@end



@interface UICollectionHeaderView : UICollectionReusableView

@end
