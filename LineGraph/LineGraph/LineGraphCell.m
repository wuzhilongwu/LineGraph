//
//  LineGraphCell.m
//  SmartHome
//
//  Created by wzl on 2017/5/31.
//  Copyright © 2017年 Huawei Device. All rights reserved.
//

#import "LineGraphCell.h"

@interface DotView : UIView

@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UIView *whiteView;

- (void)setSelectColorWithSelect:(BOOL)select;

@end

@implementation DotView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _blueView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2-4, frame.size.height/2-4, 8, 8)];
        _blueView.backgroundColor = UIColorFromRGB2(0x01c1f2, 1);
        _blueView.layer.cornerRadius = 4;
        _blueView.layer.masksToBounds = YES;
        [self addSubview:_blueView];
        
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.cornerRadius = 2.5;
        _whiteView.center = CGPointMake(_blueView.frame.size.width/2, _blueView.frame.size.height/2);
        _whiteView.layer.masksToBounds = YES;
        [_blueView addSubview:_whiteView];
    }
    return self;
}

- (void)setSelectColorWithSelect:(BOOL)select {
    if (!select) {
        _blueView.backgroundColor = UIColorFromRGB2(0x01c1f2, 1);
        _whiteView.backgroundColor = [UIColor whiteColor];
    } else {
        _whiteView.backgroundColor = UIColorFromRGB2(0x01c1f2, 1);
        _blueView.backgroundColor = [UIColor whiteColor];
    }
}

@end



@interface LineGraphCell ()

@property (nonatomic, strong) DotView *dotView;
@property (nonatomic, assign) CGFloat startsDot;

@property (nonatomic, assign) CGFloat endDot;
//上一个cell的点
@property (nonatomic, assign) CGFloat preDot;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *dotShapeLayer;

@end

@implementation LineGraphCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDotLines];
        
        _dotView = [[DotView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _dotView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotViewLick:)];
        [_dotView addGestureRecognizer:tap];
        [self addSubview:_dotView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //添加渐变色
    [self addGradientWithRect:rect];
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    //中间的竖线
    CGPathMoveToPoint(path, NULL, rect.size.width/2-0.25, 0);
    CGPathAddLineToPoint(path, NULL, rect.size.width/2-0.25, rect.size.height);
    //顶部线
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, rect.size.width, 0);
    //底部线
    CGPathMoveToPoint(path, NULL, 0, rect.size.height);
    CGPathAddLineToPoint(path, NULL, rect.size.width, rect.size.height);
    CGContextAddPath(ref, path);
    CFRelease(path);
    CGContextSetLineWidth(ref, 0.5);
    [UIColorFromRGB2(0xd8d8d8, 1) setStroke];
    CGContextStrokePath(ref);
    
    //选中的线
    if (self.showTip) {
        path = CGPathCreateMutable();
        //中间的竖线
        CGPathMoveToPoint(path, NULL, rect.size.width/2-0.25, rect.size.height - self.startsDot);
        CGPathAddLineToPoint(path, NULL, rect.size.width/2-0.25, rect.size.height);
        CGContextAddPath(ref, path);
        CFRelease(path);
        CGContextSetLineWidth(ref, 0.5);
        [UIColorFromRGB2(0x01c1f2, 1) setStroke];
        CGContextStrokePath(ref);
    }
    
    //上一个cell有数据
    if (self.preDot != -1) {
        path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, -rect.size.width/2, rect.size.height - self.preDot);
        CGPathAddLineToPoint(path, NULL, rect.size.width/2, rect.size.height - self.startsDot);
        CGContextAddPath(ref, path);
        CFRelease(path);
        CGContextSetLineWidth(ref, 2);
        [UIColorFromRGB2(0x01c1f2, 1) setStroke];
        CGContextStrokePath(ref);
    }
    if (self.endDot == -1) {
        return;
    }
    
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, rect.size.width/2, rect.size.height - self.startsDot);
    CGPathAddLineToPoint(path, NULL, rect.size.width+rect.size.width/2, rect.size.height - self.endDot);
    CGContextAddPath(ref, path);
    CFRelease(path);
    CGContextSetLineWidth(ref, 2);
    [UIColorFromRGB2(0x01c1f2, 1) setStroke];
    CGContextStrokePath(ref);
}

