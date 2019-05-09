//
//  YXAnimationPageControl.h
//  CaiXinSDKExample
//
//  Created by zainguo on 2019/5/7.
//  Copyright © 2019 zainguo. All rights reserved.
//

#import <UIKit/UIKit.h>




NS_ASSUME_NONNULL_BEGIN


@class YXAnimationPageControl;
@protocol YXAnimationPageControlDelegate <NSObject>

- (void)YXAnimationPageControl:(YXAnimationPageControl *)pageControl
            didSelectPageIndex:(NSInteger)index;

@end


@interface YXAnimationPageControl : UIControl

@property(nonatomic, weak) id <YXAnimationPageControlDelegate> delegate;

/*
 分页数量
 */
@property(nonatomic, assign) NSInteger numberOfPages;
/*
 当前点所在下标
 */
@property(nonatomic, assign) NSInteger currentPage;
/*
 点的大小
 */
@property(nonatomic, assign) CGFloat controlSize;
/*
 点的间距
 */
@property(nonatomic, assign) CGFloat controlSpacing;
/*
 其他未选中点颜色
 */
@property(nonatomic, strong) UIColor *otherColor;
/*
 当前点颜色
 */
@property(nonatomic, strong) UIColor *currentColor;
/*
 当前点背景图片
 */
@property(nonatomic, strong) UIImage *currentBkImg;
/*
 其他未选中点背景图片
 */
@property(nonatomic, strong) UIImage *otherBkImg;


@end

NS_ASSUME_NONNULL_END
