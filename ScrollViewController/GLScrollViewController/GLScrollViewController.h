//
//  GLScrollViewController.h
//  ScrollViewController
//
//  Created by GL on 2017/8/31.
//  Copyright © 2017年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLScrollViewController : UIViewController
//两个数组元素个数要相同
@property (nonatomic,strong) NSMutableArray *scrollVCArr; //视图控制器数组
@property (nonatomic,strong) NSMutableArray *titleArr; //标题数组

@end
