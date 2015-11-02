//
//  BigSmallView.m
//  ADWSP
//
//  Created by AodianYun on 15/10/20.
//  Copyright (c) 2015年 aodianyun. All rights reserved.
//

#import "BigSmallView.h"

@interface BigSmallView ()
@property (strong, nonatomic) UIView* smallViewWrap;
@end

@implementation BigSmallView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupViews];
    }
    return self;
}
- (BOOL) hideSmallView
{
    return _smallViewWrap.hidden;
}
- (void) setHideSmallView:(BOOL) hideSmallView
{
    _smallViewWrap.hidden = hideSmallView;
}
- (void) setupViews
{
    _smallViewWrap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 158)];
    _smallViewWrap.backgroundColor = [UIColor whiteColor];
    CALayer *lay  = _smallViewWrap.layer;
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:5];
    [self addSubview:_smallViewWrap];
    _isFirstMajor = YES;
    self.hideSmallView = NO;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = _smallViewWrap.frame;
    frame.origin.x = self.frame.size.width - frame.size.width - 8;
    frame.origin.y = self.frame.size.height - frame.size.height - 10;
    _smallViewWrap.frame = frame;
    [self refleshViewSize];
}
- (void) setFirstView:(UIView *)firstView
{
    _firstView = firstView;
    [self refleshViewSize];
}
- (void) setSecondView:(UIView *)secondView
{
    _secondView = secondView;
    [self refleshViewSize];
}
- (void) refleshViewSize
{
    if (_isFirstMajor) {
        [self setFirstViewMajor];
    } else {
        [self setSecondViewMajor];
    }
}
- (void) setFirstViewMajor
{
    if (_firstView) {
        [_firstView removeFromSuperview];
        _firstView.frame = self.bounds;
        _firstView.bounds = self.bounds;
        [self addSubview:_firstView];
    }
    if (_secondView) {
        [_secondView removeFromSuperview];
        _secondView.frame = CGRectMake(3, 3, _smallViewWrap.frame.size.width - 6, _smallViewWrap.frame.size.height - 6);
        _secondView.bounds = CGRectMake(0, 0, _smallViewWrap.frame.size.width - 6, _smallViewWrap.frame.size.height - 6);
        [_smallViewWrap addSubview:_secondView];
    }
    [self bringSubviewToFront:_smallViewWrap];
    _isFirstMajor = YES;
}
- (void) setSecondViewMajor
{
    if (_firstView) {
        [_firstView removeFromSuperview];
        _firstView.frame = CGRectMake(3, 3, _smallViewWrap.frame.size.width - 6, _smallViewWrap.frame.size.height - 6);
        _firstView.bounds = CGRectMake(0, 0, _smallViewWrap.frame.size.width - 6, _smallViewWrap.frame.size.height - 6);
        [_smallViewWrap addSubview:_firstView];
    }
    if (_secondView) {
        [_secondView removeFromSuperview];
        _secondView.frame = self.bounds;
        _secondView.bounds = self.bounds;
        [self addSubview:_secondView];
    }
    [self bringSubviewToFront:_smallViewWrap];
    _isFirstMajor = NO;
}
- (void) switchMajorView
{
    if (_isFirstMajor) {
        [self setSecondViewMajor];
    } else {
        [self setFirstViewMajor];
    }
}
@end