- (void)addGradientWithRect:(CGRect)rect {
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    if (self.preDot == -1) {
        if (self.endDot == -1) {
            CFRelease(path);
            return;
        }
        CGPathMoveToPoint(path, NULL, rect.size.width/2, rect.size.height);
        CGPathAddLineToPoint(path, NULL, rect.size.width/2, rect.size.height - self.startsDot);
        CGPathAddLineToPoint(path, NULL, rect.size.width+rect.size.width/2, rect.size.height - self.endDot);
        CGPathAddLineToPoint(path, NULL, rect.size.width+rect.size.width/2, rect.size.height);
//        CGPathAddLineToPoint(path, NULL, rect.size.width/2, rect.size.height);
    } else if (self.endDot == -1) {
        CGPathMoveToPoint(path, NULL, -rect.size.width/2, rect.size.height - self.preDot);
        CGPathAddLineToPoint(path, NULL, rect.size.width/2, rect.size.height - self.startsDot);
        CGPathAddLineToPoint(path, NULL, rect.size.width/2, rect.size.height);
        CGPathAddLineToPoint(path, NULL, -rect.size.width/2, rect.size.height);
    } else {
        CGPathMoveToPoint(path, NULL, -rect.size.width/2, rect.size.height - self.preDot);
        CGPathAddLineToPoint(path, NULL, rect.size.width/2, rect.size.height - self.startsDot);
        CGPathAddLineToPoint(path, NULL, rect.size.width/2+rect.size.width, rect.size.height - self.endDot);
        CGPathAddLineToPoint(path, NULL, rect.size.width/2+rect.size.width, rect.size.height);
        CGPathAddLineToPoint(path, NULL, -rect.size.width/2, rect.size.height);
    }
    
    //绘制渐变
    [self drawLinearGradient:ref path:path startColor:UIColorFromRGB2(0x01c1f2, 0.4).CGColor endColor:UIColorFromRGB2(0x01c1f2, 0.0).CGColor];
//    CGPathCloseSubpath(path);
//    CGContextAddPath(ref, path);
    CFRelease(path);
//    CGContextSetLineWidth(ref, 0.5);
//    [[UIColor clearColor] setStroke];
//    CGContextStrokePath(ref);
}

#pragma mark 渐变阴影
- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                   endColor:(CGColorRef)endColor {

    if (!self.gradientLayer) {
        self.gradientLayer = [CAGradientLayer layer];
        [self.layer addSublayer:self.gradientLayer];
        [self bringSubviewToFront:self.dotView];
    }
    
    CGFloat height = MIN(self.preDot, self.startsDot);
    height = MIN(self.startsDot, self.endDot);
    
    self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.gradientLayer.colors = @[(__bridge id)startColor, (__bridge id)endColor];
    
    self.gradientLayer.locations=@[@0.0,@1.0];
    self.gradientLayer.startPoint = CGPointMake(0.0,0.0);
    self.gradientLayer.endPoint = CGPointMake(0.0,1);
    
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = path;
    self.gradientLayer.mask = arc;
}

//虚线
- (void)setupDotLines {
    if (!_dotShapeLayer) {
        _dotShapeLayer = [CAShapeLayer layer];
//        [_dotShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        // 设置虚线颜色为blackColor
        [_dotShapeLayer setStrokeColor:UIColorFromRGB2(0xd8d8d8, 1).CGColor];
        // 3.0f设置虚线的宽度
        [_dotShapeLayer setLineWidth:0.5f];
        [_dotShapeLayer setLineJoin:kCALineJoinRound];
        // 1=线的宽度 1=每条线的间距
        [_dotShapeLayer setLineDashPattern:
         [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
          [NSNumber numberWithInt:1],nil]];
        
        [[self layer] addSublayer:_dotShapeLayer];
    }
    _dotShapeLayer.frame = self.bounds;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat startX = 0;
    CGFloat endX = self.frame.size.width;
//    if (self.preDot == -1) {
//        startX = self.frame.size.width/2;
//    } else if (self.endDot == -1) {
//        endX = self.frame.size.width/2;
//    }
    CGPathMoveToPoint(path, NULL, startX, self.frame.size.height/2);
    CGPathAddLineToPoint(path, NULL, endX, self.frame.size.height/2);
    
    [_dotShapeLayer setPath:path];
    CGPathRelease(path);
}

