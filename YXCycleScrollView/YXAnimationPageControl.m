//
//  YXAnimationPageControl.m
//  CaiXinSDKExample
//
//  Created by zainguo on 2019/5/7.
//  Copyright © 2019 zainguo. All rights reserved.
//

#import "YXAnimationPageControl.h"


static NSInteger const DotTag = 1000;
static NSInteger const DotBgImageTag = 2000;

@implementation YXAnimationPageControl

#pragma mark - Intial Methods
- (instancetype)init{
    
    if(self = [super init]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.backgroundColor = [UIColor clearColor];
    _numberOfPages = 0;
    _currentPage = 0;
    _controlSize = 6;
    _controlSpacing = 8;
    _otherColor = [UIColor grayColor];
    _currentColor = [UIColor whiteColor];
    
}

- (void)pm_setupDotView {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_numberOfPages <= 0) return;
    
    CGFloat startX = 0;
    CGFloat startY = 0;
    CGFloat mainWidth = _numberOfPages * (_controlSize + _controlSpacing);
    if (self.frame.size.width < mainWidth) {
        startX = 0;
    } else {
        startX = (self.frame.size.width - mainWidth) / 2;
    }
    if (self.frame.size.height < _controlSize) {
        startY = 0;
    } else {
        startY = (self.frame.size.height - _controlSize) / 2;
    }
    for (NSInteger page = 0; page < _numberOfPages; page ++) {
        
        UIView *dot = [[UIView alloc]initWithFrame:CGRectMake(startX, startY, _controlSize, _controlSize)];
        dot.backgroundColor = _otherColor;
        dot.tag = page + DotTag;
        dot.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dotClickAction:)];
        [dot addGestureRecognizer:tap];
        [self addSubview:dot];
        
        UIImageView *bgImgView = [UIImageView new];
        
        if (page == _currentPage) {
            
            dot.bounds = CGRectMake(0, 0, _controlSize * 2, _controlSize);
            dot.backgroundColor = _currentColor;
            
            if (_currentBkImg) {
                dot.backgroundColor = [UIColor clearColor];
                bgImgView.frame = dot.bounds;
                bgImgView.tag = DotBgImageTag;
                bgImgView.image = _currentBkImg;
                [dot addSubview:bgImgView];
            }
        }
        dot.layer.cornerRadius = _controlSize * 0.5;
        dot.layer.masksToBounds = YES;
        startX = CGRectGetMaxX(dot.frame) + _controlSpacing;
    }
}

- (void)pm_dotViewFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    UIView *fromDot = [self viewWithTag:fromIndex + DotTag];
    CGRect fromDotRect = fromDot.frame;
    
    UIView *toDot = [self viewWithTag:toIndex + DotTag];
    CGRect toDotRect = toDot.frame;
    
    fromDot.backgroundColor = _otherColor;
    toDot.backgroundColor = _currentColor;
    
    if (_currentBkImg) {
        
        UIView *imgview = [fromDot viewWithTag:DotBgImageTag];
        [imgview removeFromSuperview];
        
        toDot.backgroundColor = [UIColor clearColor];
        UIImageView *currBkImg = [UIImageView new];
        currBkImg.tag = DotBgImageTag;
        currBkImg.frame = CGRectMake(0, 0, fromDotRect.size.width, fromDotRect.size.height);
        currBkImg.image = _currentBkImg;
        [toDot addSubview:currBkImg];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGFloat fromX = fromDotRect.origin.x;
        if (toIndex < fromIndex) {
            fromX += self->_controlSize;
        }
        fromDot.frame = CGRectMake(fromX, fromDotRect.origin.y, self->_controlSize, self->_controlSize);
        CGFloat toX = toDotRect.origin.x;
        if (toIndex > fromIndex) {
            toX -= self->_controlSize;
        }
        toDot.frame = CGRectMake(toX, toDotRect.origin.y, self->_controlSize * 2, self->_controlSize);
        // 左边的时候到右边 越过点击
        if (toX - fromX > 1) {
            
            for (NSInteger t = fromIndex + 1; t < toIndex; t ++) {
                
                UIView *newView = [self viewWithTag:DotTag + t];
                newView.frame = CGRectMake(newView.frame.origin.x - self->_controlSize, newView.frame.origin.y, self->_controlSize, self->_controlSize);
            }
        }
        // 右边选中到左边的时候 越过点击
        if (toX - fromX < -1) {
            
            for (NSInteger t = toIndex + 1; t < fromIndex; t ++) {
                
                UIView *newView = [self viewWithTag:DotTag + t];
                newView.frame = CGRectMake(newView.frame.origin.x + self->_controlSize, newView.frame.origin.y, self->_controlSize, self->_controlSize);
            }
        }
    }];
}

#pragma mark - Target Methods
- (void)dotClickAction:(UITapGestureRecognizer *)tap {
    
    NSInteger index = tap.view.tag - DotTag;
    [self setCurrentPage:index];
}
#pragma mark - Setter
- (void)setNumberOfPages:(NSInteger)numberOfPages {
    
    if (_numberOfPages == numberOfPages) return;
    _numberOfPages = numberOfPages;
    [self pm_setupDotView];
}
- (void)setCurrentPage:(NSInteger)currentPage {
    
    if (_currentPage == currentPage) return;
    if ([_delegate respondsToSelector:@selector(YXAnimationPageControl:didSelectPageIndex:)]) {
        [_delegate YXAnimationPageControl:self didSelectPageIndex:currentPage];
    }
    [self pm_dotViewFromIndex:_currentPage toIndex:currentPage];
    _currentPage = currentPage;
}

- (void)setControlSize:(CGFloat)controlSize {
    
    if (_controlSize != controlSize) {
        _controlSize = controlSize;
        [self pm_setupDotView];
    }
}
- (void)setControlSpacing:(CGFloat)controlSpacing {
    
    if (_controlSpacing != controlSpacing) {
        _controlSpacing = controlSpacing;
        [self pm_setupDotView];
    }
}

- (void)setOtherColor:(UIColor *)otherColor {
    
    if (![self isTheSameColor:otherColor anotherColor:_otherColor]) {
        _otherColor = otherColor;
        [self pm_setupDotView];
    }
}

- (void)setCurrentColor:(UIColor *)currentColor {
    
    if (![self isTheSameColor:currentColor anotherColor:_currentColor]) {
        _currentColor = currentColor;
        [self pm_setupDotView];
    }
}

- (void)setCurrentBkImg:(UIImage *)currentBkImg {
    
    if (_currentBkImg != currentBkImg) {
        _currentBkImg = currentBkImg;
        [self pm_setupDotView];
    }
}

- (void)setOtherBkImg:(UIImage *)otherBkImg {
    
    if (_otherBkImg != otherBkImg) {
        _otherBkImg = otherBkImg;
        [self pm_setupDotView];
    }
}

#pragma mark - Getter Methods
- (BOOL)isTheSameColor:(UIColor*)color1 anotherColor:(UIColor*)color2{
    return CGColorEqualToColor(color1.CGColor, color2.CGColor);
}

@end
