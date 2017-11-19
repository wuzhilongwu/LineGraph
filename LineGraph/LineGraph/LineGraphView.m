//
//  LineGraphView.m
//  SmartHome
//
//  Created by wzl on 2017/5/31.
//  Copyright © 2017年 Huawei Device. All rights reserved.
//

#import "LineGraphView.h"
#import "LineGraphCell.h"

static CGFloat UICollectionViewCellWidth = 60;

@interface LineGraphView ()

@property (nonatomic, assign) NSInteger maxIntegerWeight;
@property (nonatomic, assign) NSInteger minIntegerWeight;

@property (nonatomic, strong) UILabel *maxLabel;
@property (nonatomic, strong) UILabel *midLabel;

@property (nonatomic, strong) NSMutableDictionary *showTipDic;

@end

@implementation LineGraphView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self loadCollectionView];
        
        _maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-100, 10, 100, 20)];
        _maxLabel.textColor = UIColorFromRGB2(0x000000, 0.5);
        _maxLabel.font = [UIFont systemFontOfSize:15];
        _maxLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_maxLabel];
        
        _midLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-100, frame.size.height/2+10, 100, 20)];
        _midLabel.textColor = UIColorFromRGB2(0x000000, 0.5);
        _midLabel.font = [UIFont systemFontOfSize:15];
        _midLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_midLabel];
        
        _showTipDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setBodyWeights:(NSArray *)bodyWeights {
    self.maxLabel.hidden = bodyWeights.count == 0;
    self.midLabel.hidden = bodyWeights.count == 0;
    
    [_showTipDic removeAllObjects];
    _bodyWeights = bodyWeights;
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
    BodyWeightModel *model = bodyWeights.firstObject;
    __block CGFloat maxWeight = model.measuredWeight.floatValue;
    __block CGFloat minWeight = model.measuredWeight.floatValue;
    [bodyWeights enumerateObjectsUsingBlock:^(BodyWeightModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.measuredWeight.floatValue > maxWeight) {
            maxWeight = obj.measuredWeight.floatValue;
        }
        if (obj.measuredWeight.floatValue < minWeight) {
            minWeight = obj.measuredWeight.floatValue;
        }
        
        [arr addObject:obj.measuredWeight];
    }];
    
    self.maxIntegerWeight = [self maxIntegerWeightWithWeight:maxWeight];
    self.minIntegerWeight = [self minIntegerWeightWithWeight:minWeight];
    self.maxLabel.text = [NSString stringWithFormat:@"%zdkg", self.maxIntegerWeight];
    self.midLabel.text = [NSString stringWithFormat:@"%zdkg", (self.maxIntegerWeight+self.minIntegerWeight)/2];
    
    NSMutableArray *p = [NSMutableArray arrayWithCapacity:10];
    [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value = obj.floatValue;
        value = value - self.minIntegerWeight;
        value = value/(self.maxIntegerWeight - self.minIntegerWeight) * self.frame.size.height;
        [p addObject:[NSString stringWithFormat:@"%f", value]];
    }];
    
    self.pointDatas = p;
}

- (void)setPointDatas:(NSArray *)pointDatas {
    _pointDatas = pointDatas;
    [self.collectionView reloadData];
}

- (void)setSelectIndx:(NSInteger)selectIndx {
    _selectIndx = selectIndx;
    [_showTipDic setObject:@(YES) forKey:[@(_selectIndx) stringValue]];
//    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selectIndx inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    [self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:0];
}

- (NSInteger)maxIntegerWeightWithWeight:(CGFloat)weight {
    NSInteger number = weight;
    NSInteger n = 1;
    while (number/10 != 0) {
        n++;
        number /= 10;
    }
    NSInteger m = pow(10, n-1);
    
    return (number + 1)*m;
}

- (NSInteger)minIntegerWeightWithWeight:(CGFloat)weight {
    NSInteger number = weight;
    NSInteger n = 1;
    while (number/10 != 0) {
        n++;
        number /= 10;
    }
    NSInteger m = pow(10, n-1);
    
    return (number - 1)*m;
}

- (void)loadCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.clipsToBounds = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[LineGraphCell class] forCellWithReuseIdentifier:@"reuseclass"];
    [self.collectionView registerClass:[UICollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    [self addSubview:_collectionView];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LineGraphCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseclass" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSNumber *start = self.pointDatas[indexPath.item];
    //没有前一个点和后一个点的值为-1
    NSNumber *end = @(-1);
    NSNumber *preDot = @(-1);
    if (indexPath.item != self.pointDatas.count-1) {
        end = self.pointDatas[indexPath.item+1];
    }
    if (indexPath.item > 0) {
        preDot = self.pointDatas[indexPath.item-1];
    }
    
    cell.model = self.bodyWeights[indexPath.item];
    cell.showTip = [self.showTipDic[[NSString stringWithFormat:@"%zd", indexPath.item]] boolValue];
    [cell setStartsDot:start.floatValue endDot:end.floatValue preDot:preDot.floatValue];
    
    //点击弹出气泡
    __weak typeof(self) weakSelf = self;
    [cell setPopUpDetailViewBlock:^(UIView *view) {
        [weakSelf.showTipDic setObject:@(YES) forKey:[NSString stringWithFormat:@"%zd", indexPath.item]];
    }];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pointDatas.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(UICollectionViewCellWidth, self.bounds.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, UICollectionViewCellWidth/2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LineGraphCell *cell = (LineGraphCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell removeDetailView];
    [self.showTipDic setObject:@(NO) forKey:[NSString stringWithFormat:@"%zd", indexPath.item]];
}

//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:@"UICollectionViewHeader"
                                                                                   forIndexPath:indexPath];
    headView.backgroundColor = [UIColor clearColor];
    
    return headView;
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(UICollectionViewCellWidth/2, self.bounds.size.height);
    }
    else {
        return CGSizeMake(0, 0);
    }
}

@end
