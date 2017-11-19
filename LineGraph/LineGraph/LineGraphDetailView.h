//
//  LineGraphDetailView.h
//  Linefaf
//
//  Created by wzl on 2017/5/31.
//  Copyright © 2017年 zr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BodyWeightModel.h"

#define UIColorFromRGB2(rgbValue,Alpha) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:Alpha]


@interface LineGraphDetailView : UIButton

@property (nonatomic, copy) void(^tapViewBlock)(void);

@end
