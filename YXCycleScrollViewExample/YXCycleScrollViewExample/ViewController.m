//
//  ViewController.m
//  YXCycleScrollViewExample
//
//  Created by zainguo on 2019/5/9.
//  Copyright © 2019 zainguo. All rights reserved.
//

#import "ViewController.h"

#import "YXCycleScrollView.h"
#import "CustomCycleCell.h"
#import "UIImageView+WebCache.h"


#define kSCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface ViewController () <YXCycleScrollViewDelegate> {
    YXCycleScrollView *_cycleView2;
    YXCycleScrollView *_cycleView3;
    YXCycleScrollView *_cycleView4;
    YXCycleScrollView *_cycleView5;
    NSArray *_images;
    NSArray *_titles;
}

@property (weak, nonatomic) IBOutlet YXCycleScrollView *cycleView1;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_cycleView1 adjustWhenControllerViewWillAppear];
    [_cycleView2 adjustWhenControllerViewWillAppear];
    [_cycleView3 adjustWhenControllerViewWillAppear];
    [_cycleView4 adjustWhenControllerViewWillAppear];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *images = @[@"http://pic37.nipic.com/20140105/15166348_202320428000_2.jpg",
                        @"http://pic37.nipic.com/20140113/8800276_184927469000_2.png",
                        @"http://img.redocn.com/sheying/20140731/qinghaihuyuanjing_2820969.jpg",
                        @"http://pic29.nipic.com/20130517/9252150_140653449378_2.jpg",
                        @"http://pic36.nipic.com/20131126/8821914_071759099000_2.jpg"
                        ];
    
    NSArray *titles = @[@"我是自定义CollectionViewCell",
                        @"自定义Cell需要设置delegate, 并实现代理方法",
                        @"我是自定义CollectionViewCell",
                        @"自定义Cell需要设置delegate, 并实现代理方法",
                        @"我是自定义CollectionViewCell",
                        ];
    _images = images;
    _titles = titles;
//
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
    cycleView2.itemSpacing = 20;
    cycleView2.scrollDirection = UICollectionViewScrollDirectionVertical;
    cycleView2.itemSize = CGSizeMake(kSCREEN_WIDTH, cycleView2.frame.size.height);
    cycleView2.imagesArray = @[@"http://pic37.nipic.com/20140105/15166348_202320428000_2.jpg", @"http://pic36.nipic.com/20131126/8821914_071759099000_2.jpg"];
    [self.scrollView addSubview:cycleView2];
    _cycleView2 = cycleView2;
    
    /// 样式三
    YXCycleScrollView *cycleView3 = [[YXCycleScrollView alloc] initWithFrame:CGRectMake(0, 170 + 170, kSCREEN_WIDTH, 150)];
    cycleView3.itemSpacing = 0;
    cycleView3.pageControlStyle = YXCycleScrollViewPageContolStyleAnimated;
    cycleView3.itemZoomScale = 0.85;
    cycleView3.itemSize = CGSizeMake(kSCREEN_WIDTH - 80, cycleView2.frame.size.height);
    cycleView3.imagesArray = images;
    [self.scrollView addSubview:cycleView3];
    _cycleView3 = cycleView3;

    /// 自定义样式 一定要设置代理
    _cycleView4 = [[YXCycleScrollView alloc] initWithFrame:CGRectMake(0, 170 * 3, kSCREEN_WIDTH, 150)];
    _cycleView4.pageControlStyle = YXCycleScrollViewPageContolStyleAnimated;
    _cycleView4.pageControlAliment = YXCycleScrollViewPageContolAlimentRight;
    _cycleView4.imagesArray = images;
    _cycleView4.delegate = self;
    [self.scrollView addSubview:_cycleView4];
//
}

#pragma mark - YXCycleScrollViewDelegate
- (UINib *)customCellNibForCycleScrollView:(YXCycleScrollView *)view {
    return [UINib nibWithNibName:@"CustomCycleCell" bundle:nil];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(YXCycleScrollView *)cycleScrollView {
    CustomCycleCell *cell1 = (CustomCycleCell *)cell;
    [cell1.imgView sd_setImageWithURL:[NSURL URLWithString:_images[index]]];
    cell1.titleLab.text = _titles[index];
}

- (void)cycleScrollView:(YXCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    [self.navigationController pushViewController:[NSClassFromString(@"CycleScrollViewController") new] animated:YES];

}


@end
