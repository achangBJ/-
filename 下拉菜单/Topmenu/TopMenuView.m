//
//  TopMenuView.m
//  WB+BDJ+ZQ
//
//  Created by XGJ on 16/8/29.
//  Copyright © 2016年 XGJ. All rights reserved.
//

#import "TopMenuView.h"
#import <UIKit/UIKit.h>
#define BackColor [UIColor colorWithWhite:0.933 alpha:1.000]
// 选中颜色加深
#define SelectColor [UIColor colorWithWhite:0.867 alpha:1.000]
#define SCREEN_SIZE ([UIScreen mainScreen].bounds.size)

#define BgViewHeight SCREEN_SIZE.height/2
#define ViewWidth SCREEN_SIZE.width/3

@interface TopMenuView ()
/**
 *  背景图层
 */
@property (nonatomic, strong) UIView *bottomShadow;
/**
 *  按钮上面文字
 */
@property (nonatomic, copy) NSArray *titles;
/**
 *  按钮上面箭头
 */
@property (nonatomic, copy) NSArray *indicators;
/**
 *  按钮图层
 */
@property (nonatomic, copy) NSArray *bgLayers;
/**
 *  显示tableview背景
 */
@property (nonatomic,strong)UIView *BgGroundView;

/**
 *  选择了那个顶部按钮
 */
@property (nonatomic,assign)NSInteger tapIndex;

/**
 *  左侧导航选择第几个
 */
@property (nonatomic,assign)NSInteger LeftIndex;
/**
 *  中间导航选择第几个
 */
@property (nonatomic,assign)NSInteger CenterIndex;

/**
 *  判断是否显示tableview；
 */
@property (nonatomic,assign)BOOL IsSelectCenterV;
@property (nonatomic,assign)BOOL IsSelectRightV;



/**
 *  三个试图
 */
@property (nonatomic,strong)UITableView *leftTableView;
@property (nonatomic,strong)UITableView *centerTableView;
@property (nonatomic,strong)UITableView *rightTableView;
@end









@implementation TopMenuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        _leftTableView=0;
        _CenterIndex =0;
        
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, 0) style:UITableViewStyleGrouped];
        _leftTableView.rowHeight = 38;
        _leftTableView.backgroundColor = [UIColor whiteColor];
        _leftTableView.separatorColor = [UIColor colorWithRed:220.f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:1.0];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        //        中
        _centerTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width/3,0, ViewWidth, 0) style:UITableViewStyleGrouped];
        _centerTableView.rowHeight = 38;
        _centerTableView.separatorColor = [UIColor colorWithRed:220.f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:1.0];
        _centerTableView.dataSource = self;
        _centerTableView.delegate = self;
        //        右
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width- (self.frame.size.width/3), 0, ViewWidth, 0) style:UITableViewStyleGrouped];
        _rightTableView.rowHeight = 38;
        _rightTableView.separatorColor = [UIColor colorWithRed:220.f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:1.0];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        
        //背景View
        _BgGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height+frame.origin.y, SCREEN_SIZE.width,SCREEN_SIZE.height)];
        _BgGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _BgGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_BgGroundView addGestureRecognizer:gesture];
        //view添加点击方法
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tapGesture];
        //底部线
        _bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_SIZE.width, 0.5)];
        [self addSubview:_bottomShadow];
        
        
        
        
    }
    return self;
}
//view点击方法
- (void)menuTapped:(UITapGestureRecognizer *)paramSender {
    CGPoint touchPoint = [paramSender locationInView:self];
    //calculate index
    //判断选择区域
    _tapIndex = touchPoint.x / (self.frame.size.width / 3);
    for (int i = 0; i < 3; i++) {
        if (i != _tapIndex) {
            //如果不是当前选择的按钮⬆️变成⬇️
            [self animateIndicator:_indicators[i] Forward:NO complete:^{
            }];
            //背景色变成普通
            [(CALayer *)self.bgLayers[i] setBackgroundColor:BackColor.CGColor];
        }
    }
    [self isSelectCRV];
    [self animateIdicator:_indicators[_tapIndex] background:_BgGroundView leftTableView:_leftTableView centerTableview:_centerTableView rightTableView:_rightTableView forward:YES complecte:^{
        
    }];
    [(CALayer *)self.bgLayers[_tapIndex] setBackgroundColor:SelectColor.CGColor];
}
#pragma mark   这里判断下一级菜单是否有数据
#warning  该数据源这里也要同步
-(void)isSelectCRV{
    if ([[_MenudataSource setDataSourceLetf][_tapIndex][_LeftIndex][@"urban"] count]>0) {
        _IsSelectCenterV = YES;
        if ([[_MenudataSource setDataSourceLetf][_tapIndex][_LeftIndex][@"urban"][_CenterIndex][@"county"] count]>0) {
            _IsSelectRightV = YES;
        }
        else{
            _IsSelectRightV = NO;
        }
    }
    else{
        _IsSelectCenterV = NO;
        _IsSelectRightV = NO;
    }
}



