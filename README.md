# GLScrollViewController
### 示例:
-----

![img](https://github.com/shuizhuyu1015/GLScrollViewController/blob/master/ScrollViewController/test.gif)

### 特性：
-----

1、采用懒加载的方式布局的滚动视图控制器，滑动减速再进行网络请求；

2、标题下滑线可根据标题长度自动伸缩；

### 下载安装：
-----

下载之后，将 GLScrollViewController 文件夹拖到自己的工程中，在需要引用的页面#import "GLScrollViewController"即可。

### 使用方法：
-----

```
@interface GLScrollViewController : UIViewController
//两个数组元素个数要相同
@property (nonatomic,strong) NSMutableArray *scrollVCArr; //视图控制器数组
@property (nonatomic,strong) NSMutableArray *titleArr; //标题数组
@end
```

初始化，并传入两个数组即可

```
    GLScrollViewController *gvc = [[GLScrollViewController alloc] init];
    
    NSArray *arr = @[@"精选",@"焕新衣",@"大V直播",@"品牌订阅",@"视频购",@"问答",@"私人定制清单",@"活动社区",@"生活",@"数码",@"亲子",@"风尚标",@"美食街"];
    
    for (int i = 0; i < arr.count; i++) {
    
        AViewController *avc = [[AViewController alloc] init];
        
        [gvc.scrollVCArr addObject:avc];
        
    }
    
    gvc.titleArr = [NSMutableArray arrayWithArray:arr];
    
    [self.navigationController pushViewController:gvc animated:YES];
    
```
