
//
//  EKWPersonVC.h
//  EKWStudent
//
//  Created by chen on 14-7-11.
//  Copyright (c) 2014年 ekwing. All rights reserved.
//


/** 按钮上的进度条 */
#import <UIKit/UIKit.h>

@protocol EKWButtonSwimDelegate <NSObject>

@optional
- (void)beginAnimation;
- (void)endAnimation;

@end

@interface EKWButtonSwim : UIButton

//持续时间
@property (nonatomic, assign) CGFloat durationValue;

@property (nonatomic, assign) CGFloat currentValue;
@property (nonatomic, assign) CGFloat allValue;
@property (nonatomic, assign) CGFloat progress;
/**线条颜色*/
@property (nonatomic, strong) UIColor *lineColor;
/**控制进度的线条宽度*/
@property (nonatomic, assign) CGFloat bordWidth;
/**控制而进度圆的半径宽带*/
@property (nonatomic, assign) CGFloat progressWidth;

@property (nonatomic, weak) id<EKWButtonSwimDelegate> delegate;
@end
