//
//  ViewController.m
//  LineGraph
//
//  Created by Mr.wu on 2017/11/19.
//  Copyright © 2017年 ZR. All rights reserved.
//

#import "ViewController.h"
#import "LineGraphView.h"
#import "BodyWeightModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LineGraphView *view = [[LineGraphView alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 200)];
    [self.view addSubview:view];
    
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        BodyWeightModel *model = [[BodyWeightModel alloc] init];
        model.measuredWeight = [NSString stringWithFormat:@"%zd", arc4random()%50+50];
        [arr addObject:model];
    }
    view.bodyWeights = arr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
