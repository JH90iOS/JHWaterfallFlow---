//
//  ViewController.h
//  JHWatefallFlow(瀑布流)
//
//  Created by 金 on 15/1/26.
//  Copyright (c) 2015年 jinhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWaterfallFlowView.h"

@interface ViewController : UIViewController

// 颜色
#define JHColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define JHColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define JHRandomColor JHColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@end

