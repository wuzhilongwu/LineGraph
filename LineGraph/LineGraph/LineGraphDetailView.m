//
//  LineGraphDetailView.m
//  Linefaf
//
//  Created by wzl on 2017/5/31.
//  Copyright © 2017年 zr. All rights reserved.
//

#import "LineGraphDetailView.h"

@implementation LineGraphDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        UIImage *image = [[UIImage imageNamed:@"be_weight9"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
//        [self setBackgroundImage:image forState:UIControlStateNormal];
        self.backgroundColor = UIColorFromRGB2(0x01c1f2, 1);
        self.layer.cornerRadius = frame.size.height/2;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewLick)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)viewLick {
    !self.tapViewBlock ?: self.tapViewBlock();
}

@end
