//
//  TopMenuView.h
//  WB+BDJ+ZQ
//
//  Created by XGJ on 16/8/29.
//  Copyright © 2016年 XGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - data source protocol
@class NewDrawRectChart;

@protocol TopMenuDataSource <NSObject>

@required


/**
 * 获取数据
 */
-(NSArray *)setDataSourceLetf;


@end
@interface TopMenuView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) id <TopMenuDataSource> MenudataSource;

- (void)setTitleArrays:(NSArray *)Titlearray;

@end
