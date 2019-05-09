//
//  YXCycleScrollView.m
//  CaiXinSDKExample
//
//  Created by zainguo on 2019/5/6.
//  Copyright © 2019 zainguo. All rights reserved.
//

#import "YXCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "YXCycleScrollViewFlowLayout.h"
#import "YXAnimationPageControl.h"


NSString *const IDENTIFI = @"YXCycleScrollViewCellIdentifier";

@interface YXCycleScrollView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) YXCycleScrollViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) UIControl *pageControl;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
/** 是否是自定义itemSize */
@property (nonatomic, assign) BOOL itemSizeFlag;
@property (nonatomic, assign) NSInteger indexOffset;
@property (nonatomic, assign) NSInteger fromIndex;
@end

@implementation YXCycleScrollView

#pragma mark - Intial Methods

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview && _timer) {
        [self pm_invalidateTimer];
    }
}

- (void)dealloc {
    
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self pm_addSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
        [self pm_addSubviews];
    }
    return self;
}

- (void)initialization {
    
    // 是否自动滚动
    _autoScroll = YES;
    // 是否无限循环
    _infiniteLoop = YES;
    // collectionView是否可以滑动
    _allowsDragging = YES;
    // 时间间隔
    _autoScrollInterval = 2.5f;
    // pageControl 小圆点大小
    _controlSize = 6;
    // pageControl 小圆点之间的间隙
    _controlSpacing = 8;
    // 分页控制器位置
    _pageControlAliment = YXCycleScrollViewPageContolAlimentCenter;
    // 分页控制器样式
    _pageControlStyle = YXCycleScrollViewPageContolStyleClassic;
    _imageViewContentMode = UIViewContentModeScaleToFill;
    _pageIndicatorolor = [UIColor grayColor];
    _currentPageIndicatorColor = [UIColor whiteColor];
    
}

- (void)pm_addSubviews {
    
    _flowLayout = [[YXCycleScrollViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 0.f;
    _flowLayout.minimumInteritemSpacing = 0.f;
    _flowLayout.headerReferenceSize = CGSizeZero;
    _flowLayout.footerReferenceSize = CGSizeZero;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = nil;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.scrollsToTop = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[YXCycleScrollViewCell class] forCellWithReuseIdentifier:IDENTIFI];
    
    [self addSubview:_collectionView];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _flowLayout.itemSize =  _itemSizeFlag ? _itemSize : self.bounds.size;
    _collectionView.frame = self.bounds;
    
    if (_collectionView.contentOffset.x == 0 &&
        _totalItemsCount) {
        int targetIndex = 0;
        targetIndex = _infiniteLoop ? _totalItemsCount * 0.5 : 0;
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:[self scrollPosition] animated:NO];
    }
    
    CGSize size = CGSizeZero;
    if ([_pageControl isKindOfClass:[YXAnimationPageControl class]]) {
        size = [self sizeForNumberOfPages:_imagesArray.count];
    } else {
        size = CGSizeMake(_imagesArray.count * 10 * 1.5, 10);
    }
    CGFloat x = (self.bounds.size.width - size.width) * 0.5;
    
    if (self.pageControlAliment == YXCycleScrollViewPageContolAlimentRight) {
        x = _collectionView.frame.size.width - size.width - 10;
    }
    CGFloat y = _collectionView.frame.size.height - size.height -10;
    
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    pageControlFrame.origin.y -= _pageControlBottomOffset;
    pageControlFrame.origin.x -= _pageControlRightOffset;
    _pageControl.frame = pageControlFrame;
    _pageControl.hidden = _hiddenPageControl;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YXCycleScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFI forIndexPath:indexPath];
    NSInteger index = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    
    if ([_delegate respondsToSelector:@selector(customCellClassForCycleScrollView:)] &&
        [_delegate respondsToSelector:@selector(setupCustomCell:forIndex:cycleScrollView:)] &&
        [_delegate customCellClassForCycleScrollView:self]) {
        [_delegate setupCustomCell:cell forIndex:index cycleScrollView:self];
        return cell;
        
    } else if ([_delegate respondsToSelector:@selector(customCellNibForCycleScrollView:)] &&
               [_delegate respondsToSelector:@selector(setupCustomCell:forIndex:cycleScrollView:)]
               && [_delegate customCellNibForCycleScrollView:self]) {
        [_delegate setupCustomCell:cell forIndex:index cycleScrollView:self];
        return cell;
    }
    cell.imageView.contentMode = _imageViewContentMode;
    if (_radius) {
        cell.imageView.layer.cornerRadius = _radius;
    }
    cell.imageView.layer.masksToBounds = YES;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_imagesArray[index]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [_delegate cycleScrollView:self didSelectItemAtIndex:[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    }
    if (_clickItemOperationBlock) {
        _clickItemOperationBlock([self pageControlIndexWithCurrentCellIndex:indexPath.item]);
    }
    
}

