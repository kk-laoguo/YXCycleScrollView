//
//  YXCycleScrollView.h
//  CaiXinSDKExample
//
//  Created by zainguo on 2019/5/6.
//  Copyright © 2019 zainguo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, YXCycleScrollViewPageContolStyle) {
    YXCycleScrollViewPageContolStyleClassic = 0,        // 系统自带经典样式
    YXCycleScrollViewPageContolStyleAnimated,       // 动画效果pagecontrol
    YXCycleScrollViewPageContolStyleNone
};

typedef NS_ENUM(NSUInteger, YXCycleScrollViewPageContolAliment) {
    YXCycleScrollViewPageContolAlimentCenter = 0,
    YXCycleScrollViewPageContolAlimentRight,
};

@class YXCycleScrollView;

@protocol YXCycleScrollViewDelegate <NSObject>

@optional;

/** 点击图片回调 */
- (void)cycleScrollView:(YXCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
/** 图片滚动回调 */
- (void)cycleScrollView:(YXCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;

// ========== 轮播自定义cell ==========
/** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的class。 */
- (Class)customCellClassForCycleScrollView:(YXCycleScrollView *)view;
/** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的Nib。 */
- (UINib *)customCellNibForCycleScrollView:(YXCycleScrollView *)view;

/** 如果你自定义了cell样式，请在实现此代理方法为你的cell填充数据以及其它一系列设置 */
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(YXCycleScrollView *)cycleScrollView;

@end


IB_DESIGNABLE
@interface YXCycleScrollView : UIView

@property (nullable, nonatomic, weak) IBOutlet id<YXCycleScrollViewDelegate> delegate;

/** 自动滚动间隔时间,默认2.5s */
@property (nonatomic, assign) IBInspectable double autoScrollInterval;
/** 是否无限循环,默认Yes */
@property (nonatomic,assign) IBInspectable BOOL infiniteLoop;
/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) IBInspectable BOOL autoScroll;


#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSInteger scrollDirection;

#else
/** 图片滚动方向，默认为水平滚动 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
#endif


#pragma mark - 数据源
/** 网络图片 url string 数组 */
@property (nonatomic, strong) NSArray <NSString *> *imagesArray;


#pragma mark - 自定义样式

/** 默认Yes，默认collectionView可以滑动 */
@property (nonatomic, assign) IBInspectable BOOL allowsDragging;
/** 默认No，是否隐藏pageController */
@property (nonatomic, assign) IBInspectable BOOL hiddenPageControl;
/** 默认 view size */
@property (nonatomic, assign) IBInspectable CGSize  itemSize;
/** 默认 间距 0.f */
@property (nonatomic, assign) IBInspectable CGFloat itemSpacing;
/** 默认 1.f(no scaling), it ranges from 0.f to 1.f */
@property (nonatomic, assign) IBInspectable CGFloat itemZoomScale;
/** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
@property (nonatomic, assign) UIViewContentMode imageViewContentMode;
/** 轮播图片圆角默认: 0 **/
@property (nonatomic, assign) CGFloat radius;


#pragma mark - PageController

#if TARGET_INTERFACE_BUILDER
/** 分页控制器位置 */
@property (nonatomic, assign) IBInspectable NSInteger pageControlAliment;
/** 分页控制器样式 */
@property (nonatomic, assign) IBInspectable NSInteger pageControlStyle;

#else
/** 分页控制器位置 */
@property (nonatomic, assign) YXCycleScrollViewPageContolAliment pageControlAliment;
/** 分页控制器样式 */
@property (nonatomic, assign) YXCycleScrollViewPageContolStyle pageControlStyle;

#endif

/** 默认gray */
@property (nonatomic, strong) IBInspectable UIColor *pageIndicatorolor;
/** 默认白色 */
@property (nonatomic, strong) IBInspectable UIColor *currentPageIndicatorColor;

/** 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量 默认: 0 */
@property (nonatomic, assign) CGFloat pageControlBottomOffset;

/** 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量 默认: 0 */
@property (nonatomic, assign) CGFloat pageControlRightOffset;

//////////////////////// 只针对动画样式下的pageControl //////////////////////////
/** 点的大小默认: 6 */
@property(nonatomic, assign) CGFloat controlSize;
/** 点的间距默认: 8 */
@property(nonatomic, assign) CGFloat controlSpacing;

/** block方式监听点击 */
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);
/** block方式监听滚动 */
@property (nonatomic, copy) void (^itemDidScrollOperationBlock)(NSInteger currentIndex);
/** 可以调用此方法手动控制滚动到哪一个index */
- (void)makeSccrollViewScrollToIndex:(NSInteger)index;
/** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
- (void)adjustWhenControllerViewWillAppear;

@end



NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface YXCycleScrollViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@end
NS_ASSUME_NONNULL_END
