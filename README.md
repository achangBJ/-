# -
drop-down menu
创建下拉菜单
  TopMenuView *toPmenu = [[TopMenuView alloc]initWithFrame:CGRectMake(0, 80, SCREEN_SIZE.width, 50)];
    toPmenu.MenudataSource = self;
    toPmenu.Menudatadelegat = self;
    [toPmenu setTitleArrays:@[@"区域",@"公司",@"职务"]];
    [self.view addSubview:toPmenu];
    #pragma mark -----menudatasource
-(NSArray *)setDataSourceLetf{
    return @[
             //             第一个
             @[
                 
                 @{@"city":@"北京",
                   @"urban":@[
                           @{@"urban":@"昌平",
                             @"county":@[
                                     @{@"county":@"十三陵"},
                                     @{@"county":@"南口"},
                                     @{@"county":@"崔村"}
                                     ]
                             },
                           @{
                               @"urban":@"海淀",
                               @"county":@[
                                       @{@"county":@"五道口"},
                                       @{@"county":@"前八家"},
                                       @{@"county":@"中关村"}
                                       ]
                               }
                           ]
                   },
                 @{@"city":@"上海",
                   @"urban":@[
                           @{@"urban":@"浦东",
                             @"county":@[
                                     @{@"county":@"浦东1"},
                                     @{@"county":@"浦东2"},
                                     @{@"county":@"浦东3"}
                                     ]
                             },
                           @{
                               @"urban":@"不知道",
                               @"county":@[
                                       @{@"county":@"浦东4"},
                                       @{@"county":@"浦东5"},
                                       @{@"county":@"中关村2"}
                                       ]
                               }
                           ]
                   }
                 //                     第一个数组结束括号
                 ],
             //             第二个数组开始
             @[
                 @{@"city":@"北京公司",
                   @"urban":@[
                           @{@"urban":@"昌平公司",
                             @"county":@[]
                             },
                           @{
                               @"urban":@"海淀公司",
                               @"county":@[]
                               }
                           ]
                   },
                 @{@"city":@"广州公司",
                   @"urban":@[
                           @{@"urban":@"华强北公司",
                             @"county":@[]
                             },
                           @{
                               @"urban":@"soho公司",
                               @"county":@[]
                               }
                           ]
                   }
                 //               第二个数组结束括号
                 ],
             //             第三个数组开始
             @[
                 @{@"city":@"人事",
                   @"urban":@[]
                   },
                 @{@"city":@"财务",
                   @"urban":@[]
                   }
                 //               第三个数组结束括号
                 ]
             //             结束括号
             
             ];
}
#pragma mark-------delegate
-(void)selectLeftrow:(NSInteger)leftrow selectcenter:(BOOL)selectcenter selectcenterrow:(NSInteger)centerrow selectright:(BOOL)selectright selectrightrow:(NSInteger)rightrow
{
    NSLog(@"%@",@"选中");
}
