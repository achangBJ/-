//
//  TopMenuView.h
//  WB+BDJ+ZQ
//
//  Created by XGJ on 16/8/29.
//  Copyright © 2016年 XGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - data source protocol
@class TopMenuView;

@protocol TopMenuDataSource <NSObject>

@required


/**
 * 获取数据
 */
-(NSArray *)setDataSourceLetf;


@end


@protocol TopMenuDelegate<NSObject>

@optional
/**
 *  选择
 *
 *  @param leftrow      左边第几条数据
 *  @param selectcenter 是否选择中间
 *  @param centerrow    中间第几条数据
 *  @param selectright  是否选择右边
 *  @param rightrow     右边第几条数据
 */
-(void)selectLeftrow:(NSInteger)leftrow selectcenter:(BOOL)selectcenter selectcenterrow:(NSInteger)centerrow selectright:(BOOL)selectright selectrightrow:(NSInteger)rightrow;


@end


@interface TopMenuView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) id <TopMenuDataSource> MenudataSource;
@property (nonatomic, weak) id <TopMenuDelegate> Menudatadelegat;


- (void)setTitleArrays:(NSArray *)Titlearray;

@end
