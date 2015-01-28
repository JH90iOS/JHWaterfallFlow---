//
//  ViewController.m
//  JHWatefallFlow(瀑布流)
//
//  Created by 金 on 15/1/26.
//  Copyright (c) 2015年 jinhua. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<JHWaterfallFlowViewDataSource,JHWaterfallFlowViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JHWaterfallFlowView* flowView = [[JHWaterfallFlowView alloc]init];
    flowView.frame = self.view.bounds;
    flowView.delegate = self;
    flowView.dataSource = self;
    [self.view addSubview:flowView];
    
}

/**
 *  datasource
 */
-(NSInteger)numberOfCellsInWaterfallFlowView:(JHWaterfallFlowView*)waterfallFlowView{
    return 1000;
}


-(NSInteger)numberOfColumnsInWaterfallFlowView:(JHWaterfallFlowView *)waterfallFlowView{
    return 2;
}


-(JHWaterfallFlowViewCell*)waterfallFlowView:(JHWaterfallFlowView *)waterfallFlowView cellAtIndex:(NSInteger)index{
    static NSString* identifier = @"cell";
    JHWaterfallFlowViewCell* cell = [waterfallFlowView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[JHWaterfallFlowViewCell alloc]init];
        cell.identifier = identifier;
        cell.backgroundColor = JHRandomColor;
    }
    
    return cell;
}



/**
 *  delegate
 */

-(CGFloat)waterfallFlowView:(JHWaterfallFlowView *)waterfallFlowView heightOfCellAtIndex:(NSInteger)index{
    switch (index%3) {
        case 0:
            return 60;
        case 1:
            return 120;
        case 2:
            return 100;
        default:
            return 160;
    }
}

-(CGFloat)waterfallFlowView:(JHWaterfallFlowView *)waterfallFlowView marginOfType:(JHWaterfallFlowViewMarginType)marginType{
    switch (marginType) {
        case JHWaterfallFlowViewMarginTypeTop:
        case JHWaterfallFlowViewMarginTypeBottom:
        case JHWaterfallFlowViewMarginTypeLeft:
        case JHWaterfallFlowViewMarginTypeRight:
            return 10;
        case JHWaterfallFlowViewMarginTypeColumn:
        case JHWaterfallFlowViewMarginTypeRow:
            return 10;
    }
}

-(void)waterfallFlowView:(JHWaterfallFlowView *)waterfallFlowView didSelectCellAtIndex:(NSInteger)index{
    NSLog(@"---click---%d---cell",(int)index);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
