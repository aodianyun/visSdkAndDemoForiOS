//
//  BigSmallView.h
//  ADWSP
//
//  Created by AodianYun on 15/10/20.
//  Copyright (c) 2015年 aodianyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigSmallView : UIView
@property (weak, nonatomic) UIView* firstView;
@property (weak, nonatomic) UIView* secondView;
@property (readonly, nonatomic) BOOL isFirstMajor;
@property (assign, nonatomic) BOOL hideSmallView;
- (void) setFirstViewMajor;
- (void) setSecondViewMajor;
- (void) switchMajorView;
@end
