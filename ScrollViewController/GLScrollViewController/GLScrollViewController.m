//
//  GLScrollViewController.m
//  ScrollViewController
//
//  Created by GL on 2017/8/31.
//  Copyright © 2017年 GL. All rights reserved.
//

#import "GLScrollViewController.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define TopScHeight 44
#define BottomScHeight [UIScreen mainScreen].bounds.size.height - TopScHeight - 64
#define ButtonFont 16
#define LineHeght 2
#define GapOfButton 10.0  //按钮之间的间隔

@interface GLScrollViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *topScroll;
@property (nonatomic,strong) UIScrollView *bottomScroll;
@property (nonatomic,strong) UILabel *line;
@property (nonatomic,strong) NSMutableArray *centerArr; //保存标题中心点坐标的数组
@property (nonatomic,strong) NSMutableArray *widthArr; //保存标题宽度的数组
@property (nonatomic,assign) NSInteger finalPage; //当前页数(选中的按钮)下标
@property (nonatomic,assign) BOOL isBtnClick; //记录是否点击的标题

@end

@implementation GLScrollViewController

-(instancetype)init
{
    if (self = [super init]) {
        _scrollVCArr = [NSMutableArray array];
        _titleArr = [NSMutableArray array];
        _centerArr = [NSMutableArray array];
        _widthArr = [NSMutableArray array];
        _line = [[UILabel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
}

- (void)setUI
{
    _topScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, TopScHeight)];
    _topScroll.showsHorizontalScrollIndicator = NO;
    
    //根据传入字符串创建按钮，并计算contentSize
    //按钮的高与TopScroll一致
    float contenX = GapOfButton; //TopScroll的内容宽度
    for (int i =0 ; i < self.titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
        button.titleLabel.font  = [UIFont systemFontOfSize:ButtonFont];
        CGSize size = [button.currentTitle boundingRectWithSize:CGSizeMake(1000, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:ButtonFont]} context:nil].size;
        button.frame = CGRectMake(contenX, 0, size.width, TopScHeight - 4);
        contenX = button.frame.origin.x + size.width + GapOfButton;
        button.tag = 200 + i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topScroll addSubview:button];
        NSNumber *num = [NSNumber numberWithFloat:button.center.x];
        [_centerArr addObject:num];
        NSNumber *num2 = [NSNumber numberWithFloat:button.frame.size.width];
        [_widthArr addObject:num2];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        if (i == 0) {
            button.selected = YES;
            _finalPage = 0;
        }
    }
    _topScroll.contentSize = CGSizeMake(contenX, TopScHeight);
    [self.view addSubview:_topScroll];
    NSNumber *num = [_centerArr firstObject];
    NSNumber *num2 = [_widthArr firstObject];
    _line.frame = CGRectMake(num.floatValue - num2.floatValue/2, TopScHeight - LineHeght, num2.floatValue, LineHeght);
    [_topScroll addSubview:_line];
    _line.backgroundColor = [UIColor redColor];
    
    
    //布局底部滚动视图
    _bottomScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TopScHeight, ScreenWidth, BottomScHeight)];
    _bottomScroll.delegate = self;
    [self.view addSubview:_bottomScroll];
    _bottomScroll.contentSize = CGSizeMake(ScreenWidth * self.scrollVCArr.count, BottomScHeight);
    _bottomScroll.pagingEnabled = YES;
    _bottomScroll.clipsToBounds = YES;
    _bottomScroll.bounces = NO;
    
    for (int j = 0; j < self.scrollVCArr.count; j ++) {
        UIViewController *controller = self.scrollVCArr[j];
        // 1. 往父视图控制器中添加vc
        [self addChildViewController:controller];
        
        if (j == 0) {
            // 2. 将vc的view的x坐标偏移
            controller.view.frame = CGRectMake(ScreenWidth * j , 0, ScreenWidth, BottomScHeight);
            // 3. vc.view添加到scrollView上
            [_bottomScroll addSubview:controller.view];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_isBtnClick) {
        float needChange = 0;
        int a =0;
        for (int i = 0; i < _centerArr.count; i++) {
            NSNumber *num = _centerArr[i];
            
            if (num.floatValue >= _line.center.x) {
                if (i-1>=0) {
                    needChange = [_centerArr[i] floatValue] - [_centerArr[i-1] floatValue];
                    //NSLog(@"%f",needChange);
                    a = i;
                    break;
                }
            }
        }
        
        float offset = 0;
        offset = needChange/ScreenWidth *(scrollView.contentOffset.x - (a -1) *ScreenWidth);
        if (a != 0) {
            _line.center = CGPointMake([_centerArr[a -1] floatValue] +  offset, TopScHeight - LineHeght/2.0);
        }
        _line.bounds = CGRectMake(0, 0, [_widthArr[a -1] floatValue] + ([_widthArr[a] floatValue] - [_widthArr[a - 1] floatValue])/ScreenWidth *(scrollView.contentOffset.x - (a -1) *ScreenWidth), LineHeght);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        _finalPage = (NSInteger)scrollView.contentOffset.x/ScreenWidth;
        [self changeTop];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UIButton *oldBtn = (UIButton *)[_topScroll viewWithTag:200 + _finalPage];
    oldBtn.selected = NO; //将之前的按钮变为不选中
    
    _finalPage = (NSInteger)scrollView.contentOffset.x/ScreenWidth;
    [self changeTop];
    UIButton *currentBtn = (UIButton *)[_topScroll viewWithTag:200 + _finalPage];
    currentBtn.selected = YES;
    
    //懒加载的方式添加子视图控制器的view
    //优点：1、滚动到该页才添加View，此时才执行viewDidLoad；
    //     2、网络请求一般放在viewDidLoad，可保证滚动之后才进行网络请求，且只请求一次
    UIViewController *vc = self.childViewControllers[_finalPage];
    if (!vc.isViewLoaded) { //如果视图未加载过，则添加到scrollView
        vc.view.frame = CGRectMake(ScreenWidth * _finalPage, 0, ScreenWidth, BottomScHeight);
        [scrollView addSubview:vc.view];
    }
}

//改变顶部scrollView偏移量
- (void)changeTop
{
    _isBtnClick = NO;
    float x = [_centerArr[_finalPage] floatValue];
    [UIView animateWithDuration:0.3 animations:^{
        if (x>ScreenWidth/2.0 && x<_topScroll.contentSize.width - ScreenWidth/2.0) {
            _topScroll.contentOffset = CGPointMake(x-ScreenWidth/2.0, 0);
        }
        else if (x>=_topScroll.contentSize.width - ScreenWidth/2.0) {
            _topScroll.contentOffset = CGPointMake(_topScroll.contentSize.width - ScreenWidth, 0);
        }
        else{
            _topScroll.contentOffset = CGPointMake(0, 0);
        }
    }];
}
//点击标题
- (void)btnClick:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    button.selected = YES;
    UIButton *oldBtn = (UIButton *)[_topScroll viewWithTag:200 + _finalPage];
    oldBtn.selected = NO; //将之前的按钮变为不选中
    _isBtnClick = YES;
    _finalPage = button.tag - 200; //记录新的下标
    
    [self changeBottom];
    [self changeTop];
    [self changeLine];
    //[self changeLineWithBtn:button];
}

- (void)changeLineWithBtn:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        _line.bounds = CGRectMake(0, 0, btn.frame.size.width, LineHeght);
        _line.center = CGPointMake(btn.center.x, TopScHeight - LineHeght/2.0);
    } completion:^(BOOL finished) {
        
    }];
}
//改变指示线的坐标
- (void)changeLine
{
    [UIView animateWithDuration:0.3 animations:^{
        _line.frame = CGRectMake([_centerArr[_finalPage] floatValue] -[_widthArr[_finalPage] floatValue]/2.0, TopScHeight - LineHeght, [_widthArr[_finalPage] floatValue], LineHeght);
    } completion:^(BOOL finished) {
        
    }];
}
//改变底部scrollView的偏移量
- (void)changeBottom
{
    UIViewController *vc = self.childViewControllers[_finalPage];
    if (!vc.isViewLoaded) { //如果视图未加载过，则添加到scrollView
        vc.view.frame = CGRectMake(ScreenWidth * _finalPage, 0, ScreenWidth, BottomScHeight);
        [_bottomScroll addSubview:vc.view];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _bottomScroll.contentOffset = CGPointMake(ScreenWidth * _finalPage, 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
