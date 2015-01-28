//
//  JHWaterfallFlowViewCell.m
//  JHWatefallFlow(瀑布流)
//
//  Created by 金 on 15/1/26.
//  Copyright (c) 2015年 jinhua. All rights reserved.
//

#import "JHWaterfallFlowViewCell.h"

@implementation JHWaterfallFlowViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 50)];
        label.text = @"JH瀑布流";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _lable = label;
    }
    return self;
}

-(void)layoutSubviews{
    _lable.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

@end