#pragma mark - Private Methods

- (void)pm_setupPageControl {
    
    if (_pageControl) {
        [_pageControl removeFromSuperview];
    }
    if (self.imagesArray.count == 0 || self.imagesArray.count == 1) {
        return;
    }
    
    NSInteger indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    switch (_pageControlStyle) {
        case YXCycleScrollViewPageContolStyleAnimated: {
            YXAnimationPageControl *pageControl = [[YXAnimationPageControl alloc] init];
            pageControl.numberOfPages = _imagesArray.count;
            pageControl.currentColor = _currentPageIndicatorColor;
            pageControl.otherColor = _pageIndicatorolor;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
        case YXCycleScrollViewPageContolStyleClassic: {
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = _imagesArray.count;
            pageControl.currentPageIndicatorTintColor = _currentPageIndicatorColor;
            pageControl.pageIndicatorTintColor = _pageIndicatorolor;
            pageControl.currentPage = indexOnPageControl;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
            
        default:
            break;
    }

}

- (void)pm_addTimer {
    
    [self pm_invalidateTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

- (void)pm_invalidateTimer {

    [_timer invalidate];
    _timer = nil;
    
}

- (void)pm_scrollToindex:(NSInteger)targetIndex {
    
    if (targetIndex >= _totalItemsCount) {
        if (_infiniteLoop) {
            // 滑动index 大于item总个数时
            targetIndex = _totalItemsCount * 0.5;
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:[self scrollPosition] animated:NO];
        }
        return;
    }
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:[self scrollPosition]  animated:YES];
}

#pragma mark - Target Methods

- (void)automaticScroll {
    
    if (0 == _totalItemsCount) {
        return;
    }
    NSInteger currentIndex = [self currentIndex];
    NSInteger targetIndex = currentIndex + 1;
    // 滚动item
    [self pm_scrollToindex:targetIndex];
}

#pragma mark - Setter Methods

- (void)setDelegate:(id<YXCycleScrollViewDelegate>)delegate {
    
    _delegate = delegate;
    if ([_delegate respondsToSelector:@selector(customCellClassForCycleScrollView:)] &&
        [_delegate customCellClassForCycleScrollView:self]) {
        [_collectionView registerClass:[_delegate customCellClassForCycleScrollView:self] forCellWithReuseIdentifier:IDENTIFI];
        
    } else if ([_delegate respondsToSelector:@selector(customCellNibForCycleScrollView:)] &&
               [_delegate customCellNibForCycleScrollView:self]) {
        [_collectionView registerNib:[_delegate customCellNibForCycleScrollView:self] forCellWithReuseIdentifier:IDENTIFI];
    }
    
}

- (void)setAutoScrollInterval:(double)autoScrollInterval {
    
    _autoScrollInterval = autoScrollInterval;
    [self setAutoScroll:self.autoScroll];
    
}

/** 是否无限循环,默认Yes */
- (void)setInfiniteLoop:(BOOL)infiniteLoop {
    
    _infiniteLoop = infiniteLoop;
    if (self.imagesArray.count) {
        self.imagesArray = self.imagesArray;
    }
}

/** 是否自动滚动,默认Yes */
- (void)setAutoScroll:(BOOL)autoScroll {
    
    _autoScroll = autoScroll;
    if (_autoScroll) {
        [self pm_addTimer];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    
    _scrollDirection = scrollDirection;
    _flowLayout.scrollDirection = scrollDirection;
}

#pragma mark - 数据源

- (void)setImagesArray:(NSArray<NSString *> *)imagesArray {
    
    _imagesArray = imagesArray;
    _totalItemsCount = self.infiniteLoop ? imagesArray.count * 100 : imagesArray.count;

    if (_imagesArray.count > 1) {
        _collectionView.scrollEnabled = _allowsDragging;
        [self setAutoScroll:self.autoScroll];
    } else {
        _collectionView.scrollEnabled = NO;
        [self pm_invalidateTimer];
    }
    [self pm_setupPageControl];
    [_collectionView reloadData];
    
}

#pragma mark - 自定义样式

- (void)setImageViewContentMode:(UIViewContentMode)imageViewContentMode {
    
    _imageViewContentMode = imageViewContentMode;
    [_collectionView reloadData];
}

- (void)setRadius:(CGFloat)radius {
    
    _radius = radius;
    [_collectionView reloadData];
}

- (void)setAllowsDragging:(BOOL)allowsDragging {
    
    _allowsDragging = allowsDragging;
    _collectionView.scrollEnabled = allowsDragging;

}

- (void)setHiddenPageControl:(BOOL)hiddenPageControl {
    
    _hiddenPageControl = hiddenPageControl;
    _pageControl.hidden = hiddenPageControl;
    
}

- (void)setItemSize:(CGSize)itemSize {
    
    _itemSizeFlag = YES;
    _itemSize = itemSize;
    _flowLayout.itemSize = itemSize;
    
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    
    _itemSpacing = itemSpacing;
    _flowLayout.minimumLineSpacing = itemSpacing;
    
}

- (void)setItemZoomScale:(CGFloat)itemZoomScale {
    
    _itemZoomScale = itemZoomScale;
    _flowLayout.zoomScale = itemZoomScale;
    
}

#pragma mark - PageController

- (void)setPageControlStyle:(YXCycleScrollViewPageContolStyle)pageControlStyle {
    
    if (_pageControlStyle == pageControlStyle ) return;
    _pageControlStyle = pageControlStyle;
    [self pm_setupPageControl];
    
}

- (void)setPageIndicatorolor:(UIColor *)pageIndicatorolor {
    
    _pageIndicatorolor = pageIndicatorolor;
    if ([self.pageControl isKindOfClass:[YXAnimationPageControl class]]) {
        YXAnimationPageControl *pageControl = (YXAnimationPageControl *)_pageControl;
        pageControl.otherColor = pageIndicatorolor;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.pageIndicatorTintColor = pageIndicatorolor;
    }
}

- (void)setCurrentPageIndicatorColor:(UIColor *)currentPageIndicatorColor {
    
    _currentPageIndicatorColor = currentPageIndicatorColor;
    if ([self.pageControl isKindOfClass:[YXAnimationPageControl class]]) {
        YXAnimationPageControl *pageControl = (YXAnimationPageControl *)_pageControl;
        pageControl.currentColor = currentPageIndicatorColor;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPageIndicatorTintColor = currentPageIndicatorColor;
    }
}

- (void)setPageControlBottomOffset:(CGFloat)pageControlBottomOffset {
    
    if (_pageControlBottomOffset == pageControlBottomOffset)  return;
    _pageControlBottomOffset = pageControlBottomOffset;
    [self setNeedsLayout];
}

- (void)setPageControlRightOffset:(CGFloat)pageControlRightOffset {
    
    if (_pageControlRightOffset == pageControlRightOffset)  return;
       
    _pageControlRightOffset = pageControlRightOffset;
    [self setNeedsLayout];
}

- (void)setControlSize:(CGFloat)controlSize {
    
    if (_controlSize == controlSize) return;
    _controlSize = controlSize;
    if ([_pageControl isKindOfClass:[YXAnimationPageControl class]]) {
        YXAnimationPageControl *pageControl = (YXAnimationPageControl *)_pageControl;
        pageControl.controlSize = controlSize;
    }
}

- (void)setControlSpacing:(CGFloat)controlSpacing {
    
    if (_controlSpacing == controlSpacing) return;
    _controlSpacing = controlSpacing;
    if ([_pageControl isKindOfClass:[YXAnimationPageControl class]]) {
        YXAnimationPageControl *pageControl = (YXAnimationPageControl *)_pageControl;
        pageControl.controlSpacing = controlSpacing;
    }
}

#pragma mark - Gtter Methods

- (NSInteger)currentIndex {
    
    if (_collectionView.frame.size.width == 0 ||
        _collectionView.frame.size.height == 0) {
        return 0;
    }
    NSInteger index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_collectionView.contentOffset.x + (_flowLayout.itemSize.width + _flowLayout.minimumLineSpacing) * 0.5) / (_flowLayout.itemSize.width + _flowLayout.minimumLineSpacing);
        
    } else {
        
        index = (_collectionView.contentOffset.y + (_flowLayout.itemSize.height + _flowLayout.minimumLineSpacing) * 0.5) / (_flowLayout.itemSize.height + _flowLayout.minimumLineSpacing);
    }
    return MAX(0, index);
    
}

- (UICollectionViewScrollPosition)scrollPosition {
    return _flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal ? UICollectionViewScrollPositionCenteredHorizontally : UICollectionViewScrollPositionCenteredVertically;
    
}

- (NSInteger)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
    return (NSInteger)index % self.imagesArray.count;
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount {
    return CGSizeMake((_controlSize + _controlSpacing) * pageCount - _controlSpacing, _controlSize);
}

#pragma mark - Public Methods

- (void)adjustWhenControllerViewWillAppear {
    
    NSInteger targetIndex = [self currentIndex];
    if (targetIndex < _totalItemsCount) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:[self scrollPosition] animated:NO];
    }
    
}
- (void)makeSccrollViewScrollToIndex:(NSInteger)index {
    
    if (0 == _totalItemsCount) return;
    [self pm_scrollToindex:(NSInteger)(_totalItemsCount * 0.5 + index)];
    if (_autoScroll) {
        [self pm_addTimer];
    }
}

