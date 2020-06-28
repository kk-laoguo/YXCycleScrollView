
# 效果图
![效果图1](https://gitee.com/Tangchi/ZainPhotoCloud/raw/master/blogimage/KKScrollView.gif)
![效果图2](https://gitee.com/Tangchi/ZainPhotoCloud/raw/master/blogimage/YXCustomScrollView.gif)

# 特性

- 支持自定义`Cell`
- 支持上下、左右滚动
- 支持滚动缩放效果
- 支持XIB创建和属性设置
- 支持设置滚动间隙

# 安装

- ### `CocoaPods`
> pod 'YXCycleScrollView'

- ### 手动安装
> 将工程里`YXCycleScrollView`文件夹直接拖到项目即可

# 使用
- 导入`#import "YXCycleScrollView.h"`

```
    _images = images;
    _titles = titles;
    
    /// 样式一: 动画样式pageControl
    _cycleView1.imagesArray = images;
    __weak typeof(self) weakSelf = self;
    /// 点击事件回调 (支持block和代理)此处用的block
    _cycleView1.clickItemOperationBlock = ^(NSInteger currentIndex) {
        NSLog(@"-------------->点击了第%ld个", (long)currentIndex);
        [weakSelf.navigationController pushViewController:[NSClassFromString(@"CycleScrollViewController") new] animated:YES];
    };
    
    /// 样式二
    YXCycleScrollView *cycleView2 = [[YXCycleScrollView alloc] initWithFrame:CGRectMake(0, 170, kSCREEN_WIDTH, 150)];
    cycleView2.itemSpacing = 0;
    cycleView2.itemSize = CGSizeMake(kSCREEN_WIDTH - 40, cycleView2.frame.size.height);
    cycleView2.imagesArray = images;
    [self.scrollView addSubview:cycleView2];
    _cycleView2 = cycleView2;
    
    /// 样式二
    YXCycleScrollView *cycleView3 = [[YXCycleScrollView alloc] initWithFrame:CGRectMake(0, 170 + 170, kSCREEN_WIDTH, 150)];
    cycleView3.itemSpacing = 0;
    cycleView3.pageControlStyle = YXCycleScrollViewPageContolStyleAnimated;
    cycleView3.itemZoomScale = 0.85;
    cycleView3.itemSize = CGSizeMake(kSCREEN_WIDTH - 80, cycleView2.frame.size.height);
    cycleView3.imagesArray = images;
    [self.scrollView addSubview:cycleView3];
    _cycleView3 = cycleView3;

    /// 自定义样式 一定要设置并实现代理
    _cycleView4 = [[YXCycleScrollView alloc] initWithFrame:CGRectMake(0, 170 * 3, kSCREEN_WIDTH, 150)];
    _cycleView4.pageControlStyle = YXCycleScrollViewPageContolStyleAnimated;
    _cycleView4.pageControlAliment = YXCycleScrollViewPageContolAlimentRight;
    _cycleView4.imagesArray = images;
    _cycleView4.delegate = self;
    [self.scrollView addSubview:_cycleView4];

```

### YXCycleScrollViewDelegate

```
#pragma mark - YXCycleScrollViewDelegate
// 自定义Cell样式设置
- (UINib *)customCellNibForCycleScrollView:(YXCycleScrollView *)view {
return [UINib nibWithNibName:@"CustomCycleCell" bundle:nil];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(YXCycleScrollView *)cycleScrollView {
CustomCycleCell *cell1 = (CustomCycleCell *)cell;
[cell1.imgView sd_setImageWithURL:[NSURL URLWithString:_images[index]]];
cell1.titleLab.text = _titles[index];
}
// 点击回调
- (void)cycleScrollView:(YXCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
[self.navigationController pushViewController:[NSClassFromString(@"CycleScrollViewController") new] animated:YES];

}



```
#### 参考链接
[SDCycleScrollView](https://github.com/gsdios/SDCycleScrollView)




