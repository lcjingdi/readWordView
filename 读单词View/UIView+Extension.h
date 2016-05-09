//
//  UIView+Extension.h
//  EKWStudent
//
//  Created by 景迪 on 16/4/28.
//  Copyright © 2016年 ekwing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

/** x坐标 */
@property (nonatomic, assign) CGFloat x;

/** y坐标 */
@property (nonatomic, assign) CGFloat y;

/** 宽度 */
@property (nonatomic, assign) CGFloat width;

/** 高度 */
@property (nonatomic, assign) CGFloat height;

/** 大小 */
@property (nonatomic, assign) CGSize size;

/** 位置 */
@property (nonatomic, assign) CGPoint origin;

/** 中心点X */
@property (nonatomic, assign) CGFloat centerX;

/** 中心点Y */
@property (nonatomic, assign) CGFloat centerY;

@end