//
/**
 *  展开View
 *
 *  @param indicator      选中的小箭头
 *  @param background     背景View
 *  @param title          按钮文字
 *  @param forward        状态
 *  @param complete       动画效果
 */
- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background leftTableView:(UITableView *)leftTableView centerTableview:(UITableView *)centerTableview rightTableView:(UITableView *)rightTableView forward:(BOOL)forward complecte:(void(^)())complete{
    
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateBackGroundView:background show:forward complete:^{
            centerTableview.hidden = YES;
            rightTableView.hidden = YES;
            CGFloat Vwidth=self.frame.size.width;
            if (_IsSelectCenterV) {
                Vwidth = self.frame.size.width/2;
                centerTableview.hidden = NO;
                if (_IsSelectRightV) {
                    Vwidth = self.frame.size.width/3;
                    rightTableView.hidden = NO;
                }
            }
            leftTableView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, Vwidth, 0);
            if (_IsSelectCenterV) {
                centerTableview.frame = CGRectMake(self.frame.origin.x+leftTableView.bounds.size.width, self.frame.origin.y + self.frame.size.height,Vwidth, 0);
                [self.superview addSubview:centerTableview];
                
            }
            if (_IsSelectRightV) {
                rightTableView.frame = CGRectMake(self.frame.size.width-leftTableView.bounds.size.width, self.frame.origin.y+ self.frame.size.height, Vwidth, 0);
                [self.superview addSubview:rightTableView];
                
            }
            [self.superview addSubview:leftTableView];
            [leftTableView reloadData];
            [centerTableview reloadData];
            [rightTableView reloadData];
            [UIView animateWithDuration:0.2 animations:^{
                if (leftTableView) {
                    leftTableView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, Vwidth,BgViewHeight);
                }
                if (centerTableview) {
                    if (_IsSelectCenterV) {
                        centerTableview.frame = CGRectMake(self.frame.origin.x+leftTableView.bounds.size.width-1, self.frame.origin.y + self.frame.size.height, Vwidth+1,BgViewHeight);
                    }
                }
                if (rightTableView) {
                    if (_IsSelectRightV) {
                        
                        rightTableView.frame = CGRectMake(self.frame.size.width-leftTableView.bounds.size.width, self.frame.origin.y + self.frame.size.height,Vwidth,BgViewHeight);
                    }
                }
            }];
            [leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行
            if (_IsSelectCenterV) {
                [self tableView:leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];//实现点击第一行所调用的方法
            }
            
        }];
        
    }];
    
    complete();
}




/**
 *  背景View动画
 *
 *  @param view     背景View
 *  @param show     是否展开
 */
- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}
/**
 *  背景按钮
 *  关闭
 */
- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    
    [self animateIdicator:_indicators[_tapIndex] background:_BgGroundView leftTableView:_leftTableView centerTableView:_centerTableView rightTableView:_rightTableView forward:NO complecte:^{
        
    }];
    [(CALayer *)self.bgLayers[_tapIndex] setBackgroundColor:BackColor.CGColor];
}
/**
 *  关闭View
 *
 *  @param indicator      选中的小箭头
 *  @param background     背景View
 *  @param title          按钮文字
 *  @param forward        状态
 *  @param complete       动画效果
 */
- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background leftTableView:(UITableView *)leftTableView centerTableView:(UITableView *)centerTableView rightTableView:(UITableView *)rightTableView forward:(BOOL)forward complecte:(void(^)())complete{
    
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateBackGroundView:background show:forward complete:^{
            [UIView animateWithDuration:0.2 animations:^{
                CGFloat Vwidth=self.frame.size.width;
                if (_IsSelectCenterV) {
                    Vwidth = self.frame.size.width/2;
                    if (_IsSelectRightV) {
                        Vwidth = self.frame.size.width/3;
                    }
                }
                if (leftTableView) {
                    leftTableView.frame = CGRectMake(0, self.frame.origin.y+50, Vwidth, 0);
                }
                if (centerTableView) {
                    if (_IsSelectCenterV) {
                        centerTableView.frame = CGRectMake(self.frame.origin.x+leftTableView.bounds.size.width, self.frame.origin.y+50, Vwidth, 0);
                    }
                }
                if (rightTableView) {
                    if (_IsSelectRightV) {
                        rightTableView.frame = CGRectMake(self.frame.size.width-leftTableView.bounds.size.width, self.frame.origin.y+50,Vwidth, 0);
                    }
                }
            } completion:^(BOOL finished) {
                
                if (leftTableView) {
                    [leftTableView removeFromSuperview];
                }
                if (centerTableView) {
                    [centerTableView removeFromSuperview];
                }
                if (rightTableView) {
                    [rightTableView removeFromSuperview];
                }
            }];
        }];
    }];
    complete();
}




//箭头旋转
#pragma mark - animation method
/**
 *  箭头旋转
 *  @param indicator 那个箭头
 *  @param forward   向上向下
 */
- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    [CATransaction commit];
    
    complete();
}


#pragma mark - setter
//初始化选项文字背景图层
- (void)setTitleArrays:(NSArray *)Titlearray {
    //    _dataSource = dataSource;
    //    NSArray *_Titlearray = Titlearray;
    
    CGFloat textLayerInterval = self.frame.size.width / ( 3 * 2);
    
    CGFloat separatorLineInterval = self.frame.size.width / 3;
    
    CGFloat bgLayerInterval = self.frame.size.width / 3;
    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:3];
    
    for (int i = 0; i < 3; i++) {
        //bgLayer
        //背景图层
        CGPoint bgLayerPosition = CGPointMake((i+0.5)*bgLayerInterval, self.frame.size.height/2);
        CALayer *bgLayer = [self createBgLayerWithColor:BackColor andPosition:bgLayerPosition];
        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        //title
        //顶部文字
        CGPoint titlePosition = CGPointMake( (i * 2 + 1) * textLayerInterval , self.frame.size.height / 2);
        NSString *titleString = [Titlearray objectAtIndex:i];
        CATextLayer *title = [self createTextLayerWithNSString:titleString withColor:[UIColor colorWithWhite:0.196 alpha:1.000] andPosition:titlePosition];
        [self.layer addSublayer:title];
        [tempTitles addObject:title];
        //indicator
        //小箭头
        CAShapeLayer *indicator = [self createIndicatorWithColor:[UIColor colorWithWhite:0.529 alpha:1.000] andPosition:CGPointMake(titlePosition.x + title.bounds.size.width / 2 + 8, self.frame.size.height / 2)];
        [self.layer addSublayer:indicator];
        [tempIndicators addObject:indicator];
        
        //separator
        //右侧竖线
        if (i != 3 - 1) {
            CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, self.frame.size.height/2);
            CAShapeLayer *separator = [self createSeparatorLineWithColor:[UIColor colorWithWhite:0.843 alpha:1.000] andPosition:separatorPosition];
            [self.layer addSublayer:separator];
        }
    }
    
    _bottomShadow.backgroundColor = [UIColor colorWithWhite:0.773 alpha:1.000];
    
    _titles = [tempTitles copy];
    _indicators = [tempIndicators copy];
    _bgLayers = [tempBgLayers copy];
}

#pragma mark - init support
//背景图层
- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width/3, self.frame.size.height-1);
    layer.backgroundColor = color.CGColor;
    
    return layer;
}
//画小箭头
- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;
    
    return layer;
}
//画竖线
- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, self.frame.size.height)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;
    
    return layer;
}
//添加到图层上面文字
- (CATextLayer *)createTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point {
    
    CGSize size = [self calculateTitleSizeWithString:string];
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / 3) - 25) ? size.width : self.frame.size.width / 3 - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 14.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.position = point;
    
    return layer;
}
//返回文字SIZE
- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    CGFloat fontSize = 14.0;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}




