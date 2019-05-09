//
//  CycleScrollViewController.m
//  YXCycleScrollViewExample
//
//  Created by zainguo on 2019/5/7.
//  Copyright © 2019 zainguo. All rights reserved.
//

#import "CycleScrollViewController.h"
#import "CustomCycleCell.h"
#import "TextCell.h"
#import "YXCycleScrollView.h"
#import "UIImageView+WebCache.h"


@interface CycleScrollViewController () <YXCycleScrollViewDelegate> {
    NSArray *_images;
    NSArray *_titles;
}
@property (weak, nonatomic) IBOutlet YXCycleScrollView *cycleScrollView1;
@property (weak, nonatomic) IBOutlet YXCycleScrollView *cycleScrollView2;

@end

@implementation CycleScrollViewController

- (void)dealloc {
    NSLog(@"------------------->%@释放了\n\n\n", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /// cycleScrollView1的代理在xib里面已经添加过了
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
    
    _cycleScrollView1.imagesArray = _images;
    _cycleScrollView2.imagesArray = _titles;
//    _cycleScrollView2.allowsDragging = NO;
    

}
#pragma mark - YXCycleScrollViewDelegate
- (UINib *)customCellNibForCycleScrollView:(YXCycleScrollView *)view {
    if (view.tag == 100) {
        return [UINib nibWithNibName:@"CustomCycleCell" bundle:nil];
    }
    return [UINib nibWithNibName:@"TextCell" bundle:nil];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(YXCycleScrollView *)cycleScrollView {
    
    if (cycleScrollView.tag == 100) {
        
        CustomCycleCell *cell1 = (CustomCycleCell *)cell;
        [cell1.imgView sd_setImageWithURL:[NSURL URLWithString:_images[index]]];
        cell1.titleLab.text = _titles[index];
        
    } else {
        TextCell *cell2 = (TextCell *)cell;
        cell2.textLab.text = _titles[index];
    }


}



@end
