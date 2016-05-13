//
//  ListView.h
//  读单词View
//
//  Created by jingdi on 16/5/13.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WordModel;

typedef NS_ENUM(NSUInteger, PlayMode) {
    PlayModeAutomatic,      // 自动模式
    PlayModeManual,         // 手动模式
};

@interface ListView : UIView

- (instancetype)initWithFrame:(CGRect)frame model:(NSArray<WordModel *> *)model type:(PlayMode)type;

@end