//设置折线和圆点
- (void)setStartsDot:(CGFloat)startsDot endDot:(CGFloat)endDot preDot:(CGFloat)preDot {
    self.startsDot = startsDot;
    self.endDot = endDot;
    self.preDot = preDot;
    
    [self setupDotLines];
    
    _dotView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.startsDot);
    CGPoint point = _dotView.center;
    _detailView.center = CGPointMake(point.x, point.y-6-30);
    CGRect rect = [self convertRect:_detailView.frame toView:self.superview];
    _detailView.frame = rect;
    NSString *str = [NSString stringWithFormat:@"%@kg %@", @"22", @"2022/8/8"];
    [_detailView setTitle:str forState:UIControlStateNormal];
    
    [self setNeedsDisplay];
    
//    [self bringSubviewToFront:_detailView];
}

- (void)dotViewLick:(UITapGestureRecognizer *)tap {
    if (self.detailView) {
        return;
    }
    CGPoint point = CGPointMake(CGRectGetMidX(tap.view.frame), CGRectGetMidY(tap.view.frame));
    _detailView = [[LineGraphDetailView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    NSString *str = [NSString stringWithFormat:@"%@kg %@", @"22", @"2022/8/8"];
    [_detailView setTitle:str forState:UIControlStateNormal];
    _detailView.center = CGPointMake(point.x, point.y-6-30);
//    [self addSubview:_detailView];
    CGRect rect = [self convertRect:_detailView.frame toView:self.superview];
    _detailView.frame = rect;
    [self.superview addSubview:_detailView];
    
    [_dotView setSelectColorWithSelect:YES];
    _showTip = YES;
    
    [self setNeedsDisplay];
    
    !self.popUpDetailViewBlock ?: self.popUpDetailViewBlock(_detailView);
}

- (void)removeDetailView {
    [self.detailView removeFromSuperview];
    self.detailView = nil;
    [_dotView setSelectColorWithSelect:NO];
    _showTip = NO;
    [self setNeedsDisplay];
}

- (void)setShowTip:(BOOL)showTip {
    _showTip = showTip;
    
    [_dotView setSelectColorWithSelect:showTip];
    if (_showTip) {
        if (_detailView.superview) {
            return;
        }
        
        _detailView = [[LineGraphDetailView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        [self.superview addSubview:_detailView];
    } else {
        [self removeDetailView];
    }
}

@end





@interface UICollectionHeaderView ()

@property (nonatomic, strong) CAShapeLayer *dotShapeLayer;

@end

@implementation UICollectionHeaderView

- (void)drawRect:(CGRect)rect {
    if (rect.size.width == 0) {
        return;
    }
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, rect.size.width, 0);
    CGPathAddLineToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, 0, rect.size.height);
    CGPathAddLineToPoint(path, NULL, rect.size.width, rect.size.height);
    CGContextAddPath(ref, path);
    CFRelease(path);
    CGContextSetLineWidth(ref, 0.5);
    [UIColorFromRGB2(0xd8d8d8, 1) setStroke];
    CGContextStrokePath(ref);
    
    [self setupDotLines];
}

//虚线
- (void)setupDotLines {
    if (!_dotShapeLayer) {
        _dotShapeLayer = [CAShapeLayer layer];
        //        [_dotShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        // 设置虚线颜色为blackColor
        [_dotShapeLayer setStrokeColor:UIColorFromRGB2(0xd8d8d8, 1).CGColor];
        // 3.0f设置虚线的宽度
        [_dotShapeLayer setLineWidth:0.5f];
        [_dotShapeLayer setLineJoin:kCALineJoinRound];
        // 1=线的宽度 1=每条线的间距
        [_dotShapeLayer setLineDashPattern:
         [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
          [NSNumber numberWithInt:1],nil]];
        
        [[self layer] addSublayer:_dotShapeLayer];
    }
    _dotShapeLayer.frame = self.bounds;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat startX = 0;
    CGFloat endX = self.frame.size.width;
    //    if (self.preDot == -1) {
    //        startX = self.frame.size.width/2;
    //    } else if (self.endDot == -1) {
    //        endX = self.frame.size.width/2;
    //    }
    CGPathMoveToPoint(path, NULL, startX, self.frame.size.height/2);
    CGPathAddLineToPoint(path, NULL, endX, self.frame.size.height/2);
    
    [_dotShapeLayer setPath:path];
    CGPathRelease(path);
}

@end