#pragma mark - #pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!_imagesArray.count) {
        return;
    }
    NSInteger itemIndex = [self currentIndex];
    NSInteger indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    
    
    if ([_pageControl isKindOfClass:[YXAnimationPageControl class]]) {
        YXAnimationPageControl *pageControl = (YXAnimationPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_autoScroll) {
        [self pm_invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_autoScroll) {
        [self pm_addTimer];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (!_imagesArray.count) {
        return;
    }
    NSInteger itemIndex = [self currentIndex];
    NSInteger indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [_delegate cycleScrollView:self didScrollToIndex:indexOnPageControl];
    }
    if (_itemDidScrollOperationBlock) {
        _itemDidScrollOperationBlock(indexOnPageControl);
    }
    _fromIndex = itemIndex;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if ([self currentIndex] != _fromIndex) return;
    CGFloat sum = velocity.x + velocity.y;
    
    if (sum > 0) {
        _indexOffset = 1;
        
    } else if (sum < 0) {
        _indexOffset = -1;
        
    } else {
        _indexOffset = 0;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSInteger index = [self currentIndex] + _indexOffset;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:[self scrollPosition] animated:YES];
    _indexOffset = 0;
}

@end


#pragma mark - YXCycleScrollViewCell
@implementation YXCycleScrollViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
        [self.contentView addSubview:imageView];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

@end


