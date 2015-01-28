//
//  JHWaterfallFlowView.m
//  JHWatefallFlow(瀑布流)
//
//  Created by 金 on 15/1/26.
//  Copyright (c) 2015年 jinhua. All rights reserved.
//

#import "JHWaterfallFlowView.h"

#define JHWaterfallFlowViewDefaultNumberOfColumns 3 //默认列数
#define JHWaterfallFlowViewDefaulHeightOfCell 100 //默认高度
#define JHWaterfallFlowViewDefaultMargin 10 //默认间距


@interface JHWaterfallFlowView()

@property (nonatomic,strong)NSMutableArray* cellFrames;//所有cell的frame数据

@property (nonatomic,strong)NSMutableDictionary* displayingCells;//正在展示的cell

@property (nonatomic,strong)NSMutableSet* resusableCells;//cell缓存池

@end


@implementation JHWaterfallFlowView


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(void)willMoveToSuperview:(UIView *)newSuperview{
    [self reloatData];
}

-(NSMutableArray*)cellFrames{
    if (_cellFrames == nil) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

-(NSMutableDictionary*)displayingCells{
    if (_displayingCells == nil) {
        _displayingCells = [[NSMutableDictionary alloc]init];
    }
    return _displayingCells;
}

-(NSMutableSet*)resusableCells{
    if (_resusableCells == nil) {
        _resusableCells = [[NSMutableSet alloc]init];
    }
    return _resusableCells;
}


/**
 *  刷新
 *  1.计算cell的frame
 */
-(void)reloatData{
    
    //cell总个数
    int numberOfCells = (int)[self.dataSource numberOfCellsInWaterfallFlowView:self];
    
    //cell总列数
    int numberOfColumns = (int)[self numberOfColumns];
    
    //间距
    CGFloat leftMargin = [self marginForType:JHWaterfallFlowViewMarginTypeLeft];
    CGFloat rightMargin = [self marginForType:JHWaterfallFlowViewMarginTypeRight];
    CGFloat topMargin = [self marginForType:JHWaterfallFlowViewMarginTypeTop];
    CGFloat bottomMargin = [self marginForType:JHWaterfallFlowViewMarginTypeBottom];
    CGFloat rowMargin = [self marginForType:JHWaterfallFlowViewMarginTypeRow];
    CGFloat columnMargin = [self marginForType:JHWaterfallFlowViewMarginTypeColumn];

    
    //*********  1.cell 的宽度  ***********
    //cell的宽度 = (self.view.width - 左间距 - 右间距 - 列间距×(列数-1)) / 总列数
    CGFloat cellWidth = (self.frame.size.width - leftMargin - rightMargin - (numberOfColumns - 1)* columnMargin)/numberOfColumns;
    
    //c数组：存放所有列最大Y值
    CGFloat maxYOfColumns[numberOfColumns];
    for (int i = 0; i< numberOfColumns; i++) {
        maxYOfColumns[i] = 0.0;
    }
    
    //cell的frame
    for (int i = 0; i<numberOfCells; i++) {
        
        //*********  2.cell 的高度  ***********
        CGFloat cellHeight = [self heightAtIndex:i];
        
        //cell所在列
        
        NSInteger columnOfCell = 0;
        
        //cell所在列最大的Y值
        CGFloat maxYOfCellAtColumn = maxYOfColumns[columnOfCell];
        
        //取最短的一列为当前列,最短一列最大Y值为当前列最大Y值
        for (int j = 0; j < numberOfColumns; j++) {
            if (maxYOfColumns[j] < maxYOfCellAtColumn) {
                columnOfCell = j;
                maxYOfCellAtColumn = maxYOfColumns[j];
            }
        }
        
        //*********  3.cell 的坐标  ***********
        //cell.x = 左边间距 + 所在列×(cell的宽度+列间距)
        CGFloat cellX = leftMargin + columnOfCell*(cellWidth+columnMargin);
        
        //cell.Y初始为0
        CGFloat cellY = 0;
        
        //首行
        if (maxYOfCellAtColumn == 0.0) {
            cellY = topMargin;
        }
        else{
            cellY = maxYOfCellAtColumn+rowMargin;
        }
        
        //*********  4.设置cell的frame ***********
        CGRect frameOfCell = CGRectMake(cellX, cellY, cellWidth, cellHeight);
        [self.cellFrames addObject:[NSValue valueWithCGRect:frameOfCell]];
        
        //更新当前列的最大Y值
        maxYOfColumns[columnOfCell] = CGRectGetMaxY(frameOfCell);
        
        //显示cell
//        JHWaterfallFlowViewCell* cell = [self.dataSource waterfallFlowView:self cellAtIndex:i];
//        cell.frame = frameOfCell;
//        [self addSubview:cell];

    }
    
    //更新scrollview的contentsize
    CGFloat contentHeight = maxYOfColumns[0];
    
    for (int i = 0; i < numberOfColumns; i++) {
        if (maxYOfColumns[i] > contentHeight) {
            contentHeight = maxYOfColumns[i];
        }
    }
    
    contentHeight += bottomMargin;
    self.contentSize = CGSizeMake(0, contentHeight);
    
    
}



-(NSInteger)numberOfColumns{
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterfallFlowView:)]) {
        return [self.dataSource numberOfColumnsInWaterfallFlowView:self];
    }
    return JHWaterfallFlowViewDefaultNumberOfColumns;
}


