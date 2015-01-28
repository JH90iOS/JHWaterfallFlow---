//
//  JHWaterfallFlowView.h
//  JHWatefallFlow(瀑布流)
//
//  Created by 金 on 15/1/26.
//  Copyright (c) 2015年 jinhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHWaterfallFlowViewCell.h"

typedef enum {
    JHWaterfallFlowViewMarginTypeTop,
    JHWaterfallFlowViewMarginTypeBottom,
    JHWaterfallFlowViewMarginTypeLeft,
    JHWaterfallFlowViewMarginTypeRight,
    JHWaterfallFlowViewMarginTypeColumn,
    JHWaterfallFlowViewMarginTypeRow,
}JHWaterfallFlowViewMarginType;

@class JHWaterfallFlowViewCell,JHWaterfallFlowView;



/**
 *  1.DataSource
 */
@protocol JHWaterfallFlowViewDataSource <NSObject>

@required
//1.1 cell个数
-(NSInteger)numberOfCellsInWaterfallFlowView:(JHWaterfallFlowView*)waterfallFlowView;
//1.2 返回index对应cell
-(JHWaterfallFlowViewCell*)waterfallFlowView:(JHWaterfallFlowView*)waterfallFlowView cellAtIndex:(NSInteger)index;
@optional
//1.3 有多少列
-(NSInteger)numberOfColumnsInWaterfallFlowView:(JHWaterfallFlowView*)waterfallFlowView;

@end


/**
 *  2.Delegate
 */

@protocol JHWaterfallFlowViewDelegate <UIScrollViewDelegate>

@optional
//2.1 cell高度
-(CGFloat)waterfallFlowView:(JHWaterfallFlowView*)waterfallFlowView heightOfCellAtIndex:(NSInteger)index;
//2.2 选中cell
-(void)waterfallFlowView:(JHWaterfallFlowView*)waterfallFlowView didSelectCellAtIndex:(NSInteger)index;
//2.3 间距
-(CGFloat)waterfallFlowView:(JHWaterfallFlowView*)waterfallFlowView marginOfType:(JHWaterfallFlowViewMarginType)marginType;

@end




@interface JHWaterfallFlowView : UIScrollView

@property (nonatomic,weak)id<JHWaterfallFlowViewDataSource> dataSource;

@property (nonatomic,weak)id<JHWaterfallFlowViewDelegate> delegate;

-(void)reloatData;

//根据标识从缓存池中找cell
-(id)dequeueReusableCellWithIdentifier:(NSString*)identifier;

@end
