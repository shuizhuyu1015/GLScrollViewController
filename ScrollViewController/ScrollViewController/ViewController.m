//
//  ViewController.m
//  ScrollViewController
//
//  Created by GL on 2017/8/31.
//  Copyright © 2017年 GL. All rights reserved.
//

#import "ViewController.h"
#import "GLScrollViewController.h"
#import "AViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"滚动视图控制器";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (IBAction)openScrollVC:(UIButton *)sender {
    
    GLScrollViewController *gvc = [[GLScrollViewController alloc] init];
    NSArray *arr = @[@"精选",@"焕新衣",@"大V直播",@"品牌订阅",@"视频购",@"问答",@"私人定制清单",@"活动社区",@"生活",@"数码",@"亲子",@"风尚标",@"美食街"];
    for (int i = 0; i < arr.count; i++) {
        AViewController *avc = [[AViewController alloc] init];
        [gvc.scrollVCArr addObject:avc];
    }
    gvc.titleArr = [NSMutableArray arrayWithArray:arr];
    [self.navigationController pushViewController:gvc animated:YES];
    
    /** 如要创建不同布局的分页，可如下：
    NSArray *vcArr = @[@"AViewController",
                       @"BViewController",
                       @"CViewController",
                       @"DViewController",
                       @"EViewController",
                       @"FViewController"];
    for (NSString *vcStr in vcArr) {
        UIViewController *vc = [[NSClassFromString(vcStr) alloc] init];
        [gvc.scrollVCArr addObject:vc];
    }
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