-(CGFloat)marginForType:(JHWaterfallFlowViewMarginType)marginType{
    if ([self.delegate respondsToSelector:@selector(waterfallFlowView:marginOfType:)]) {
        return [self.delegate waterfallFlowView:self marginOfType:marginType];
    }
    return JHWaterfallFlowViewDefaultMargin;
}

-(CGFloat)heightAtIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(waterfallFlowView:heightOfCellAtIndex:)]) {
        return [self.delegate waterfallFlowView:self heightOfCellAtIndex:index];
    }
    return JHWaterfallFlowViewDefaulHeightOfCell;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    int numberOfCells = (int)self.cellFrames.count;
    
    for (int i = 0 ; i < numberOfCells; i++) {
        
        CGRect frameOfCell = [self.cellFrames[i] CGRectValue];
        
        //从字典中取出
        JHWaterfallFlowViewCell* cell = self.displayingCells[@(i)];
        
        
        //在屏幕上
        if ([self isInScreen:frameOfCell]) {
            
            if (cell == nil) {
                cell = [self.dataSource waterfallFlowView:self cellAtIndex:i];
                cell.frame = frameOfCell;
                [self addSubview:cell];
                
                //放在字典中
                self.displayingCells[@(i)] = cell;
            }
            

        }
        
        //不在屏幕上
        else{
            if (cell) {
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                
                //加入缓存池
                [self.resusableCells addObject:cell];
            }
            
        }
        
    }
    
    NSLog(@"cell个数是----%lu",(unsigned long)self.subviews.count);
}

//判断cell是否在屏幕上
-(BOOL)isInScreen:(CGRect)frame{
    return (CGRectGetMaxY(frame)>self.contentOffset.y)&&(CGRectGetMinY(frame)<self.contentOffset.y+self.frame.size.height);
}

-(id)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    __block JHWaterfallFlowViewCell* reusableCell = nil;
    
    [self.resusableCells enumerateObjectsUsingBlock:^(JHWaterfallFlowViewCell* cell, BOOL *stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            reusableCell = cell;
            *stop = YES;
        }
    }];
    
    if (reusableCell) {
        //从缓存池中移除
        [self.resusableCells removeObject:reusableCell];
    }
    return reusableCell;
}


//点击事件处理
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (![self.delegate respondsToSelector:@selector(waterfallFlowView:didSelectCellAtIndex:)]) {
        return;
    }
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    __block NSNumber* selectedIndex = nil;
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(id key, JHWaterfallFlowViewCell* cell, BOOL *stop) {
        if (CGRectContainsPoint(cell.frame, point)) {
            selectedIndex = key;
            *stop = YES;
        }
    }];
    
    if (selectedIndex) {
        [self.delegate waterfallFlowView:self didSelectCellAtIndex:selectedIndex.unsignedIntegerValue];
    }
    
}

@end