#pragma mark - table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_leftTableView==tableView) {
        return [[_MenudataSource setDataSourceLetf][_tapIndex] count];
    }
    if (_centerTableView==tableView) {
        if (_IsSelectCenterV) {
            
            return [[_MenudataSource setDataSourceLetf][_tapIndex][_LeftIndex][@"urban"] count];
        }
        else{
            return 0;
        }
    }
    if (_rightTableView==tableView) {
        if (_IsSelectCenterV&&_IsSelectRightV) {
            return [[_MenudataSource setDataSourceLetf][_tapIndex][_LeftIndex][@"urban"][_CenterIndex][@"county"] count];
        }
        else{
            return 0;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DropDownMenuCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = BackColor;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.tag = 1;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    //    cell.textLabel.text = @"12345";
    
    
    NSInteger leftOrRight = 0;
    if (_leftTableView==tableView) {
        cell.textLabel.text = [_MenudataSource setDataSourceLetf][_tapIndex][indexPath.row][@"city"];
        leftOrRight = 1;
        if (!_IsSelectCenterV&&!_IsSelectRightV) {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor greenColor];
    }else if (_centerTableView==tableView){
        cell.textLabel.text = [_MenudataSource setDataSourceLetf][_tapIndex][_LeftIndex][@"urban"][indexPath.row][@"urban"];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor brownColor];
    }else if (_rightTableView==tableView){
        cell.textLabel.text = [_MenudataSource setDataSourceLetf][_tapIndex][_LeftIndex][@"urban"][_CenterIndex][@"county"][indexPath.row][@"county"];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor blueColor];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if(_leftTableView == tableView)
    {
        _LeftIndex =indexPath.row;
        //        判断当前显示几个tableview 相应的处理
        if (!_IsSelectCenterV&&!_IsSelectRightV) {
            //            选中数据处理
            [self confiMenuWithSelectRow:indexPath.row leftOrRight:0 centerorRight:0];
        }
        
        if (_IsSelectCenterV&&!_IsSelectRightV) {
            [_centerTableView reloadData];
            [_centerTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行
        }
        
        if (_IsSelectCenterV&&_IsSelectRightV) {
            [_centerTableView reloadData];
            [self tableView:_centerTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];//实现点击第一行所调用的方法
            [_centerTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行
        }
        
    }
    else if (_centerTableView==tableView){
        _CenterIndex =indexPath.row;
        if (_IsSelectRightV) {
            [_rightTableView reloadData];
            [_rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行
        }else{
            [self confiMenuWithSelectRow:indexPath.row leftOrRight:_LeftIndex centerorRight:0];
        }
    }
    else if(_rightTableView==tableView){
        
        [self confiMenuWithSelectRow:indexPath.row leftOrRight:_LeftIndex centerorRight:_CenterIndex];
        
    }
    
}

- (void)confiMenuWithSelectRow:(NSInteger)row leftOrRight:(NSInteger)leftOrRight centerorRight:(NSInteger)centerorRight{
    [_Menudatadelegat selectLeftrow:leftOrRight selectcenter:_IsSelectCenterV selectcenterrow:centerorRight selectright:_IsSelectRightV selectrightrow:row];
    CATextLayer *title = (CATextLayer *)_titles[_tapIndex];
    title.string = [self getTstrSelectRow:row leftOrRight:leftOrRight centerorRight:centerorRight];
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / 3) - 25) ? size.width : self.frame.size.width / 3 - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    [self animateIdicator:_indicators[_tapIndex] background:_BgGroundView leftTableView:_leftTableView centerTableView:_centerTableView rightTableView:_rightTableView forward:NO complecte:^{
        
    }];
    [(CALayer *)self.bgLayers[_tapIndex] setBackgroundColor:BackColor.CGColor];
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_tapIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 8, indicator.position.y);
}
-(NSString *)getTstrSelectRow:(NSInteger)row leftOrRight:(NSInteger)leftOrRight centerorRight:(NSInteger)centerorRight
{
    NSString *str;
    if (_IsSelectCenterV&&_IsSelectRightV) {
        str = [_MenudataSource setDataSourceLetf][_tapIndex][leftOrRight][@"urban"][centerorRight][@"county"][row][@"county"];
    }else if (_IsSelectCenterV&&!_IsSelectRightV)
    {
        str = [_MenudataSource setDataSourceLetf][_tapIndex][leftOrRight][@"urban"][row][@"urban"];
        
    }else if (!_IsSelectCenterV&&!_IsSelectRightV)
    {
        str = [_MenudataSource setDataSourceLetf][_tapIndex][row][@"city"];
        
    }
    return str;
}


@end
